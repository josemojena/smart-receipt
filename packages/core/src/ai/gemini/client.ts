import { GoogleGenerativeAI } from '@google/generative-ai';
import type {
    GeminiGenerateContentOptions,
    GeminiGenerateContentResult,
    GeminiImagePart,
} from './types.js';

/**
 * Converts a buffer to a Generative AI part
 */
export function bufferToGenerativePart(
    buffer: Buffer,
    mimeType: string
): GeminiImagePart {
    return {
        inlineData: {
            data: buffer.toString('base64'),
            mimeType,
        },
    };
}

/**
 * Extracts JSON from Gemini response text, handling markdown code blocks
 */
export function extractJsonFromResponse(text: string): string {
    let jsonText = text.trim();
    if (jsonText.startsWith('```json')) {
        jsonText = jsonText.replace(/^```json\s*/, '').replace(/\s*```$/, '');
    } else if (jsonText.startsWith('```')) {
        jsonText = jsonText.replace(/^```\s*/, '').replace(/\s*```$/, '');
    }
    return jsonText;
}

/**
 * Generic Gemini client for processing images with text prompts
 */
export class GeminiClient {
    private genAI: GoogleGenerativeAI;
    private defaultModel: string;

    constructor(apiKey: string, defaultModel: string = 'gemini-2.5-flash') {
        if (!apiKey) {
            throw new Error('GEMINI_API_KEY is required');
        }
        this.genAI = new GoogleGenerativeAI(apiKey);
        this.defaultModel = defaultModel;
    }

    /**
     * Generates content from text prompts and image buffers
     * @param content - Array of text prompts and/or image parts
     * @param options - Optional configuration for the model
     * @returns The raw text response from Gemini
     */
    async generateContent(
        content: (string | GeminiImagePart)[],
        options?: GeminiGenerateContentOptions
    ): Promise<string> {
        const modelConfig: { model: string } = {
            model: options?.model || this.defaultModel,
        };

        const model = this.genAI.getGenerativeModel(modelConfig);

        // Convert content to the format expected by Gemini
        // The API accepts an array of strings and objects with inlineData
        const parts = content.map((item) => {
            if (typeof item === 'string') {
                return item;
            }
            return item;
        });

        const result = await model.generateContent(parts);
        const response = await result.response;
        return response.text();
    }

    /**
     * Generates content and parses the response as JSON
     * @param content - Array of text prompts and/or image parts
     * @param options - Optional configuration for the model
     * @returns Parsed JSON object
     */
    async generateContentAsJson<T = unknown>(
        content: (string | GeminiImagePart)[],
        options?: GeminiGenerateContentOptions
    ): Promise<GeminiGenerateContentResult<T>> {
        try {
            const text = await this.generateContent(content, options);
            const jsonText = extractJsonFromResponse(text);
            const data = JSON.parse(jsonText) as T;

            return {
                success: true,
                data,
                rawResponse: text,
            };
        } catch (error) {
            return {
                success: false,
                data: null,
                error: error instanceof Error ? error.message : 'Unknown error',
            };
        }
    }

    /**
     * Processes a single image buffer with a text prompt
     * @param imageBuffer - The image buffer to process
     * @param prompt - Text prompt to use
     * @param mimeType - MIME type of the image (defaults to 'image/jpeg')
     * @param options - Optional configuration for the model
     * @returns Parsed JSON result
     */
    async processImage<T = unknown>(
        imageBuffer: Buffer,
        prompt: string,
        mimeType: string = 'image/jpeg',
        options?: GeminiGenerateContentOptions
    ): Promise<GeminiGenerateContentResult<T>> {
        const imagePart = bufferToGenerativePart(imageBuffer, mimeType);
        return this.generateContentAsJson<T>([prompt, imagePart], options);
    }

    /**
     * Processes multiple image buffers with text prompts
     * @param imageBuffers - Array of image buffers
     * @param prompts - Array of text prompts (will be combined)
     * @param mimeTypes - Array of MIME types for each image (defaults to 'image/jpeg')
     * @param options - Optional configuration for the model
     * @returns Parsed JSON result
     */
    async processMultipleImages<T = unknown>(
        imageBuffers: Buffer[],
        prompts: string[],
        mimeTypes: string[] = [],
        options?: GeminiGenerateContentOptions
    ): Promise<GeminiGenerateContentResult<T>> {
        const imageParts = imageBuffers.map((buffer, index) =>
            bufferToGenerativePart(buffer, mimeTypes[index] || 'image/jpeg')
        );

        const content: (string | GeminiImagePart)[] = [
            ...prompts,
            ...imageParts,
        ];

        return this.generateContentAsJson<T>(content, options);
    }
}

