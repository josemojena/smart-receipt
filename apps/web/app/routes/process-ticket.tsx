import { useState, useRef } from "react";
import { useFetcher } from "@remix-run/react";
import type { MetaFunction, ActionFunctionArgs } from "@remix-run/node";
import { Button } from "~/components/ui/button";
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
import { Upload, FileImage, Loader2, CheckCircle2, XCircle, FileText, History } from "lucide-react";
import { cn } from "~/lib/utils";
import { AppLayout } from "~/components/layout/app-layout";

export const meta: MetaFunction = () => {
    return [
        { title: "Smart Receipt - Procesar Ticket" },
        { name: "description", content: "Upload and process receipt tickets" },
    ];
};

export async function action({ request }: ActionFunctionArgs) {
    const formData = await request.formData();
    const file = formData.get("file") as File | null;

    if (!file) {
        return { success: false, error: "No file provided" };
    }

    const apiUrl = process.env.API_URL || "http://localhost:3001";

    try {
        const uploadFormData = new FormData();
        uploadFormData.append("file", file);

        const response = await fetch(`${apiUrl}/process-ticket`, {
            method: "POST",
            body: uploadFormData,
        });

        if (!response.ok) {
            const error = await response.json();
            return { success: false, error: error.message || "Failed to process ticket" };
        }

        const data = await response.json();
        return { success: true, data: data.data, imageUrl: data.imageUrl };
    } catch (error) {
        return {
            success: false,
            error: error instanceof Error ? error.message : "Unknown error",
        };
    }
}

export default function ProcessTicket() {
    const fetcher = useFetcher<{ success: boolean; data?: any; imageUrl?: string; error?: string }>();
    const [isDragging, setIsDragging] = useState(false);
    const fileInputRef = useRef<HTMLInputElement>(null);

    const isProcessing = fetcher.state === "submitting" || fetcher.state === "loading";
    const result = fetcher.data;

    const handleDragOver = (e: React.DragEvent) => {
        e.preventDefault();
        setIsDragging(true);
    };

    const handleDragLeave = () => {
        setIsDragging(false);
    };

    const handleDrop = (e: React.DragEvent) => {
        e.preventDefault();
        setIsDragging(false);

        const file = e.dataTransfer.files[0];
        if (file && file.type.startsWith("image/")) {
            handleFileUpload(file);
        }
    };

    const handleFileSelect = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            handleFileUpload(file);
        }
    };

    const handleFileUpload = (file: File) => {
        const formData = new FormData();
        formData.append("file", file);
        fetcher.submit(formData, { method: "post", encType: "multipart/form-data" });
    };

    const menuItems = [
        {
            title: "Procesar Ticket",
            url: "/process-ticket",
            icon: FileText,
        },
        {
            title: "Historial",
            url: "/history",
            icon: History,
        },
    ];

    return (
        <AppLayout menuItems={menuItems}>
            <div className="bg-gradient-to-br from-slate-50 to-slate-100 p-4 md:p-8 min-h-screen">
                <div className="max-w-[1600px] mx-auto">
                    <div className="text-center space-y-2 mb-6">
                        <h1 className="text-4xl font-bold text-slate-900">Procesar Ticket</h1>
                        <p className="text-slate-600">Upload a receipt image to extract product data</p>
                    </div>

                    <div className="grid gap-6 lg:grid-cols-[80%_20%]">
                        <div className="space-y-6">
                            <div className="grid gap-6 md:grid-cols-2">
                                <Card>
                                    <CardHeader>
                                        <CardTitle>Upload Ticket</CardTitle>
                                        <CardDescription>
                                            Drag and drop an image or click to select a file
                                        </CardDescription>
                                    </CardHeader>
                                    <CardContent>
                                        <div
                                            onDragOver={handleDragOver}
                                            onDragLeave={handleDragLeave}
                                            onDrop={handleDrop}
                                            className={cn(
                                                "border-2 border-dashed rounded-lg p-8 text-center transition-colors",
                                                isDragging
                                                    ? "border-primary bg-primary/5"
                                                    : "border-slate-300 hover:border-slate-400",
                                                isProcessing && "opacity-50 pointer-events-none"
                                            )}
                                        >
                                            <input
                                                ref={fileInputRef}
                                                type="file"
                                                accept="image/*"
                                                onChange={handleFileSelect}
                                                className="hidden"
                                                disabled={isProcessing}
                                            />

                                            {isProcessing ? (
                                                <div className="space-y-4">
                                                    <Loader2 className="h-12 w-12 mx-auto text-primary animate-spin" />
                                                    <p className="text-slate-600">Processing ticket...</p>
                                                </div>
                                            ) : (
                                                <div className="space-y-4">
                                                    <FileImage className="h-12 w-12 mx-auto text-slate-400" />
                                                    <div>
                                                        <p className="text-slate-600 mb-2">
                                                            Drag and drop your receipt image here
                                                        </p>
                                                        <p className="text-sm text-slate-500 mb-4">or</p>
                                                        <Button
                                                            onClick={() => fileInputRef.current?.click()}
                                                            variant="outline"
                                                        >
                                                            <Upload className="h-4 w-4 mr-2" />
                                                            Select File
                                                        </Button>
                                                    </div>
                                                </div>
                                            )}
                                        </div>

                                        {result && !result.success && (
                                            <div className="mt-4 p-4 bg-destructive/10 border border-destructive/20 rounded-lg">
                                                <div className="flex items-center gap-2 text-destructive">
                                                    <XCircle className="h-4 w-4" />
                                                    <span className="font-semibold">Error</span>
                                                </div>
                                                <p className="text-sm text-destructive mt-1">{result.error}</p>
                                            </div>
                                        )}
                                    </CardContent>
                                </Card>

                                <Card>
                                    <CardHeader>
                                        <CardTitle>Ticket Information</CardTitle>
                                        <CardDescription>
                                            {result?.success && result.data
                                                ? "Extracted data from the receipt"
                                                : "Upload a ticket to see extracted data"}
                                        </CardDescription>
                                    </CardHeader>
                                    <CardContent className="space-y-4">
                                        {result?.success && result.data ? (
                                            <>
                                                <div className="grid grid-cols-2 gap-4">
                                                    <div>
                                                        <p className="text-sm text-slate-500">Store</p>
                                                        <p className="font-semibold">{result.data.store || "N/A"}</p>
                                                    </div>
                                                    <div>
                                                        <p className="text-sm text-slate-500">Date</p>
                                                        <p className="font-semibold">{result.data.date || "N/A"}</p>
                                                    </div>
                                                    <div>
                                                        <p className="text-sm text-slate-500">Transaction ID</p>
                                                        <p className="font-semibold">{result.data.transaction_id || "N/A"}</p>
                                                    </div>
                                                    <div>
                                                        <p className="text-sm text-slate-500">Total</p>
                                                        <p className="font-semibold text-lg text-primary">
                                                            €{result.data.final_total?.toFixed(2) || "0.00"}
                                                        </p>
                                                    </div>
                                                </div>

                                                {result.data.tax_breakdown && Object.keys(result.data.tax_breakdown).length > 0 && (
                                                    <div>
                                                        <p className="text-sm text-slate-500 mb-2">Tax Breakdown</p>
                                                        <div className="flex flex-wrap gap-2">
                                                            {Object.entries(result.data.tax_breakdown).map(([key, value]) => (
                                                                <Badge key={key} variant="secondary">
                                                                    {key}: €{Number(value).toFixed(2)}
                                                                </Badge>
                                                            ))}
                                                        </div>
                                                    </div>
                                                )}
                                            </>
                                        ) : (
                                            <div className="text-center py-8 text-slate-400">
                                                <FileImage className="h-12 w-12 mx-auto mb-2 opacity-50" />
                                                <p className="text-sm">No ticket data available</p>
                                            </div>
                                        )}
                                    </CardContent>
                                </Card>
                            </div>

                            {result?.success && result.data?.items && result.data.items.length > 0 && (
                                <Card>
                                    <CardHeader>
                                        <CardTitle>Products ({result.data.items.length})</CardTitle>
                                        <CardDescription>List of items extracted from the receipt</CardDescription>
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
                                                    {result.data.items.map((item: any, index: number) => (
                                                        <TableRow key={index}>
                                                            <TableCell>
                                                                <div>
                                                                    <p className="font-medium">{item.normalized_name || item.original_name}</p>
                                                                    {item.normalized_name !== item.original_name && (
                                                                        <p className="text-xs text-slate-500 italic">
                                                                            {item.original_name}
                                                                        </p>
                                                                    )}
                                                                </div>
                                                            </TableCell>
                                                            <TableCell>
                                                                <Badge variant="outline">{item.category || "N/A"}</Badge>
                                                            </TableCell>
                                                            <TableCell className="text-right">
                                                                {item.quantity} {item.unit_of_measure}
                                                            </TableCell>
                                                            <TableCell className="text-right">
                                                                €{item.real_unit_price?.toFixed(2) || "0.00"}
                                                            </TableCell>
                                                            <TableCell className="text-right font-semibold">
                                                                €{item.paid_price?.toFixed(2) || "0.00"}
                                                            </TableCell>
                                                        </TableRow>
                                                    ))}
                                                </TableBody>
                                            </Table>
                                        </div>
                                    </CardContent>
                                </Card>
                            )}

                            {result?.success && (
                                <div className="flex items-center justify-center gap-2 p-4 bg-green-50 border border-green-200 rounded-lg">
                                    <CheckCircle2 className="h-5 w-5 text-green-600" />
                                    <span className="text-green-800 font-medium">Ticket processed successfully!</span>
                                </div>
                            )}
                        </div>

                        {result?.success && result.imageUrl && (
                            <div className="lg:sticky lg:top-4 lg:h-fit">
                                <Card>
                                    <CardHeader>
                                        <CardTitle>Scanned Ticket</CardTitle>
                                        <CardDescription>Original receipt image</CardDescription>
                                    </CardHeader>
                                    <CardContent>
                                        <div className="relative w-full">
                                            <img
                                                src={result.imageUrl}
                                                alt="Scanned receipt"
                                                className="w-full h-auto rounded-lg border border-slate-200 object-contain max-h-[600px]"
                                            />
                                        </div>
                                    </CardContent>
                                </Card>
                            </div>
                        )}
                    </div>
                </div>
            </div>
        </AppLayout>
    );
}

