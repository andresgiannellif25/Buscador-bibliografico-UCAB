# Buscador Bibliográfico UCAB

Herramienta web para buscar y cotejar referencias contra la base de datos
bibliográfica de la Facultad de Derecho de la UCAB. Es un **único archivo HTML**
con JavaScript vanilla — sin backend, sin build, sin dependencias que instalar.
Se abre con doble clic o sirviéndolo como archivo estático.

Archivo principal: `buscador_bibliografico_ucab 1.2.html`

## Estructura del proyecto
- `buscador_bibliografico_ucab 1.2.html` — App completa (HTML + CSS + JS en un solo archivo)
- `Bibliografía_UCAB_v2.xlsx` — Base de datos fuente (~12.000 registros; la app solo lee, no la modifica)

## Columnas del Excel
`CODIGO, TITULO, AUTOR, AÑO_PUBLICACION, URL_LINK, NUM_CURSO, COD_MATERIA, ISBN`

Las columnas se detectan automáticamente por nombre de cabecera.

## Stack
- HTML + CSS + JavaScript vanilla, todo en un archivo. Tema claro/oscuro automático.
- Sin backend ni build. Datos persistidos en `localStorage`.
- Librerías cargadas por CDN (con SRI): [SheetJS/xlsx](https://sheetjs.com) (Excel),
  [mammoth.js](https://github.com/mwilliamson/mammoth.js) (Word), [pdf.js](https://mozilla.github.io/pdf.js/) (PDF)
  y [Tabler Icons](https://tabler.io/icons).
- La búsqueda inteligente usa la API de Anthropic (opcional, requiere API key propia).

## Funcionalidades

### 1. Búsqueda exacta
Filtro por campos (código, título, autor, año, curso, área) que se aplica en vivo
mientras se escribe.

### 2. Búsqueda inteligente (IA)
Convierte una consulta en lenguaje natural en filtros de campo usando la API de
Anthropic. Requiere una API key propia, que se guarda solo en tu navegador
(`localStorage`). Sin key, las otras dos búsquedas funcionan igual.

### 3. Búsqueda por documento
Pegas o subes una bibliografía (texto, Word `.docx` o PDF) y la app empareja cada
referencia con la base de datos. Por cada línea del texto se elige su mejor
coincidencia y se clasifica en:
- **Coincide** (en el filtro activo)
- **Autor N/A** — coincide por título pero el registro no tiene autor en la BD (revisar a mano)
- **En la BD, fuera del filtro**
- **Sin coincidencia en la BD**
- Y, si hay filtro activo, los registros del filtro que **ninguna** referencia citó.

**Motor de matching (léxico).** El emparejamiento es puramente léxico, sin
aprendizaje automático:
- `scoreMeta` puntúa cada registro contra una línea combinando: coincidencia
  exacta de título, solapamiento de palabras clave (ignorando *stopwords*),
  **racha de frase contigua** más larga (anti-coincidencias por palabras dispersas),
  y señales de confirmación por **autor**, **año** e **ISBN**.
- Reglas conservadoras para evitar falsos positivos: los títulos cortos o genéricos
  exigen coincidencia de autor; el año por sí solo nunca confirma un match.

Otras características:
- Persistencia local (`localStorage`): al recargar ofrece restaurar la última base cargada.
- Estado por pestaña: cambiar de pestaña no reinicia la búsqueda en curso.

## Uso
1. Abre el HTML en el navegador.
2. Sube tu Excel (o restaura el guardado).
3. Elige una pestaña de búsqueda y empieza.

Para búsqueda inteligente: pega tu API key de Anthropic en Configuración.
No la uses en un equipo compartido — la key queda en el `localStorage` de ese navegador.

## Roadmap / próximos pasos
- **Motor de búsqueda semántico (exploratorio).** Se prototipó una variante con
  *embeddings* multilingües en el navegador (`@xenova/transformers`) y fusión
  léxico-semántica (Reciprocal Rank Fusion) como posible mejora futura del
  emparejamiento por documento. **No forma parte de esta versión**; queda como
  línea de trabajo pendiente de evaluar.
- Desambiguación de ediciones duplicadas del mismo título cuando la cita no trae año.
- Evaluar `IndexedDB` en lugar de `localStorage` para persistir bases grandes.
