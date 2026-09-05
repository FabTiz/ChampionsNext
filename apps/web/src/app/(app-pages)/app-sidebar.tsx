
import {
  Sidebar,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem
} from '@/components/ui/sidebar';
import {
  getCachedIsUserLoggedIn,
  getCachedLoggedInVerifiedSupabaseUser,
} from '@/rsc-data/supabase';
import {
  Trophy
} from 'lucide-react';
import Link from 'next/link';
import { Suspense } from 'react';
import { AppSidebarContent } from './app-sidebar-client';



async function SidebarHeaderContent() {
  'use cache'
  return <SidebarHeader>
    <SidebarMenu>
      <SidebarMenuItem>
        <SidebarMenuButton size="lg" asChild>
          <Link href="/">
            <div className="flex aspect-square size-8 items-center justify-center rounded-lg bg-primary text-primary-foreground">
              <Trophy className="size-4" />
            </div>
            <div className="grid flex-1 text-left text-sm leading-tight">
              <span className="truncate font-semibold">My Fantacalcio</span>
              <span className="truncate text-xs text-muted-foreground">
                Le tue leghe
              </span>
            </div>
          </Link>
        </SidebarMenuButton>
      </SidebarMenuItem>
    </SidebarMenu>
  </SidebarHeader>

}



async function SidebarContentWrapper() {
  if (process.env.NODE_ENV === 'development') {
    return <AppSidebarContent user={{ email: 'demo@fantacalcio.local', user_metadata: { name: 'Demo User' } }} />;
  }

  const isLoggedIn = await getCachedIsUserLoggedIn();
  if (!isLoggedIn) {
    return null;
  }
  const { user } = await getCachedLoggedInVerifiedSupabaseUser().catch(() => ({ user: null }));
  if (!user) {
    return null;
  }
  return <AppSidebarContent user={user} />
}


export async function AppSidebar() {
  return (
    <Sidebar variant="inset">
      <SidebarHeaderContent />
      <Suspense fallback={null}>
        <SidebarContentWrapper />
      </Suspense>
    </Sidebar>
  );
}
