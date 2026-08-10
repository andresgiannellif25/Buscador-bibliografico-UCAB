# Buscador Bibliográfico UCAB

Herramienta de búsqueda para la base de datos bibliográfica de la Facultad 
de Derecho de la UCAB. Archivo principal: buscador_bibliografico_ucab 1.2.html

## Estructura del proyecto
- buscador_bibliografico_ucab 1.2.html — App completa (HTML + CSS + JS en un solo archivo)
- Bibliografía_UCAB_v2.xlsx — Base de datos fuente (no se modifica por la app)

## Columnas del Excel
CODIGO, TITULO, AUTOR, AÑO_PUBLICACION, URL_LINK, NUM_CURSO, COD_MATERIA, ISBN

## Funcionalidades
- Búsqueda exacta por campos
- Búsqueda inteligente con IA (requiere API key Anthropic)
- Búsqueda por documento (Word/PDF/texto): detecta referencias por título/autor/año
  - Compara texto vs filtro de BD (3 categorías: coincide, en BD fuera filtro, no en BD)
- Persistencia local (localStorage)
- Estado por pestaña (cambiar de tab no reinicia la búsqueda)