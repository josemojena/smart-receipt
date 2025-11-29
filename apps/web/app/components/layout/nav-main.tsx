import { useLocation } from "@remix-run/react"
import { ChevronRight, type LucideIcon } from "lucide-react"

import { Collapsible, CollapsibleContent, CollapsibleTrigger } from "~/components/ui/collapsible"
import { Link } from "~/components/ui/link"
import {
    SidebarGroup,
    SidebarGroupContent,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    SidebarMenuSub,
    SidebarMenuSubButton,
    SidebarMenuSubItem,
} from "~/components/ui/sidebar"
import { cn } from "~/lib/utils"

export function NavMain({
    items,
}: {
    items: {
        title: string
        url: string
        icon?: LucideIcon
        subItems?: {
            title: string
            url: string
            icon?: LucideIcon
        }[]
    }[]
}) {
    const location = useLocation()
    const getActiveMenuItem = (menuItems: { url: string; subItems?: { url: string }[] }[], pathname: string) => {
        const allItems = menuItems.flatMap((item) => [item, ...(item.subItems ? item.subItems : [])])

        return allItems.reduce(
            (active, item) => {
                if (
                    pathname === item.url ||
                    (pathname.startsWith(item.url + "/") && item.url.length > (active?.url.length ?? 0))
                ) {
                    return item
                }
                return active
            },
            null as { url: string } | null
        )
    }
    const activeItem = getActiveMenuItem(items, location.pathname)
    return (
        <SidebarGroup>
            <SidebarGroupContent className="flex flex-col gap-2">
                <SidebarMenu>
                    {items.map((item) => {
                        // If item has subItems, render as collapsible
                        if (item.subItems && item.subItems.length > 0) {
                            return (
                                <Collapsible key={item.title} asChild defaultOpen={true} className="group/collapsible">
                                    <SidebarMenuItem key={item.title}>
                                        <CollapsibleTrigger asChild>
                                            <SidebarMenuButton tooltip={item.title}>
                                                {item.icon && <item.icon />}
                                                <span>{item.title}</span>
                                                <ChevronRight className="ml-auto transition-transform duration-200 group-data-[state=open]/collapsible:rotate-90" />
                                            </SidebarMenuButton>
                                        </CollapsibleTrigger>
                                        <CollapsibleContent>
                                            <SidebarMenuSub>
                                                {item.subItems?.map((subItem) => (
                                                    <SidebarMenuSubItem key={subItem.title}>
                                                        <SidebarMenuSubButton asChild>
                                                            <Link
                                                                to={subItem.url}
                                                                className={cn(
                                                                    "h-9 flex items-center gap-2",
                                                                    activeItem?.url === subItem.url ? "bg-accent" : "hover:bg-accent"
                                                                )}
                                                                isActive={activeItem?.url === subItem.url}
                                                                icon={subItem.icon && <subItem.icon size={16} />}
                                                            >
                                                                <span className="font-normal">{subItem.title}</span>
                                                            </Link>
                                                        </SidebarMenuSubButton>
                                                    </SidebarMenuSubItem>
                                                ))}
                                            </SidebarMenuSub>
                                        </CollapsibleContent>
                                    </SidebarMenuItem>
                                </Collapsible>
                            )
                        }

                        // If item has no subItems, render as simple link
                        return (
                            <SidebarMenuItem key={item.title}>
                                <SidebarMenuButton asChild className={cn(activeItem?.url === item.url ? "bg-accent" : "")}>
                                    <Link
                                        to={item.url}
                                        className={cn("h-9 flex items-center gap-2")}
                                        icon={item.icon && <item.icon size={16} />}
                                    >
                                        <span className="font-normal">{item.title}</span>
                                    </Link>
                                </SidebarMenuButton>
                            </SidebarMenuItem>
                        )
                    })}
                </SidebarMenu>
            </SidebarGroupContent>
        </SidebarGroup>
    )
}

