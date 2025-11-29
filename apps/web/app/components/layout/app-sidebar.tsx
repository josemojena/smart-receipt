import { ArrowUpCircleIcon, type LucideIcon } from "lucide-react"
import * as React from "react"

import { NavMain } from "~/components/layout/nav-main"
import {
    Sidebar,
    SidebarContent,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
} from "~/components/ui/sidebar"

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

interface AppSidebarProps extends React.ComponentProps<typeof Sidebar> {
    items: MenuItem[]
}

export function AppSidebar({ items, ...props }: AppSidebarProps) {
    return (
        <Sidebar collapsible="offcanvas" {...props}>
            <SidebarHeader>
                <SidebarMenu>
                    <SidebarMenuItem>
                        <SidebarMenuButton asChild className="data-[slot=sidebar-menu-button]:!p-1.5">
                            <a href="/">
                                <ArrowUpCircleIcon className="h-5 w-5" />
                                <span className="text-base font-semibold">Smart Receipt</span>
                            </a>
                        </SidebarMenuButton>
                    </SidebarMenuItem>
                </SidebarMenu>
            </SidebarHeader>
            <SidebarContent>
                <NavMain items={items} />
            </SidebarContent>
        </Sidebar>
    )
}
