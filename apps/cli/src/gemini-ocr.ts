import { GoogleGenerativeAI } from '@google/generative-ai';
import fs from 'fs';

import { GEMINI_SYSTEM_PROMPT } from './config/gemini-prompts';
import { GEMINI_JOIN_TICKETS_PROMPT } from './config/gemini-join-tickets';

const genAI = new GoogleGenerativeAI(
  process.env.GEMINI_API_KEY || 'REPLACED_API_KEY'
);

// Función para convertir imagen a base64
const fileToGenerativePart = (filePath: string, mimeType: string) => {
    return {
      inlineData: {
      data: Buffer.from(fs.readFileSync(filePath)).toString('base64'),
      mimeType,
      },
    };
};
export const extractTextFromImage = async (imagePath: string) => {
    // Usar el modelo Gemini Pro Vision o Gemini 1.5
  const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });
  
  const imagePart = fileToGenerativePart(imagePath, 'image/jpeg');

  const result = await model.generateContent([GEMINI_SYSTEM_PROMPT, imagePart]);
  const response = await result.response;
  const text = response.text();

  return text;
};

/**
 * Extrae texto de múltiples imágenes de un ticket y las une en un solo JSON
 * @param imagePaths Array de rutas de imágenes en orden (de arriba a abajo del ticket)
 * @returns JSON unificado del ticket completo
 */
export const extractTextFromMultipleImages = async (
  imagePaths: string[]
): Promise<string> => {
  const model = genAI.getGenerativeModel({ model: 'gemini-2.5-flash' });

  // Convertir todas las imágenes a base64
  const imageParts = imagePaths.map((imagePath) =>
    fileToGenerativePart(imagePath, 'image/jpeg')
  );

  // Crear el contenido: prompt de unión + todas las imágenes
  const content = [GEMINI_JOIN_TICKETS_PROMPT, GEMINI_SYSTEM_PROMPT, ...imageParts];
  
  const result = await model.generateContent(content);
    const response = await result.response;
    const text = response.text();
    
    return text;
};

// Ejemplo de uso con una sola imagen
// const imagePath = path.resolve(__dirname, '../assets/nespresso.jpeg');
// extractTextFromImage(imagePath)
//   .then((text) => console.log('Text extracted:', text))
//   .catch((err) => console.error('Error extracting text:', err));

// Ejemplo de uso con múltiples imágenes (ticket largo)
// const imagePaths = [
//   path.resolve(__dirname, '../assets/ticket-part1.jpeg'),
//   path.resolve(__dirname, '../assets/ticket-part2.jpeg'),
//   path.resolve(__dirname, '../assets/ticket-part3.jpeg'),
// ];
// extractTextFromMultipleImages(imagePaths)
//   .then((text) => console.log('Ticket completo unificado:', text))
//   .catch((err) => console.error('Error uniendo tickets:', err));
