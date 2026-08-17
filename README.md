# Buscador Bibliográfico UCAB

Herramienta web para buscar y cotejar referencias contra la base de datos
bibliográfica de la Facultad de Derecho de la UCAB. Es un **único archivo HTML**
con JavaScript vanilla — sin backend, sin build, sin dependencias que instalar.
Se abre con doble clic o sirviéndolo como archivo estático.

Archivo principal: `buscador_bibliografico_ucab.html`

## Estructura del proyecto
- `buscador_bibliografico_ucab.html` — App completa (HTML + CSS + JS en un solo archivo)
- `Bibliografía_UCAB Corregido.xlsx` — Base de datos fuente (la app solo lee, no la modifica)

## Columnas del Excel
`CODIGO, TITULO, AUTOR, AÑO_PUBLICACION, URL_LINK, NUM_CURSO, COD_MATERIA, ISBN`

Las columnas se detectan automáticamente por nombre de cabecera.

## Stack
- HTML + CSS + JavaScript vanilla, todo en un archivo. Tema claro/oscuro automático.
- Sin backend ni build. Datos persistidos en `localStorage`.
- Librerías cargadas por CDN, **con SRI (`integrity` + `crossorigin`)**:
  [SheetJS/xlsx](https://sheetjs.com) (Excel), [mammoth.js](https://github.com/mwilliamson/mammoth.js) (Word),
  [pdf.js](https://mozilla.github.io/pdf.js/) (PDF) y [Tabler Icons](https://tabler.io/icons).
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
Pegas o subes una bibliografía (texto, Word `.docx` o PDF) y la app compara cada
referencia contra la base de datos, clasificándola en:
- **Coincide** con la base de datos
- **En la BD, fuera del filtro** activo
- **Sin coincidencia** en la base de datos
- Y, si hay un filtro activo, los registros del filtro que **ninguna** referencia citó.

En la tabla de resultados, cada fila lleva una barra de color: **verde** (coincidencia
total), **naranja** (coincidencia parcial) y **rojo** (registro cargado en el filtro
pero no encontrado en el texto).

**Motor de matching (léxico).** El emparejamiento es puramente léxico, sin
aprendizaje automático:
- `matchRecord` compara un registro contra un segmento de texto y devuelve
  `exact` / `partial` / sin coincidencia, combinando: coincidencia exacta de
  título, solapamiento de palabras clave (ignorando *stopwords*), una **racha de
  frase contigua** (anti-coincidencias por palabras dispersas), y confirmación por
  **autor**, **año** e **ISBN**.
- `bestMatch` elige la mejor coincidencia de cada registro a lo largo del texto.
- Reglas conservadoras para evitar falsos positivos: el año por sí solo nunca
  confirma un match; los títulos cortos exigen coincidencia de autor.

Otras características:
- Persistencia local (`localStorage`): al recargar ofrece restaurar la última base cargada.
- Estado por pestaña: cambiar de pestaña no reinicia la búsqueda en curso.

## Seguridad
- **SRI** en los 4 recursos CDN (`integrity="sha512-…"` + `crossorigin`): protege
  ante un CDN comprometido que pudiera inyectar código y leer la API key del `localStorage`.
- **Validación de esquema en URLs**: los enlaces del Excel solo se vuelven clicables
  si empiezan por `http://` o `https://` (evita esquemas peligrosos como `javascript:`).
- **Manejo de error de lectura**: un fallo al leer el Excel se reporta en vez de quedar en silencio.
- La API key nunca se guarda en el archivo ni en el repo — solo en el `localStorage`
  del navegador. No usar en un equipo compartido.

## Uso
1. Abre el HTML en el navegador.
2. Sube tu Excel (o restaura el guardado).
3. Elige una pestaña de búsqueda y empieza.

Para búsqueda inteligente: pega tu API key de Anthropic en Configuración.
