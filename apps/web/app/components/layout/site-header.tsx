import { ChevronDown } from "lucide-react"

import { Avatar, AvatarFallback, AvatarImage } from "~/components/ui/avatar"
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuGroup,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from "~/components/ui/dropdown-menu"
import { Separator } from "~/components/ui/separator"
import { SidebarTrigger } from "~/components/ui/sidebar"

interface SiteHeaderProps {
    userData?: { username: string; email: string }
    children?: React.ReactNode
}

export function SiteHeader({ userData, children }: SiteHeaderProps) {
    return (
        <header className="group-has-data-[collapsible=icon]/sidebar-wrapper:h-12 flex h-12 shrink-0 items-center gap-2 border-b transition-[width,height] ease-linear">
            <div className="flex w-full items-center justify-between gap-1 px-4 lg:gap-2 lg:px-6">
                <div className="flex items-center gap-4">
                    <SidebarTrigger className="-ml-1" />
                    <Separator orientation="vertical" className="mx-2 data-[orientation=vertical]:h-4" />
                    {children}
                </div>

                <div className="flex items-center gap-4">
                    <Separator orientation="vertical" className="mx-1 data-[orientation=vertical]:h-4" />
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <button className="hover:bg-accent hover:text-accent-foreground flex items-center gap-2 rounded-md px-2 py-1">
                                <Avatar className="h-8 w-8">
                                    <AvatarImage src="" />
                                    <AvatarFallback>
                                        {userData?.username
                                            ? `${userData.username[0]?.toUpperCase() || ""}${userData.username[1]?.toUpperCase() || ""}`
                                            : "U"}
                                    </AvatarFallback>
                                </Avatar>
                                <span className="text-sm font-medium">
                                    {userData?.username
                                        ? `${userData.username.slice(0, 1)?.toUpperCase() || ""}${userData.username.slice(1) || ""}`
                                        : "User"}
                                </span>
                                <ChevronDown className="h-4 w-4" />
                            </button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent className="w-56" align="end" forceMount>
                            <DropdownMenuLabel className="font-normal flex flex-col space-y-1">
                                <p className="text-sm font-medium leading-none">{userData?.username || "User"}</p>
                                <p className="text-muted-foreground text-xs leading-none">{userData?.email || ""}</p>
                            </DropdownMenuLabel>
                            <DropdownMenuSeparator />
                            <DropdownMenuGroup>
                                <DropdownMenuItem asChild>
                                    <a href="/profile" className="cursor-pointer">
                                        Profile
                                    </a>
                                </DropdownMenuItem>
                                <DropdownMenuItem asChild>
                                    <a href="/settings" className="cursor-pointer">
                                        Settings
                                    </a>
                                </DropdownMenuItem>
                            </DropdownMenuGroup>
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
            </div>
        </header>
    )
}

