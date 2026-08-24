🇪🇸 [Español](README.md) | 🇺🇸 English

# Bibliographic Search · UCAB Derecho

A web tool that checks, against the university's official system, which references
from a course syllabus are already registered, which are incorrectly linked to the
course, and which were never uploaded — a cross-check done today by hand, line by
line.

**A single HTML file. No backend, no installation. Opens with a double-click.**

![App header with the UCAB Law visual identity](docs/captura-encabezado.png)

---

## The problem

At the UCAB Faculty of Law, every course syllabus comes with a bibliography of dozens
of references. To know whether those works are available to students, someone has to
check, **one by one**, whether each reference is already loaded in **Banner 9** (the
official academic system) and correctly linked to the course.

That manual cross-check is slow and error-prone: it requires telling apart three
distinct situations that look alike at a glance —

1. The work is **already** in the system and linked to the correct course.
2. The work **exists** in the system but is **not linked** to that course
   (mis-catalogued).
3. The work was **never registered** and has to be uploaded.

This tool automates that cross-check: you load the official bibliographic database
(exported from Banner 9, **11,237 records**), paste a syllabus's bibliography, and in
seconds it classifies each reference into the category it belongs to.

---

## How it works — document cross-check

The heart of the app. You paste or upload the bibliography (text, Word `.docx`, or PDF)
and each reference is classified and color-coded by its status.

**Instant summary.** Each reference in the syllabus falls into one of four categories,
counted and listed as colored chips:

![Cross-check summary: the row of four categories with references as colored chips](docs/captura-por-documento-resumen.png)

| Color | Category | What it means for the cross-check |
|---|---|---|
| 🟢 **Green** | Match | The reference is already loaded and linked to the course. |
| 🔵 **Blue** | In the database, outside the filter | It exists in the system, but is **not** linked to this course (mis-catalogued). |
| 🟣 **Purple** | No match | **Never registered** — it has to be uploaded to Banner 9. |
| 🔴 **Red** | Not cited | Records the system has for the course that the syllabus does not mention. |

**Record-by-record detail.** Each row carries its status bar in the matching color, and
the missing references are copied with one click to hand off to whoever loads them into
the system:

![Detailed results table with the per-row status bar and the "Copy all" button](docs/captura-por-documento-tabla.png)

The matching is **purely lexical** (no AI involved): it compares exact titles, keyword
overlap (ignoring *stopwords*), contiguous-phrase runs, and confirms with author, year,
and ISBN. The rules are conservative to avoid false positives: the year alone never
confirms a match, and short titles require an author match.

The **no-match** references (the ones that must be uploaded) are copied with a button
—individually or all at once— to hand directly to whoever registers them in the system.

---

## Features

- **Three search modes:**
  - **By document** — the bulk cross-check described above, with the four categories.
  - **Exact** — filter by fields (code, title, author, year, course, area) applied live
    as you type.
  - **Smart (optional)** — turns a natural-language query into field filters using the
    Anthropic API. It requires your own API key; without it, the other two modes work
    without limits.
- **A 4-category color system** that answers, at a glance, the three questions of the
  manual cross-check.
- **Copy button** for the missing references (the "no match" category).
- **Local persistence** (`localStorage`): on reload it offers to restore the last loaded
  database.

---

## Tech stack

- **Vanilla HTML + CSS + JavaScript**, all in **a single file**. No frameworks, no
  backend, no build step.
- Runs in any modern browser — double-click or served as a static file.
- Excel/Word/PDF reading in the browser via CDN libraries (SheetJS, mammoth.js,
  pdf.js), loaded **with SRI** (`integrity` + `crossorigin`).
- UCAB Law visual identity: institutional red `#c5080e`, Poppins + Open Sans typefaces,
  official logo. Light theme.

Being a single file is a design decision: the tool is used by administrative staff
without a technical setup, so it had to open without installing anything and without
depending on a server.

---

## Engineering process

The project didn't stop at "it works": it went through several hardening stages, all
traceable in the commit history.

- **Security audit.** *Subresource Integrity* was added to the CDN resources (protecting
  against a compromised CDN that could inject code), URL scheme validation on the
  database URLs (only `http`/`https`, closing dangerous schemes like `javascript:`), and
  explicit handling of file-read errors.
- **Matching precision fix, validated with real data.** A concrete false positive was
  closed (a citation that matched the wrong author) by tightening the title-match rule,
  and the result was verified against the full 11,237-record database to confirm it did
  not break legitimate matches.
- **Performance optimization.** Each record's derived metadata (normalized title, author
  signals, keywords) is precomputed once when the database loads and reused, instead of
  being recomputed on every comparison. In tests with the full real database, cross-check
  time dropped from ~1996 ms to ~1235 ms.

---

## How to run it locally

No installation or dependencies required.

1. Clone or download the repository.
2. Open `buscador_bibliografico_ucab.html` in the browser (double-click).
3. Upload your bibliographic database in Excel (or restore the last saved one).
4. Choose a search mode and get started.

> For **smart search** (optional), paste your own Anthropic API key in Settings. It is
> stored only in your browser (`localStorage`) and never leaves your machine.

If you prefer to serve it as a static file (for example, to test `.docx`/`.pdf` loading
without `file://` restrictions), any static server works.

---

## Project structure

```
buscador_bibliografico_ucab.html   The complete app (HTML + CSS + JS in one file)
DESIGN.md                          Visual identity guide (palette, typography, components)
README.en.md                       This file
```
