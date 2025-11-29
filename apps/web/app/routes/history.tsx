import { useState } from "react";
import { useLoaderData } from "@remix-run/react";
import type { MetaFunction, LoaderFunctionArgs } from "@remix-run/node";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "~/components/ui/card";
import { Badge } from "~/components/ui/badge";
import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "~/components/ui/table";
import { FileText, History as HistoryIcon } from "lucide-react";
import { AppLayout } from "~/components/layout/app-layout";
import {
    Sheet,
    SheetContent,
    SheetHeader,
    SheetTitle,
} from "~/components/ui/sheet";

export const meta: MetaFunction = () => {
    return [
        { title: "Smart Receipt - Historial" },
        { name: "description", content: "View ticket history" },
    ];
};

export async function loader({ request }: LoaderFunctionArgs) {
    const apiUrl = process.env.API_URL || "http://localhost:3001";

    try {
        const response = await fetch(`${apiUrl}/tickets`);
        if (!response.ok) {
            return { tickets: [] };
        }
        const data = await response.json();
        return { tickets: data.data || [] };
    } catch (error) {
        console.error("Error fetching tickets:", error);
        return { tickets: [] };
    }
}

type Ticket = {
    id: string;
    store: string;
    transactionId: string;
    date: string;
    time: string;
    finalTotal: number;
    taxBreakdown: Record<string, number>;
    imageUrl: string | null;
    items: Array<{
        originalName: string;
        normalizedName: string;
        category: string;
        quantity: number;
        unitOfMeasure: string;
        baseQuantity: number;
        baseUnitName: string;
        paidPrice: number;
        realUnitPrice: number;
    }>;
};

export default function History() {
    const { tickets } = useLoaderData<typeof loader>();
    const [selectedTicket, setSelectedTicket] = useState<Ticket | null>(null);

    return (
        <AppLayout>
            <div className="bg-gradient-to-br from-slate-50 to-slate-100 p-6 min-h-screen">
                <div className="mb-6">
                    <h1 className="text-3xl font-bold text-slate-900">Historial de Tickets</h1>
                    <p className="text-slate-600 mt-2">Selecciona un ticket para ver los detalles</p>
                </div>

                <Card>
                    <CardContent className="p-0">
                        <div className="rounded-md border">
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead>Fecha</TableHead>
                                        <TableHead>Comercio</TableHead>
                                        <TableHead>Transaction ID</TableHead>
                                        <TableHead className="text-right">Total</TableHead>
                                        <TableHead className="text-right">Items</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {tickets.length === 0 ? (
                                        <TableRow>
                                            <TableCell colSpan={5} className="text-center py-8 text-slate-400">
                                                No hay tickets disponibles
                                            </TableCell>
                                        </TableRow>
                                    ) : (
                                        tickets.map((ticket: Ticket) => (
                                            <TableRow
                                                key={ticket.id}
                                                className="cursor-pointer hover:bg-slate-50"
                                                onClick={() => setSelectedTicket(ticket)}
                                            >
                                                <TableCell>
                                                    <div>
                                                        <p className="font-medium">{ticket.date || "N/A"}</p>
                                                        {ticket.time && (
                                                            <p className="text-xs text-slate-500">{ticket.time}</p>
                                                        )}
                                                    </div>
                                                </TableCell>
                                                <TableCell className="font-medium">
                                                    {ticket.store || "N/A"}
                                                </TableCell>
                                                <TableCell className="text-slate-600">
                                                    {ticket.transactionId || "N/A"}
                                                </TableCell>
                                                <TableCell className="text-right font-semibold">
                                                    €{ticket.finalTotal?.toFixed(2) || "0.00"}
                                                </TableCell>
                                                <TableCell className="text-right">
                                                    {ticket.items?.length || 0}
                                                </TableCell>
                                            </TableRow>
                                        ))
                                    )}
                                </TableBody>
                            </Table>
                        </div>
                    </CardContent>
                </Card>
            </div>

            {/* Sheet Panel: Ticket details */}
            <Sheet open={!!selectedTicket} onOpenChange={(open) => !open && setSelectedTicket(null)}>
                <SheetContent side="right" className="w-full sm:max-w-2xl overflow-y-auto">
                    {selectedTicket && (
                        <>
                            <SheetHeader>
                                <SheetTitle>Detalles del Ticket</SheetTitle>
                            </SheetHeader>

                            <div className="space-y-6">
                                <Card>
                                    <CardHeader>
                                        <CardTitle>Información del Ticket</CardTitle>
                                    </CardHeader>
                                    <CardContent className="space-y-4">
                                        <div className="grid grid-cols-2 gap-4">
                                            <div>
                                                <p className="text-sm text-slate-500">Comercio</p>
                                                <p className="font-semibold">{selectedTicket.store || "N/A"}</p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-slate-500">Fecha</p>
                                                <p className="font-semibold">{selectedTicket.date || "N/A"}</p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-slate-500">Transaction ID</p>
                                                <p className="font-semibold">{selectedTicket.transactionId || "N/A"}</p>
                                            </div>
                                            <div>
                                                <p className="text-sm text-slate-500">Total</p>
                                                <p className="font-semibold text-lg text-primary">
                                                    €{selectedTicket.finalTotal?.toFixed(2) || "0.00"}
                                                </p>
                                            </div>
                                        </div>

                                        {selectedTicket.taxBreakdown && Object.keys(selectedTicket.taxBreakdown).length > 0 && (
                                            <div>
                                                <p className="text-sm text-slate-500 mb-2">Tax Breakdown</p>
                                                <div className="flex flex-wrap gap-2">
                                                    {Object.entries(selectedTicket.taxBreakdown).map(([key, value]) => (
                                                        <Badge key={key} variant="secondary">
                                                            {key}: €{Number(value).toFixed(2)}
                                                        </Badge>
                                                    ))}
                                                </div>
                                            </div>
                                        )}
                                    </CardContent>
                                </Card>

                                {selectedTicket.imageUrl && (
                                    <Card>
                                        <CardHeader>
                                            <CardTitle>Imagen del Ticket</CardTitle>
                                        </CardHeader>
                                        <CardContent>
                                            <div className="relative w-full">
                                                <img
                                                    src={selectedTicket.imageUrl}
                                                    alt="Scanned receipt"
                                                    className="w-full h-auto rounded-lg border border-slate-200 object-contain max-h-[600px]"
                                                />
                                            </div>
                                        </CardContent>
                                    </Card>
                                )}

                                {selectedTicket.items && selectedTicket.items.length > 0 && (
                                    <Card>
                                        <CardHeader>
                                            <CardTitle>Productos ({selectedTicket.items.length})</CardTitle>
                                        </CardHeader>
                                        <CardContent>
                                            <div className="rounded-md border">
                                                <Table>
                                                    <TableHeader>
                                                        <TableRow>
                                                            <TableHead>Product Name</TableHead>
                                                            <TableHead>Category</TableHead>
                                                            <TableHead className="text-right">Quantity</TableHead>
                                                            <TableHead className="text-right">Unit Price</TableHead>
                                                            <TableHead className="text-right">Total Price</TableHead>
                                                        </TableRow>
                                                    </TableHeader>
                                                    <TableBody>
                                                        {selectedTicket.items.map((item, index) => (
                                                            <TableRow key={index}>
                                                                <TableCell>
                                                                    <div>
                                                                        <p className="font-medium">{item.normalizedName || item.originalName}</p>
                                                                        {item.normalizedName !== item.originalName && (
                                                                            <p className="text-xs text-slate-500 italic">
                                                                                {item.originalName}
                                                                            </p>
                                                                        )}
                                                                    </div>
                                                                </TableCell>
                                                                <TableCell>
                                                                    <Badge variant="outline">{item.category || "N/A"}</Badge>
                                                                </TableCell>
                                                                <TableCell className="text-right">
                                                                    {item.quantity} {item.unitOfMeasure}
                                                                </TableCell>
                                                                <TableCell className="text-right">
                                                                    €{item.realUnitPrice?.toFixed(2) || "0.00"}
                                                                </TableCell>
                                                                <TableCell className="text-right font-semibold">
                                                                    €{item.paidPrice?.toFixed(2) || "0.00"}
                                                                </TableCell>
                                                            </TableRow>
                                                        ))}
                                                    </TableBody>
                                                </Table>
                                            </div>
                                        </CardContent>
                                    </Card>
                                )}
                            </div>
                        </>
                    )}
                </SheetContent>
            </Sheet>
        </AppLayout>
    );
}

