import { SidebarInset, SidebarProvider } from "~/components/ui/sidebar"
import { AppSidebar } from "~/components/layout/app-sidebar"
import { SiteHeader } from "~/components/layout/site-header"
import { Toaster } from "~/components/ui/toaster"
import { type LucideIcon } from "lucide-react"

interface MenuItem {
    title: string
    url: string
    icon?: LucideIcon
    subItems?: {
        title: string
        url: string
        icon?: LucideIcon
    }[]
}

interface AppLayoutProps {
    children: React.ReactNode
    menuItems?: MenuItem[]
    userData?: { username: string; email: string }
}

export function AppLayout({ children, menuItems, userData }: AppLayoutProps) {
    return (
        <>
            <SidebarProvider>
                <div className="flex h-screen w-full overflow-hidden">
                    <AppSidebar variant="inset" items={menuItems ?? []} />
                    <SidebarInset>
                        <SiteHeader userData={userData} />
                        <div className="@container/main flex flex-1 flex-col gap-2 overflow-auto">
                            <div className="flex flex-col gap-4 py-4 md:gap-6 px-4 lg:px-6">
                                {children}
                            </div>
                        </div>
                    </SidebarInset>
                </div>
            </SidebarProvider>
            <Toaster />
        </>
    )
}

