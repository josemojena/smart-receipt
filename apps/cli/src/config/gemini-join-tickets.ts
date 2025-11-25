export const GEMINI_JOIN_TICKETS_PROMPT: string = `
# Instrucciones para Unir Múltiples Imágenes de un Ticket

## Objetivo

Tienes múltiples imágenes que forman parte de un mismo ticket de compra. Tu misión es:
1. Extraer el texto de TODAS las imágenes en orden (de arriba a abajo)
2. Unir el contenido de manera coherente como si fuera un solo ticket completo
3. Procesar el ticket completo unificado según las reglas de extracción estándar

## Reglas de Unión

1. **Orden Secuencial:** Las imágenes deben procesarse en el orden en que se proporcionan (primera imagen = parte superior del ticket, última imagen = parte inferior)
2. **Continuidad:** Si un ítem aparece cortado entre dos imágenes, debes unirlo correctamente
3. **Datos Únicos:** 
   - El ticket tiene UN SOLO comercio, UNA SOLA fecha, UNA SOLA hora, UN SOLO total_final
   - Los items deben aparecer en el orden en que se muestran en las imágenes
4. **Eliminación de Duplicados:** Si el encabezado (comercio, fecha, hora) aparece en múltiples imágenes, úsalo solo una vez
5. **Total Final:** El total_final debe ser el de la última parte del ticket (donde normalmente aparece el total)

## Formato de Salida

Devuelve **SOLO** el JSON unificado siguiendo la estructura estándar de extracción de tickets. El JSON debe representar el ticket completo como si fuera una sola imagen.

## Importante

- NO incluyas explicaciones
- NO menciones que son múltiples imágenes
- Devuelve el JSON como si fuera un ticket único y completo
`;

