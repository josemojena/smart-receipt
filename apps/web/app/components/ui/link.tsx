import { Link as RemixLink, useNavigation } from "@remix-run/react"
import { Loader2 } from "lucide-react"
import { forwardRef } from "react"

import { cn } from "~/lib/utils"

interface LinkProps extends React.ComponentProps<typeof RemixLink> {
    showLoadingState?: boolean
    icon?: React.ReactNode
    isActive?: boolean
}

export const Link = forwardRef<HTMLAnchorElement, LinkProps>(
    ({ children, className, showLoadingState = true, to, icon, isActive, ...props }, ref) => {
        const navigation = useNavigation()
        const isLoading =
            navigation.state === "loading" &&
            showLoadingState &&
            navigation.location?.pathname === to &&
            navigation.formMethod === undefined

        return (
            <RemixLink
                ref={ref}
                to={to}
                className={cn(
                    "relative inline-flex items-center gap-2",
                    isLoading && "opacity-70",
                    isActive && "text-foreground font-medium",
                    !isActive && "text-muted-foreground",
                    className
                )}
                {...props}
            >
                {icon && <span className="shrink-0">{icon}</span>}
                <span className="truncate">{children}</span>
                {isLoading && <Loader2 className="h-4 w-4 animate-spin ml-auto" />}
            </RemixLink>
        )
    }
)

Link.displayName = "Link"

