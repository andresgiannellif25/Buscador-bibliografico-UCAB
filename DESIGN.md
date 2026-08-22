# DESIGN.md — Buscador Bibliográfico · UCAB Derecho

Guía visual **aprobada en mockup** (Claude Design, 2026-08-21). Documenta exactamente
los valores confirmados; es la referencia para aplicar el rediseño al archivo real
`buscador_bibliografico_ucab.html`.

> **Solo modo claro.** El modo oscuro se descartó de forma **intencional** — la app
> se mantiene únicamente en tema claro de aquí en adelante. No es un olvido: no
> re-agregar bloques `@media (prefers-color-scheme: dark)`.

---

## 1. Tema visual y atmósfera

Institucional, académico, sobrio. Identidad de la **Facultad de Derecho de la UCAB**:

- Barra superior roja sólida con el **logo oficial** DERECHO|UCAB.
- Contenido en **tarjetas blancas** sobre un fondo gris claro, con aire generoso.
- El **rojo** se reserva al *cromo* de marca (header, navegación, acciones primarias);
  el contenido es neutro y los **estados** usan color con parquedad.
- Tipografía limpia, jerarquía clara, bordes finos (hairline). Tono formal y legible.

---

## 2. Paleta de colores (rol semántico)

Todos los colores viven como variables CSS en `:root`.

### Marca
| Token | Hex | Rol |
|---|---|---|
| `--brand` | `#c5080e` | **Rojo de marca UCAB** (tomado del logo oficial). Header/appbar, pestaña activa (texto + subrayado), botón primario, botón "Copiar todas". |
| `--brand-strong` | `#a0060b` | Hover del botón primario y de "Copiar todas". |
| `--brand-2` | `#d70b24` | Rojo acento de reserva (detalles/separadores). |
| `--on-brand` | `#ffffff` | Texto/íconos sobre rojo. |

### Neutros
| Token | Hex | Rol |
|---|---|---|
| `--bg` | `#ffffff` | Superficies/tarjetas. |
| `--bg2` | `#f5f5f4` | Fondos sutiles (thead, filtro, cabecera de resumen). |
| `--page` | `#ebebea` | Fondo de página. |
| `--text` | `#1a1a18` | Texto principal. |
| `--t2` | `#6b6b67` | Texto secundario. |
| `--t3` | `#a3a39f` | Texto terciario / placeholders. |
| `--border` | `rgba(0,0,0,.12)` | Bordes hairline. |
| `--border2` | `rgba(0,0,0,.22)` | Bordes de inputs / dashed. |

### Estados (visualmente **DISTINTOS** del rojo de marca)
| Estado / categoría | Token acento | Hex | Fondo tenue (chip) |
|---|---|---|---|
| Coincidencia **total** | `--su` | `#1e7d34` (verde) | `--su-bg` `#eaf3de` |
| Coincidencia **parcial** | `--wa` | `#e07a10` (naranja) | `--wa-bg` `#faeeda` |
| **No encontrado** | `--er` | `#d32027` (rojo fuerte) | `--er-bg` `#fde8e8` |
| En BD, fuera del filtro (info) | `--in` | `#0c447c` (azul) | `--in-bg` `#e6f1fb` |
| Sin coincidencia en BD (**categoría D**) | `--vi` | `#6d28d9` (violeta) | `--vi-bg` `#f5f3ff`, borde `--vi-bd` `#ddd6fe` |

**Marca vs. estado (regla explícita):** el rojo de marca `#c5080e` vive **solo en el
cromo** (header, pestaña activa, botones primarios). El rojo de estado "no encontrado"
`#d32027` vive **solo dentro de las tarjetas** (barra indicadora de 4 px, punto de
leyenda). Son tonos distintos y ocupan zonas distintas — no se confunden. Verde,
naranja y rojo de estado van a **plena intensidad** (sin atenuar).

---

## 3. Tipografía

- **Poppins** (Google Fonts, pesos 400/500/600/700/800) → títulos, encabezados, UI
  (clase `.u-head`).
- **Open Sans** (Google Fonts, 400/500/600/700) → cuerpo y tablas (fuente base del
  documento).
- Fallbacks: `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`.

Carga: `<link>` a `fonts.googleapis.com` (único host de fuentes permitido por el CSP).

### Jerarquía de tamaños (tal como en el mockup)
| Elemento | Tamaño / peso |
|---|---|
| Base (cuerpo, Open Sans) | 15px / 400 |
| Nombre de herramienta (header, Poppins) | 18px / 600 |
| Título de sección (Poppins) | 15px / 600 |
| Subtítulo de sección | 13px / 400 · color `--t2` |
| Pestañas | 14px / 500 (activa 600) |
| Barra de estado / etiqueta de filtro | 13px |
| Número de estadística | 26px / 700 |
| Etiqueta de estadística | 11px |
| Etiqueta de chips | 12px / 600 |
| Chip | 12px |
| Tabla · `th` | 11px / 600 · MAYÚSCULAS · `letter-spacing:.04em` · `--t2` |
| Tabla · `td` | 13px |
| Botón | 14px (primario 600) · "Copiar todas" 12px / 600 |
| Badge / código (`.cod`) | 12px (código en monoespaciada) |

---

## 4. Logo

**Aprobado: el PNG oficial "DERECHO|UCAB" incrustado tal cual (NO recreado).**

- **Asset:** `derecho-ucab.png` — recortado del original oficial (2178×722, fondo
  transparente) al banner, aplanado sobre `#c5080e`, redimensionado a **722×120**,
  optimizado (~8.6 KB).
- **Composición del logo:** banner rojo `#c5080e` con **tres figuras blancas
  verticales alargadas** (tipo *lozenge* / hexágono apuntado — anchas al centro,
  afiladas arriba y abajo) seguidas del wordmark **"DERECHO | UCAB"** en blanco, bold.
- **Colocación en el header:** `<img>` a `height:34px` (ancho automático), junto a un
  divisor vertical blanco (`1px`, `rgba(255,255,255,.4)`) y el nombre
  **"Buscador Bibliográfico"**.

```html
<div class="brand">
  <img class="logo-img" src="derecho-ucab.png" alt="Derecho UCAB">
  <span class="brand-div"></span>
  <div class="brand-title u-head">Buscador Bibliográfico</div>
</div>
```

> **Corrección de acta (importante):** **no existe** un "SVG de pétalos aprobado". Esa
> recreación vectorial fue **rechazada** durante la iteración; lo aprobado es el **PNG
> real**. No incrustar una recreación dibujada a mano. Si se desea un vector en el
> repo, debe ser una **vectorización fiel del PNG oficial**, como tarea aparte.

---

## 5. Estilo de componentes

### Botones
- Base `.btn`: fondo `--bg`, borde `.5px solid --border2`, radio `--r-md` (8px),
  padding `9px 15px`, 14px/500, ícono + texto con `gap:7px`.
- Primario `.btn.primary`: fondo `--brand` `#c5080e`, texto blanco, 600; hover
  `--brand-strong` `#a0060b`.
- "Copiar todas" (`.copy-all`): fondo `--brand`, blanco, 12px/600, radio `--r-md`,
  padding `5px 11px`; hover `--brand-strong`.
- Botón fantasma en header (`.ghost-btn`): 36×36, fondo `rgba(255,255,255,.14)`, borde
  `rgba(255,255,255,.28)`, ícono blanco.

### Chips
- Forma píldora: `border-radius:20px`, padding `4px 11px`, 12px, `max-width:340px`,
  texto con elipsis.
- Chip de **categoría D** (sin coincidencia): fondo `--vi-bg`, texto `--vi`, borde
  `.5px --vi-bd`; botón de copia individual embebido (`.cbtn`, ícono, `opacity:.5` →
  `1` en hover).

### Tabla de resultados
- Contenedor con `overflow:hidden` y borde/radio del bloque de resumen.
- `thead` fondo `--bg2`; `th` 11px MAYÚSCULAS; `td` 13px; filas separadas por hairline
  `.5px --border`.
- **Barra indicadora de estado** a la izquierda (`.ind`, `width:4px`): verde `.i-ex`,
  naranja `.i-pa`, rojo `.i-nf` — a **plena intensidad**.
- Fila "no encontrada" (`.row-nf`): el **texto** se atenúa (`td:not(.ind){opacity:.5}`)
  pero la **barra de estado se mantiene a full**.
- Leyenda de colores (`.tbl-note`) con puntos 9×9 (`.d-ex/.d-pa/.d-nf`).

### Estadísticas de resumen
- Fila de 3 stats; número 26px/700 coloreado por categoría (`--su` total, `--vi`
  categoría D, `--t2` total analizadas); etiqueta 11px `--t2`.

---

## 6. Espaciado / layout

- **Contenedor:** `max-width:900px`, centrado, padding `22px 22px 40px`.
- **Header (`.appbar`):** padding `13px 26px`, banda roja sólida `--brand`.
- **Tarjeta (`.card`):** fondo `--bg`, borde `.5px --border`, radio `--r-lg` (12px),
  padding `22px`.
- **Radios:** `--r-md` 8px (inputs, botones, chips-contenedor, badges, filtros,
  resumen); `--r-lg` 12px (tarjetas).
- **Bordes:** hairline `.5px` con `--border`; inputs/dashed con `--border2`.
- **Ritmo vertical:** secciones separadas ~16–22px; resumen `margin-top:20px`.
- **Agrupaciones** (botones, chips, stats, pestañas): siempre con `display:flex/grid` +
  `gap`, nunca por márgenes sueltos.

---

## 7. Qué SÍ y qué NO

**SÍ**
- Usar el **rojo de marca `#c5080e`** solo en cromo: header, pestaña activa, botón
  primario, "Copiar todas".
- Mantener los **colores de estado a plena intensidad** y distintos entre sí y del rojo
  de marca.
- Cargar Poppins + Open Sans por Google Fonts con sus *fallbacks*.
- Incrustar el **logo PNG oficial** tal cual.
- Definir toda la paleta como variables CSS en `:root`.
- Conservar toda la funcionalidad y la estructura existentes (esto es capa visual).

**NO**
- **No** re-agregar modo oscuro (`@media prefers-color-scheme: dark`) — descartado a
  propósito.
- **No** recrear el logo a mano (ni pétalos SVG ni barras) — usar el PNG.
- **No** usar el rojo de marca para estados, ni el rojo de estado para cromo.
- **No** volver al `#c52127` inicial (ver nota de discrepancia) ni a los verdes/naranjas
  apagados originales (`#3b6d11` / `#854f0b`).
- **No** tocar la lógica de matching, las categorías, ni el parseo — el rediseño es
  puramente CSS + marcado presentacional.
- **No** añadir dependencias nuevas más allá de Google Fonts; respetar el esquema SRI
  vigente en los CDN.

---

### Notas de discrepancia (respecto a lo pedido vs. lo aprobado)

1. **Rojo de marca:** el mockup aprobado usa **`#c5080e`** (rojo real del logo oficial),
   no `#c52127`. El `#c52127` fue el valor inicial muestreado del sitio web, **superado**
   al incrustar el logo real.
2. **Logo:** lo aprobado es el **PNG real incrustado**, no un SVG de pétalos (esa
   recreación fue rechazada). Documentado como asset raster.
3. **Colores de estado:** los valores finales aprobados ("subidos") son verde `#1e7d34`,
   naranja `#e07a10`, rojo `#d32027` — no los tonos apagados originales de la app.
