/**
 * Type definitions for embedded Receipt data structure
 * This matches the JSON structure stored in Receipt.data field
 */

export interface ReceiptItem {
    original_name: string;
    normalized_name: string;
    category: string;
    quantity: number;
    unit_of_measure: string;
    base_quantity: number;
    base_unit_name: string;
    paid_price: number;
    real_unit_price: number;
}

export interface ReceiptData {
    store: string;
    transaction_id: string;
    date: string;
    time: string;
    final_total: number;
    tax_breakdown: Record<string, number>; // e.g., { "4%": 0.32, "10%": 1.19 }
    items: ReceiptItem[];
}

