# Reading the Odds

A narrated slide deck that teaches multivariable logistic regression. The deck is written as a bite-sized walk through multivariable logistic regression. Section 1 builds in four steps: an exact straight line, then uncertainty, then a yes-or-no outcome, then several predictors. Section 2 applies all of it a table from a paper. The deck is built with [Quarto](https://quarto.org) and [reveal.js](https://revealjs.com). Every figure is drawn in R with ggplot2. Every spoken line lives in one dedicated Markdown file.

## How the files fit together

| File | What it does |
|------------------------------------|------------------------------------|
| `slides.qmd` | The deck. Each slide calls one plotting function and one speaker note. |
| `plots.R` | Every figure, as one function per slide. |
| `notes.R` | Reads `notes.md` and prints each note into the right slide. |
| `notes.md` | The spoken script, one entry per slide. |
| `custom.scss` | Colors, fonts, and layout for the title slide and headings. |

`slides.qmd` sources `plots.R` and `notes.R` in its setup chunk. 

## How the progressive reveals work

Most figures build up piece by piece. Each plotting function takes a `stage` argument, and each stage adds one element, so the audience sees one idea arrive at a time. Every function defaults to its final stage, so you can call `plot_fig_slide_09()` on its own to see the finished figure. For the speaker, a `[/]` in the speaker notes marks when to advance the slide reveal. 

| Function                      | Slide topic                      | Stages |
|-------------------------------|----------------------------------|--------|
| `plot_fig_slide_01()`         | Title sigmoid                    | none   |
| `plot_fig_slide_02(n_panels)` | Roadmap                          | 1–4    |
| `plot_fig_slide_03(stage)`    | Three glasses of water           | 1–3    |
| `plot_fig_slide_04(stage)`    | Celsius and Fahrenheit           | 1–4    |
| `plot_fig_slide_05(stage)`    | Balance scales                   | 1–4    |
| `plot_fig_slide_06(stage)`    | Height and weight                | 1–6    |
| `plot_fig_slide_07(stage)`    | A yes-or-no outcome              | 1–7    |
| `plot_fig_slide_08(stage)`    | Odds                             | 1–3    |
| `plot_fig_slide_09(stage)`    | The log-odds number line         | 1–9    |
| `plot_fig_slide_10(stage)`    | One model, two views             | 1–2    |
| `plot_fig_slide_11()`         | Reading a coefficient            | none   |
| `plot_fig_slide_12(stage)`    | Odds ratio                       | 1–4    |
| `plot_fig_slide_13(stage)`    | Adjustment and Simpson's paradox | 1–12   |
| `plot_fig_slide_15(stage)`    | The study                        | 1–4    |
| `plot_fig_slide_16(stage)`    | Table 5                          | 1–8    |
| `f_forest()`                  | Table 5 as a forest plot         | none   |

## Rendering the deck

Run bash `quarto render slides.qmd` for Quarto to write `slides.html` and a `slides_files/` folder. The render regenerates `sigmoid.png` into the project folder for the title slide. Open `slides.html` in a browser. Press **S** to open the speaker view. Run bash `quarto preview slides.qmd` to preview while you edit. 

## Editing the speaker notes

Open `notes.md`. Start each heading text with single word, like `# slide-07`. `slides.qmd` pulls a note in with `speaker_note("slide-07")`. Never start a line of prose with `#` followed by a single word because the parser reads that as a new note. Never use two headings with the same key. 

## The title slide is a special case

The title slide is a special case. reveal.js builds it automatically, and it can't hold a `.notes` block. Instead, `title_slide_decorations("slide-01")` attaches the note as a `data-notes` attribute and adds the sigmoid image. 

## Changing colors and fonts

Edit the variables at the top of `custom.scss`:

| Variable       | Where you see it            |
|----------------|-----------------------------|
| `$deck-green`  | Title slide background      |
| `$deck-teal`   | Subtitle                    |
| `$deck-blue`   | Sigmoid curve               |
| `$deck-ink`    | Headings on white slides    |
| `$deck-accent` | "Section 1" label and links |

The title slide background also appears as `data-background-color` in the YAML header of `slides.qmd`. Figure colors live inside `plots.R`, near the top of each function; they don't read the SCSS variables.

## Paper citation

> Pulsipher AM, Khattar G, Harris E, White V, Stout C, Vikram HR, Patel R, Simner PJ. 2026. *Legionella* 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity. **J Clin Microbiol** 64:e00356-26. <https://doi.org/10.1128/jcm.00356-26>

## Software requirements

-   **Quarto** 1.4 or later
-   **R** 4.1 or later (the code uses the native `|>` pipe)
-   **R packages:** ggplot2, dplyr, tidyr, tibble, stringr, forcats, purrr, readr, rlang, cli, gt, patchwork, ggforce, ggtext, tidyselect, systemfonts

## Disclaimer

The views and opinions expressed in this document are those of the author(s) and do not represent the official position, policy, or endorsement of the Department of Defense (also known as the Department of War), the United States Government, or any of their agencies or components, unless another official document expressly designates them as such.

## Author

John Paul Bisciotti
