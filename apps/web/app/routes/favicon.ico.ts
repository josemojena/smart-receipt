import type { LoaderFunctionArgs } from "@remix-run/node";

// Resource route for favicon to prevent 404 errors
export const loader = async ({ request }: LoaderFunctionArgs) => {
    // Return a simple 204 No Content response
    // or redirect to a default favicon
    return new Response(null, {
        status: 204,
        headers: {
            "Content-Type": "image/x-icon",
        },
    });
};

