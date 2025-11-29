import { Mistral } from "@mistralai/mistralai";
import { GEMINI_JOIN_TICKETS_PROMPT } from "../gemini/prompts";

export class MistralClient {
    private mistral: Mistral;

    constructor(apiKey: string) {
        this.mistral = new Mistral({ apiKey });
    }

    //using ocr
    public async ocr(image: Buffer): Promise<void> {
        const result = await this.mistral.ocr.process({
            model: 'mistral-ocr-latest',
            document: {
                imageUrl: 'https://smart-ticket.sfo3.cdn.digitaloceanspaces.com/uploads/e50bc23f-3c62-4a26-95d1-4396807f7839.jpeg',
                type: 'image_url',
            },
            bboxAnnotationFormat: {
                type: 'json_object',

            },


        });

        console.log(result.pages);

    }
    public async ocrWithPrompt(image: Buffer): Promise<void> {
        const base64Image = image.toString('base64');

        const chatResponse = await this.mistral.chat.complete({
            model: 'mistral-ocr-latest',
            messages: [{
                role: 'user',
                content: [
                    {
                        type: 'image_url',
                        imageUrl: `data:image/jpeg;base64,${base64Image}`
                    },
                    {
                        type: 'text',
                        text: GEMINI_JOIN_TICKETS_PROMPT
                    }
                ]
            }],
            responseFormat: {
                type: 'json_object'
            },
            maxTokens: 8192,
            temperature: 0.0
        });

        const responseText = chatResponse.choices?.[0]?.message?.content || '';
        console.log(responseText);
        //return JSON.parse(responseText);
    }
}