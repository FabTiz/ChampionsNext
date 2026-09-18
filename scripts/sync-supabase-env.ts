import { spawn } from "node:child_process";
import { existsSync } from "node:fs";
import { mkdir, readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";

type SupabaseStatus = {
  API_URL: string;
  PUBLISHABLE_KEY: string;
  SECRET_KEY: string;
};

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const repoRoot = path.resolve(scriptDir, "..");
const databaseDir = path.join(repoRoot, "apps/database");
// `next dev` uses `apps/web` as its project directory, so Next only reads env
// files from there (the root files are never loaded by the web app). The root
// file is kept for scripts and tooling, which also use the server-only secret.
const envTargets: { path: string; keys: (keyof SupabaseStatus)[] }[] = [
  {
    path: path.join(repoRoot, ".env.local"),
    keys: ["API_URL", "PUBLISHABLE_KEY", "SECRET_KEY"],
  },
  {
    path: path.join(repoRoot, "apps/web/.env.local"),
    keys: ["API_URL", "PUBLISHABLE_KEY"],
  },
];

async function main(): Promise<void> {
  const statusOutput = await runSupabaseStatus();
  const status = parseSupabaseStatus(statusOutput);

  for (const target of envTargets) {
    await updateEnvFile(target.path, status, target.keys);
  }

  process.stdout.write(
    `Updated Supabase env files (${envTargets
      .map((target) => path.relative(repoRoot, target.path))
      .join(", ")}) with the API URL and keys from ${path.relative(
      repoRoot,
      databaseDir,
    )}.\n`,
  );
}

function runSupabaseStatus(): Promise<string> {
  return new Promise((resolve, reject) => {
    // `apps/database` depends on the `supabase` CLI package, whose `bin` entry
    // is `dist/supabase.js`. Running that script with the current Node
    // executable avoids the Windows `.cmd` shim problem entirely: `spawn` fails
    // with ENOENT on the bare name and EINVAL on `pnpm.cmd`, while going through
    // a shell would reintroduce argument-escaping issues (DEP0190).
    const supabaseCliPath = path.join(
      databaseDir,
      "node_modules",
      "supabase",
      "dist",
      "supabase.js",
    );

    const child = spawn(
      process.execPath,
      [supabaseCliPath, "status", "--output", "json"],
      {
        cwd: databaseDir,
        env: process.env,
        stdio: ["ignore", "pipe", "pipe"],
      },
    );

    let stdout = "";
    let stderr = "";

    child.stdout.setEncoding("utf8");
    child.stderr.setEncoding("utf8");
    child.stdout.on("data", (chunk) => {
      stdout += chunk;
    });
    child.stderr.on("data", (chunk) => {
      stderr += chunk;
    });
    child.on("error", reject);
    child.on("close", (code) => {
      if (code !== 0) {
        reject(
          new Error(
            `supabase status failed with exit code ${code ?? "unknown"}.\n${stderr || stdout}`,
          ),
        );
        return;
      }
      resolve(stdout.trim() || stderr.trim());
    });
  });
}

function parseSupabaseStatus(output: string): SupabaseStatus {
  const jsonBlock = extractJsonBlock(output);
  if (!jsonBlock) {
    throw new Error(
      `Could not find JSON in Supabase status output:\n${output}`,
    );
  }

  const parsed = JSON.parse(jsonBlock) as Record<string, unknown>;
  const publishableKey = readStringValue(parsed, "PUBLISHABLE_KEY");
  const secretKey = readStringValue(parsed, "SECRET_KEY");
  const apiUrl = readStringValue(parsed, "API_URL");

  return {
    API_URL: apiUrl,
    PUBLISHABLE_KEY: publishableKey,
    SECRET_KEY: secretKey,
  };
}

function readStringValue(record: Record<string, unknown>, key: string): string {
  const value = record[key];
  if (typeof value !== "string" || value.length === 0) {
    throw new Error(
      `Expected "${key}" to be a non-empty string in Supabase status output.`,
    );
  }
  return value;
}

function extractJsonBlock(text: string): string | null {
  for (let start = 0; start < text.length; start += 1) {
    const open = text[start];
    if (open !== "{" && open !== "[") {
      continue;
    }

    let depth = 0;
    let inString = false;
    let escaped = false;

    for (let index = start; index < text.length; index += 1) {
      const char = text[index];

      if (inString) {
        if (escaped) {
          escaped = false;
        } else if (char === "\\") {
          escaped = true;
        } else if (char === '"') {
          inString = false;
        }
        continue;
      }

      if (char === '"') {
        inString = true;
        continue;
      }

      if (char === "{" || char === "[") {
        depth += 1;
      } else if (char === "}" || char === "]") {
        depth -= 1;
        if (depth === 0) {
          return text.slice(start, index + 1);
        }
      }
    }
  }

  return null;
}

async function updateEnvFile(
  filePath: string,
  values: SupabaseStatus,
  keys: (keyof SupabaseStatus)[],
): Promise<void> {
  const currentContent = existsSync(filePath)
    ? await readFile(filePath, "utf8")
    : "";
  const nextContent = rewriteEnvFile(currentContent, values, keys);

  if (currentContent !== nextContent) {
    await mkdir(path.dirname(filePath), { recursive: true });
    await writeFile(filePath, nextContent, "utf8");
  }
}

const envKeyByStatusKey: Record<keyof SupabaseStatus, string> = {
  API_URL: "NEXT_PUBLIC_SUPABASE_URL",
  PUBLISHABLE_KEY: "NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY",
  SECRET_KEY: "SUPABASE_SECRET_KEY",
};

function rewriteEnvFile(
  content: string,
  values: SupabaseStatus,
  statusKeys: (keyof SupabaseStatus)[],
): string {
  const newline = content.includes("\r\n") ? "\r\n" : "\n";
  const lines = content === "" ? [] : content.split(/\r?\n/);
  const updates: Record<string, string> = Object.fromEntries(
    statusKeys.map((statusKey) => [
      envKeyByStatusKey[statusKey],
      values[statusKey],
    ]),
  );
  const keys = Object.keys(updates);
  const seen = new Set<string>();

  const rewritten = lines.map((line) => {
    for (const key of keys) {
      const pattern = new RegExp(
        `^(\\s*(?:export\\s+)?)${escapeRegExp(key)}\\s*=.*$`,
      );
      const match = line.match(pattern);
      if (match) {
        seen.add(key);
        return `${match[1] ?? ""}${key}=${updates[key]}`;
      }
    }
    return line;
  });

  for (const key of keys) {
    if (!seen.has(key)) {
      rewritten.push(`${key}=${updates[key]}`);
    }
  }

  return rewritten.join(newline);
}

function escapeRegExp(value: string): string {
  return value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
}

main().catch((error: unknown) => {
  process.stderr.write(
    `Error: ${error instanceof Error ? error.message : String(error)}\n`,
  );
  process.exitCode = 1;
});
