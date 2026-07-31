# Reading the Odds

A narrated slide deck that teaches multivariable logistic regression, starting from `y = mx + b` and ending with a published odds ratio table.

The deck is built with [Quarto](https://quarto.org) and [reveal.js](https://revealjs.com). Every figure is drawn in R with ggplot2 so there are no image files to keep in sync. Every spoken line lives in one Markdown file so you can revise the script without touching the slides.

## Who this is for

The deck is written for a listener who wants a bite-sized walk through multivariable logistic regression. It builds in four steps: an exact straight line, then uncertainty, then a yes-or-no outcome, then several predictors. Section 2 applies all of it to Table 5 of a real microbiology paper.

If you are that listener, watch the video. If you want to change the deck, read on.

## What you need

-   **Quarto** 1.4 or later
-   **R** 4.1 or later (the code uses the native `|>` pipe)
-   **R packages:** ggplot2, dplyr, tidyr, tibble, stringr, forcats, purrr, readr, rlang, cli, gt, patchwork, ggforce, ggtext, tidyselect, systemfonts

Install the packages with:

``` r
install.packages(c(
  "ggplot2", "dplyr", "tidyr", "tibble", "stringr", "forcats",
  "purrr", "readr", "rlang", "cli", "gt", "patchwork",
  "ggforce", "ggtext", "tidyselect", "systemfonts"
))
```

Each plotting function checks for the packages it needs and stops with a clear message if one is missing.

## How do you render the deck?

Run this from the project folder:

``` bash
quarto render slides.qmd
```

Quarto writes `slides.html` and a `slides_files/` folder. Open `slides.html` in a browser. Press **S** to open the speaker view, which shows the notes and the next slide.

To preview while you edit, run `quarto preview slides.qmd`. The browser reloads on every save.

The render also writes `sigmoid.png` into the project folder. That image sits on the title slide, and the deck regenerates it every time, so you don't need to commit it.

## How the files fit together

| File | What it does |
|------------------------------------|------------------------------------|
| `slides.qmd` | The deck. Each slide calls one plotting function and one speaker note. |
| `plots.R` | Every figure, as one function per slide. |
| `notes.R` | Reads `notes.md` and prints each note into the right slide. |
| `notes.md` | The spoken script, one entry per slide. |
| `custom.scss` | Colors, fonts, and layout for the title slide and headings. |

`slides.qmd` sources `plots.R` and `notes.R` in its setup chunk. Nothing else in the project depends on anything else.

## How do you edit the speaker notes?

Open `notes.md`. Each note starts with a heading whose text is a single word, like `# slide-07`. The note runs from that heading to the next one.

Edit the prose freely. Em-dashes, quotation marks, apostrophes, and multiple paragraphs all work. A `[/]` marks the point where you advance to the next build of the slide.

Two rules keep the parser happy:

-   Never start a line of prose with `#` followed by a single word. The parser reads that as a new note.
-   Never use two headings with the same key. `notes.R` stops with an error if you do.

`slides.qmd` pulls a note in with `speaker_note("slide-07")`. If the key doesn't exist, the render fails and the error lists every key that does.

The title slide is a special case. reveal.js builds it automatically, and it can't hold a `.notes` block. Instead, `title_slide_decorations("slide-01")` attaches the note as a `data-notes` attribute and adds the sigmoid image. Call it from inside a real slide — the Disclaimer slide does this. If you move it above the first `##` heading, Quarto creates a blank slide before the deck starts.

## How do the progressive reveals work?

Most figures build up piece by piece. Each plotting function takes a `stage` argument, and each stage adds one element. `slides.qmd` repeats the same slide title with a higher `stage` each time, so the audience sees one idea arrive at a time.

Every function defaults to its final stage, so you can call `plot_fig_slide_09()` on its own to see the finished figure.

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

Slide 14 has no function. It is the Section 1 summary, written in HTML and styled inline in `slides.qmd`.

An out-of-range `stage` falls back to the final stage. Some functions warn first, others fall back silently.

## How do you change the colors and fonts?

Edit the variables at the top of `custom.scss`:

| Variable       | Where you see it            |
|----------------|-----------------------------|
| `$deck-green`  | Title slide background      |
| `$deck-teal`   | Subtitle                    |
| `$deck-blue`   | Sigmoid curve               |
| `$deck-ink`    | Headings on white slides    |
| `$deck-accent` | "Section 1" label and links |

The title slide background also appears as `data-background-color` in the YAML header of `slides.qmd`. Change both, or the background won't fill the viewport.

Figure colors live inside `plots.R`, near the top of each function. They don't read the SCSS variables, so a palette change means editing both files.

The deck loads Source Serif 4 and Source Sans 3 from Google Fonts. `plot_fig_slide_15()` looks for Georgia and Helvetica on your machine and falls back to R's generic serif and sans faces if it can't find them. Expect small spacing differences between machines on that slide.

## Paper Citation

> Pulsipher AM, Khattar G, Harris E, White V, Stout C, Vikram HR, Patel R, Simner PJ. 2026. *Legionella* 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity. **J Clin Microbiol** 64:e00356-26. <https://doi.org/10.1128/jcm.00356-26>

## Disclaimer

The views and opinions expressed in this document are those of the author(s) and do not represent the official position, policy, or endorsement of the Department of Defense (also known as the Department of War), the United States Government, or any of their agencies or components, unless another official document expressly designates them as such.

## Author

John Paul Bisciotti
