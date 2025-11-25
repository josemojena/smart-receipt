import type { MetaFunction } from "@remix-run/node";

export const meta: MetaFunction = () => {
    return [
        { title: "Smart Receipt" },
        { name: "description", content: "Welcome to Smart Receipt!" },
    ];
};

export default function Index() {
    return (
        <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-100 flex items-center justify-center p-4">
            <div className="max-w-2xl w-full bg-white rounded-lg shadow-xl p-8">
                <h1 className="text-4xl font-bold text-gray-900 mb-4">
                    Welcome to Smart Receipt
                </h1>
                <p className="text-lg text-gray-600 mb-6">
                    Your intelligent receipt management system built with Remix.js
                </p>
                <div className="space-y-4">
                    <div className="p-4 bg-blue-50 rounded-lg">
                        <h2 className="font-semibold text-blue-900 mb-2">Features</h2>
                        <ul className="list-disc list-inside text-blue-800 space-y-1">
                            <li>Receipt scanning and OCR</li>
                            <li>Automatic data extraction</li>
                            <li>Expense tracking</li>
                            <li>Category management</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    );
}

