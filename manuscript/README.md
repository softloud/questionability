# Manuscript Compilation

Created by Copilot, needs to be stress tested for bugs.

## Compile

```bash
make           # Build both document-draft.pdf and document-pub.pdf
make draft     # Build only draft version  
make pub       # Build only publication version
```

Or manually:
```bash
pdflatex -jobname=document-draft "\def\draftmode{}\input{document.tex}"    # For draft version
pdflatex -jobname=document-pub "\def\pubmode{}\input{document.tex}"       # For publication version
```

Clean auxiliary files:
```bash
make clean
```

## Editing

Edit content in `document.tex` - this single file is used to generate both versions.
- Draft version: Wide margins, todo notes visible
- Publication version: Standard margins, todo notes hidden

The preamble automatically handles the differences between draft and publication modes.

## Todo Notes

- `\hannah{note}` - Blue margin note
- `\charles{note}` - Brown margin note

## Preamble & Format Customization

The manuscript uses conditional formatting with two main preamble files:

### Preamble Files

- **`preamble.tex`** - Main preamble with complete configuration
- **`preamble-base.tex`** - Alternative minimal preamble

Both files support draft/publication mode switching and contain the same core structure:

### Key Customization Areas

#### 1. Page Layout & Margins

**Draft mode:**
```latex
\usepackage[left=0.5in, right=2.5in, top=1in, bottom=1in, 
           marginparwidth=2in, marginparsep=0.3in]{geometry}
```

**Publication mode:**
```latex
\usepackage[margin=1in]{geometry}
```

Edit these values in the preamble file to adjust page margins.

#### 2. Line Spacing

**Draft mode:** `\onehalfspacing` (easier reading)  
**Publication mode:** `\doublespacing` (standard academic)

#### 3. Figure Sizing

Predefined commands for consistent figure sizing:
- `\figwidth` - Main figures (0.9 draft, 0.8 pub)
- `\smallfigwidth` - Smaller figures (0.7 draft, 0.6 pub)

#### 4. Todo Note Colors

Customize author note colors:
```latex
\definecolor{hannahcolor}{RGB}{106, 90, 205}  % Slate blue
\definecolor{charlescolor}{RGB}{139, 69, 19}  % Saddle brown
```

Add new author commands:
```latex
\newcommand{\newauthor}[1]{\todo[color=yourcolor!40,author=Name]{#1}}
```

#### 5. Section Formatting

Modify section headers:
```latex
\titleformat{\section}{\large\bfseries}{\thesection.}{0.5em}{}
\titleformat{\subsection}{\bfseries}{\thesubsection.}{0.5em}{}
```

#### 6. Common LaTeX Packages

The preamble includes standard packages:
- **Math:** `amsmath`, `amssymb`, `amsthm`
- **Graphics:** `graphicx`, `booktabs`, `array`, `longtable` 
- **Citations:** `natbib` with `[authoryear,round]`
- **Links:** `hyperref` with colored links
- **Line numbers:** `lineno` (draft mode only)

### Making Changes

1. **Simple changes:** Edit values directly in `preamble.tex`
2. **New packages:** Add `\usepackage{}` commands in appropriate sections
3. **Mode-specific changes:** Use `\ifdefined\draftmode` conditionals
4. **Test changes:** Compile both draft and pub versions to verify

### Example: Adding Custom Styling

To add a new highlight command:
```latex
% Add after color definitions
\definecolor{highlight}{RGB}{255, 255, 0}  % Yellow
\newcommand{\highlight}[1]{\colorbox{highlight}{#1}}
```