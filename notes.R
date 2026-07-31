# notes.R -------------------------------------------------------------------
# Speaker-note plumbing for slides.qmd.
#
# Notes live in notes.md, keyed by a single-token heading (e.g. "# slide-01").
# This file parses that store once at source() time and exposes speaker_note(),
# which prints a reveal.js `.notes` div for the requested slide.
#
# Usage in slides.qmd:
#   source("notes.R")                     # in the setup chunk
#   speaker_note("slide-01")              # in an `#| output: asis` chunk
# ----------------------------------------------------------------------------

# Read notes.md into a named character vector: names are slide keys, values
# are the note bodies (each possibly spanning several paragraphs).
.parse_speaker_notes <- function(path = "notes.md") {
  if (!file.exists(path)) {
    cli::cli_abort("Speaker-note file {.file {path}} not found.")
  }

  lines <- readr::read_lines(path)

  # A key heading is an ATX heading whose text is a single whitespace-free
  # token, e.g. "# slide-01". Prose headings (which contain spaces) are ignored.
  key_pos <- which(stringr::str_detect(lines, "^#\\s+\\S+\\s*$"))
  if (length(key_pos) == 0L) {
    cli::cli_abort("No note headings (e.g. {.code # slide-01}) found in {.file {path}}.")
  }

  keys <- stringr::str_match(lines[key_pos], "^#\\s+(\\S+)")[, 2]
  ends <- c(key_pos[-1] - 1L, length(lines))

  bodies <- purrr::map2_chr(key_pos, ends, function(start, end) {
    if (end < start + 1L) {
      return("")
    }
    stringr::str_trim(paste(lines[seq(start + 1L, end)], collapse = "\n"))
  })

  if (any(duplicated(keys))) {
    dupes <- unique(keys[duplicated(keys)])
    cli::cli_abort("Duplicate note key{?s} in {.file {path}}: {.val {dupes}}.")
  }

  rlang::set_names(bodies, keys)
}

# Parsed once when this file is sourced.
.speaker_notes <- .parse_speaker_notes()

# Emit a reveal.js speaker-note div for `id`. Call from a chunk with
# `#| output: asis` so the fenced div reaches Pandoc as block-level markdown.
speaker_note <- function(id, notes = .speaker_notes) {
  if (!id %in% names(notes)) {
    cli::cli_abort(c(
      "No speaker note found for id {.val {id}}.",
      i = "Available id{?s}: {.val {names(notes)}}."
    ))
  }
  cat("\n::: {.notes}\n\n", notes[[id]], "\n\n:::\n\n", sep = "")
}

# The auto-generated title slide cannot take a `.notes` div (any content before
# the first `##` becomes its own blank slide in reveal.js). Instead we attach
# its note via reveal's `data-notes` attribute on #title-slide, injected with
# the same on-load script that places the sigmoid image. Keeping this in R lets
# the title note live in notes.md alongside every other note.
#
# IMPORTANT: call this from a chunk with `#| output: asis` that sits *inside* a
# real slide (e.g. the last one), never in the preamble before the first `##`,
# or the phantom-slide problem returns.
title_slide_decorations <- function(id,
                                     image = "sigmoid.png",
                                     notes = .speaker_notes) {
  if (!id %in% names(notes)) {
    cli::cli_abort(c(
      "No speaker note found for id {.val {id}}.",
      i = "Available id{?s}: {.val {names(notes)}}."
    ))
  }

  # encodeString() escapes quotes, backslashes, and newlines, yielding a valid
  # double-quoted JS string literal. (Avoid a literal "</script>" in the note.)
  note_js <- encodeString(notes[[id]], quote = "\"")

  cat(
    "\n<script>\n",
    "window.addEventListener(\"load\", function () {\n",
    "  const title = document.querySelector(\"#title-slide\");\n",
    "  if (!title) return;\n",
    "  const img = document.createElement(\"img\");\n",
    "  img.src = \"", image, "\";\n",
    "  img.className = \"sigmoid\";\n",
    "  title.appendChild(img);\n",
    "  title.setAttribute(\"data-notes\", ", note_js, ");\n",
    "});\n",
    "</script>\n\n",
    sep = ""
  )
}
