import { prisma } from './index';
import crypto from 'crypto';

// Example seed data based on lidl.json
const exampleReceipt = {
    store: 'LIDL',
    transaction_id: '005521596',
    date: '2025-11-24',
    time: '12:25',
    final_total: 21.29,
    tax_breakdown: {
        '4%': 0.32,
        '10%': 1.19,
    },
    items: [
        {
            original_name: 'ASSORTIMENT BROU',
            normalized_name: 'Surtido Caldo',
            category: 'Despensa',
            quantity: 1.0,
            unit_of_measure: 'ud',
            base_quantity: 1.0,
            base_unit_name: 'ud',
            paid_price: 2.15,
            real_unit_price: 2.15,
        },
    ],
};

async function main() {
    console.log('Seeding database...');

    // Generate MD5 hash of the JSON
    const jsonString = JSON.stringify(exampleReceipt);
    const documentHash = crypto.createHash('md5').update(jsonString).digest('hex');

    // Check if receipt already exists
    const existing = await prisma.receipt.findUnique({
        where: { documentHash },
    });

    if (existing) {
        console.log('✅ Receipt already exists, skipping seed');
        return;
    }

    // Create receipt
    const receipt = await prisma.receipt.create({
        data: {
            userId: 'seed-user-123',
            documentHash,
            geminiData: exampleReceipt,
        },
    });

    console.log('Created receipt:', receipt.id);
}

main()
    .catch((e) => {
        console.error('Seed failed:', e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });

