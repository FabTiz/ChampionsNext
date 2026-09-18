#Requires -Version 5.1
<#
.SYNOPSIS
    Abilita i prerequisiti Windows per WSL2, Podman e Supabase locale.

.DESCRIPTION
    Risolve l'errore:

        Wsl/Service/RegisterDistro/CreateVm/HCS/HCS_E_HYPERV_NOT_INSTALLED
        Error: the WSL import of guest OS failed

    che impedisce a `podman machine init` / `podman machine start` di creare la
    macchina virtuale e, di conseguenza, a `supabase start` di funzionare in locale.

    Lo script:
      1. verifica di essere eseguito come Amministratore;
      2. abilita i componenti facoltativi "VirtualMachinePlatform",
         "HypervisorPlatform" e "Microsoft-Windows-Subsystem-Linux";
      3. ripristina il bootloader impostando `hypervisorlaunchtype auto`
         (causa tipica del problema quando in passato l'hypervisor è stato disattivato);
      4. aggiorna/installa il kernel WSL e imposta WSL2 come versione predefinita;
      5. stampa lo stato finale e i comandi da eseguire dopo il riavvio.

.PARAMETER SkipRebootPrompt
    Non mostra il messaggio finale con i comandi post-riavvio.

.EXAMPLE
    # Da un terminale PowerShell APERTO COME AMMINISTRATORE:
    & ".\scripts\enable-wsl2-hypervisor.ps1"

.NOTES
    Al termine del corretto funzionamento e' OBBLIGATORIO riavviare il computer.
#>

[CmdletBinding()]
param(
    [switch]$SkipRebootPrompt
)

$ErrorActionPreference = 'Stop'

function Write-Step {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host ''
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Write-Ok {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "    [OK]   $Message" -ForegroundColor Green
}

function Write-Warn {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "    [WARN] $Message" -ForegroundColor Yellow
}

function Write-Err {
    param([Parameter(Mandatory)][string]$Message)
    Write-Host "    [ERR]  $Message" -ForegroundColor Red
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-OptionalFeatureState {
    param([Parameter(Mandatory)][string]$Name)

    $feature = Get-CimInstance -ClassName Win32_OptionalFeature -Filter "Name='$Name'" -ErrorAction SilentlyContinue
    if ($null -eq $feature) { return 'Sconosciuto' }

    switch ($feature.InstallState) {
        1 { return 'Abilitato' }
        2 { return 'Disabilitato' }
        3 { return 'Non presente' }
        4 { return 'Sconosciuto' }
        default { return "Codice $($feature.InstallState)" }
    }
}

# --------------------------------------------------------------------------
# 0. Preflight
# --------------------------------------------------------------------------
Write-Host ''
Write-Host '------------------------------------------------------------' -ForegroundColor White
Write-Host ' Prerequisiti WSL2 / Podman / Supabase locale' -ForegroundColor White
Write-Host '------------------------------------------------------------' -ForegroundColor White

if (-not (Test-IsAdministrator)) {
    Write-Host ''
    Write-Err 'Privilegi insufficienti.'
    Write-Host ''
    Write-Host '  Apri PowerShell come Amministratore (tasto destro su PowerShell ->' -ForegroundColor Yellow
    Write-Host '  "Esegui come amministratore") e rilancia:' -ForegroundColor Yellow
    Write-Host ''
    Write-Host "    & `"$PSCommandPath`"" -ForegroundColor Yellow
    Write-Host ''
    exit 1
}

Write-Ok 'Esecuzione con privilegi di Amministratore.'

$cpu = Get-CimInstance -ClassName Win32_Processor | Select-Object -First 1
Write-Host ''
Write-Host 'Stato hardware / firmware:' -ForegroundColor White
Write-Host "    Virtualizzazione firmware (BIOS/UEFI) : $($cpu.VirtualizationFirmwareEnabled)"
Write-Host "    Estensioni VMX/SVM (CPU)              : $($cpu.VMMonitorModeExtensions)"
Write-Host "    SLAT (Second Level Address Translation): $($cpu.SecondLevelAddressTranslationExtensions)"

if (-not $cpu.VirtualizationFirmwareEnabled) {
    Write-Host ''
    Write-Err 'La virtualizzazione e'' disattivata nel BIOS/UEFI.'
    Write-Host '     Riavvia il PC, entra nel BIOS/UEFI e abilita:' -ForegroundColor Yellow
    Write-Host '       - Intel: "Intel Virtualization Technology" / "VT-x"' -ForegroundColor Yellow
    Write-Host '       - AMD  : "SVM Mode" / "AMD-V"' -ForegroundColor Yellow
    Write-Host '     Poi rilancia questo script.' -ForegroundColor Yellow
    exit 1
}

Write-Ok 'Virtualizzazione hardware disponibile.'

# --------------------------------------------------------------------------
# 1. Execution policy di PowerShell
#
#    Senza questo passaggio `pnpm` (che gira tramite pnpm.ps1) fallisce con:
#      "L'esecuzione di script e' disabilitata nel sistema in uso."
#    PowerShell 7 e Windows PowerShell 5.1 leggono la policy utente da
#    posizioni diverse, quindi la scriviamo direttamente nel registro per
#    entrambe. Inoltre in questo ambiente il cmdlet Set-ExecutionPolicy puo'
#    essere oscurato da file vuoti in System32, quindi il registro e' piu'
#    affidabile.
# --------------------------------------------------------------------------
Write-Step 'Configurazione della execution policy di PowerShell'

$policyValue = 'RemoteSigned'

$policyKeys = @(
    @{ Host = 'Windows PowerShell 5.1'; Path = 'HKCU:\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell' },
    @{ Host = 'PowerShell 7+';          Path = 'HKCU:\SOFTWARE\Microsoft\PowerShellCore\ShellIds\Microsoft.PowerShell' }
)

foreach ($entry in $policyKeys) {
    try {
        if (-not (Test-Path $entry.Path)) {
            New-Item -Path $entry.Path -Force | Out-Null
        }

        Set-ItemProperty -Path $entry.Path -Name 'ExecutionPolicy' -Value $policyValue -Type String -Force
        $written = (Get-ItemProperty -Path $entry.Path -Name 'ExecutionPolicy' -ErrorAction SilentlyContinue).ExecutionPolicy

        if ($written -eq $policyValue) {
            Write-Ok "$($entry.Host) : execution policy = $policyValue"
        }
        else {
            Write-Warn "$($entry.Host) : valore scritto non confermato (letto: '$written')."
        }
    }
    catch {
        Write-Warn "$($entry.Host) : impossibile impostare la policy -> $($_.Exception.Message)"
    }
}

# File vuoti in System32 con nomi di cmdlet PowerShell: oscurano i cmdlet reali.
$shadowFiles = @('Get-ExecutionPolicy', 'Get-ChildItem') |
    ForEach-Object { Join-Path $env:WINDIR "System32\$_" } |
    Where-Object { Test-Path $_ }

if ($shadowFiles.Count -gt 0) {
    Write-Warn 'Rilevati file che oscurano i cmdlet di PowerShell in System32:'
    foreach ($shadowFile in $shadowFiles) {
        $size = (Get-Item $shadowFile).Length
        Write-Host "             $shadowFile ($size byte)"
    }

    $allEmpty = @($shadowFiles | Where-Object { (Get-Item $_).Length -ne 0 }).Count -eq 0

    if ($allEmpty) {
        Write-Host '             ... sono file vuoti (0 byte): provo a rimuoverli.'
        foreach ($shadowFile in $shadowFiles) {
            try {
                Remove-Item -Path $shadowFile -Force -ErrorAction Stop
                Write-Ok "Rimosso $shadowFile"
            }
            catch {
                Write-Warn "Non rimosso $shadowFile -> $($_.Exception.Message)"
            }
        }
    }
    else {
        Write-Warn 'Non tutti sono vuoti: NON li rimuovo. Valutali manualmente.'
    }
}
else {
    Write-Ok 'Nessun file che oscura i cmdlet rilevato in System32.'
}

# --------------------------------------------------------------------------
# 2. Componenti facoltativi di Windows
# --------------------------------------------------------------------------
Write-Step 'Abilitazione dei componenti facoltativi di Windows'

$features = @(
    'VirtualMachinePlatform',
    'HypervisorPlatform',
    'Microsoft-Windows-Subsystem-Linux'
)

foreach ($featureName in $features) {
    $before = Get-OptionalFeatureState -Name $featureName

    if ($before -eq 'Abilitato') {
        Write-Ok "$featureName : gia' abilitato."
        continue
    }

    Write-Host "    ... abilito $featureName (era: $before)"
    try {
        $result = Enable-WindowsOptionalFeature -Online -FeatureName $featureName -All -NoRestart -ErrorAction Stop
        if ($result.RestartNeeded) {
            Write-Warn "$featureName : abilitato, riavvio necessario."
        }
        else {
            Write-Ok "$featureName : abilitato."
        }
    }
    catch {
        Write-Err "$featureName : abilitazione fallita -> $($_.Exception.Message)"
    }
}

# --------------------------------------------------------------------------
# 3. Bootloader: l'hypervisor deve essere avviato all'avvio del sistema
# --------------------------------------------------------------------------
Write-Step 'Configurazione del bootloader (hypervisorlaunchtype)'

$bcdOutput = & bcdedit /enum '{current}' 2>&1 | Out-String
$currentLaunchType = 'non specificato'
$match = [regex]::Match($bcdOutput, 'hypervisorlaunchtype\s+(\S+)')
if ($match.Success) { $currentLaunchType = $match.Groups[1].Value }

Write-Host "    Valore attuale: $currentLaunchType"

if ($currentLaunchType -eq 'auto') {
    Write-Ok 'hypervisorlaunchtype e'' gia'' impostato su auto.'
}
else {
    Write-Host '    ... imposto hypervisorlaunchtype auto'
    $bcdSet = & bcdedit /set hypervisorlaunchtype auto 2>&1 | Out-String
    Write-Host "    $($bcdSet.Trim())"

    $verifyOutput = & bcdedit /enum '{current}' 2>&1 | Out-String
    $verifyMatch = [regex]::Match($verifyOutput, 'hypervisorlaunchtype\s+(\S+)')
    if ($verifyMatch.Success -and $verifyMatch.Groups[1].Value -eq 'auto') {
        Write-Ok 'hypervisorlaunchtype impostato su auto.'
    }
    else {
        Write-Err 'Impossibile confermare hypervisorlaunchtype: verifica manualmente con "bcdedit /enum {current}".'
    }
}

# --------------------------------------------------------------------------
# 4. Aggiornamento WSL
# --------------------------------------------------------------------------
Write-Step 'Aggiornamento di WSL'

try {
    $wslInstall = & wsl.exe --install --no-distribution 2>&1 | Out-String
    if ($wslInstall.Trim()) { Write-Host "    $($wslInstall.Trim())" }
    Write-Ok 'Comando "wsl --install --no-distribution" completato.'
}
catch {
    Write-Warn "wsl --install --no-distribution ha restituito un errore (spesso normale se serve il riavvio): $($_.Exception.Message)"
}

try {
    $wslUpdate = & wsl.exe --update 2>&1 | Out-String
    if ($wslUpdate.Trim()) { Write-Host "    $($wslUpdate.Trim())" }
    Write-Ok 'Kernel WSL aggiornato.'
}
catch {
    Write-Warn "wsl --update non completato: $($_.Exception.Message)"
}

try {
    & wsl.exe --set-default-version 2 2>&1 | Out-String | ForEach-Object { if ($_.Trim()) { Write-Host "    $($_.Trim())" } }
    Write-Ok 'WSL2 impostato come versione predefinita.'
}
catch {
    Write-Warn "wsl --set-default-version 2 non completato: $($_.Exception.Message)"
}

# --------------------------------------------------------------------------
# 5. Riepilogo
# --------------------------------------------------------------------------
Write-Step 'Stato finale'

foreach ($featureName in $features) {
    Write-Host ("    {0,-38}: {1}" -f $featureName, (Get-OptionalFeatureState -Name $featureName))
}

$computerSystem = Get-CimInstance -ClassName Win32_ComputerSystem
Write-Host ("    {0,-38}: {1}" -f 'Hypervisor attivo in questa sessione', $computerSystem.HypervisorPresent)

if (-not $computerSystem.HypervisorPresent) {
    Write-Host ''
    Write-Warn 'L''hypervisor NON e'' ancora attivo: e'' normale, serve un RIAVVIO.'
}

if (-not $SkipRebootPrompt) {
    Write-Host ''
    Write-Host '------------------------------------------------------------' -ForegroundColor White
    Write-Host ' RIAVVIA ORA IL COMPUTER' -ForegroundColor Yellow
    Write-Host '------------------------------------------------------------' -ForegroundColor White
    Write-Host ''
    Write-Host ' Dopo il riavvio, da questo repository esegui:' -ForegroundColor White
    Write-Host ''
    Write-Host '   podman machine init --cpus 4 --memory 4096 --disk-size 50' -ForegroundColor Green
    Write-Host '   podman machine start' -ForegroundColor Green
    Write-Host '   pnpm database#start' -ForegroundColor Green
    Write-Host ''
    Write-Host ' Per verificare che l''hypervisor sia davvero attivo:' -ForegroundColor White
    Write-Host ''
    Write-Host '   (Get-CimInstance Win32_ComputerSystem).HypervisorPresent' -ForegroundColor Green
    Write-Host '   # deve restituire: True' -ForegroundColor DarkGray
    Write-Host ''
}

exit 0
