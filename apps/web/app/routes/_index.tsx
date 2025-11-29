import { redirect } from "@remix-run/node";
import type { MetaFunction, LoaderFunctionArgs } from "@remix-run/node";

export const meta: MetaFunction = () => {
    return [
        { title: "Smart Receipt" },
        { name: "description", content: "Smart Receipt - Process and manage receipts" },
    ];
};

export async function loader({ request }: LoaderFunctionArgs) {
    return redirect("/process-ticket");
}

export default function Index() {
    return null;
}
