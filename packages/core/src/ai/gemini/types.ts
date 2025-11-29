/**
 * Type definitions for Gemini AI client
 */

export type AsyncFunction<T> = (...args: any[]) => Promise<T>;
export type TransientErrorChecker = (error: Error) => boolean;

export interface GeminiImagePart {
    inlineData: {
        data: string;
        mimeType: string;
    };
}


export interface GeminiGenerateContentOptions {
    model?: string;
    temperature?: number;
    maxOutputTokens?: number;
}

export interface GeminiGenerateContentResult<T = unknown> {
    success: boolean;
    data: T | null;
    rawResponse?: string;
    error?: string;
}

