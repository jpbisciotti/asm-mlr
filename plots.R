# SLIDE 1 - sigmoid ============================================================

plot_fig_slide_01 <- function() {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_01() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  sigmoid_data <- data.frame(x = seq(-6, 6, length.out = 400))
  sigmoid_data$y <- stats::plogis(sigmoid_data$x)
  
  ggplot2::ggplot(sigmoid_data, ggplot2::aes(x, y)) +
    ggplot2::geom_hline(
      yintercept = c(0, 1),
      linetype = "dashed",
      colour = "#8fa8a0",
      linewidth = 0.5
    ) +
    ggplot2::geom_line(colour = "#b9cdec", linewidth = 3, lineend = "round") +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "transparent", colour = NA)
    )
}

# plot_fig_slide_01()

# SLIDE 2 - roadmap ============================================================

plot_fig_slide_02 <- function(n_panels = 4L) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "patchwork")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_02() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- argument guard ------------------------------------------------------
  if (!(length(n_panels) == 1L && n_panels %in% 1:4)) {
    stop("plot_fig_slide_02(): `n_panels` must be a single value in 1:4.", call. = FALSE)
  }
  
  teal   <- "#1d6a5a"
  orange <- "#df8f2d"
  grey   <- "#7a8590"
  ink    <- "#1b2a33"
  axis_g <- "#9aa3ac"
  
  # Shared minimal look: axis lines only, small grey caption underneath
  theme_panel <- function() {
    ggplot2::theme_void() +
      ggplot2::theme(
        axis.line = ggplot2::element_line(colour = axis_g, linewidth = 0.4),
        plot.caption = ggplot2::element_text(
          colour = "#5f6a72", size = 9, hjust = 0.5,
          margin = ggplot2::margin(t = 8)
        ),
        plot.margin = ggplot2::margin(4, 10, 4, 4)
      )
  }
  
  # 1 - an exact linear relationship
  exact <- data.frame(x = 1:7)
  exact$y <- 0.8 * exact$x + 1
  p1 <- ggplot2::ggplot(exact, ggplot2::aes(x, y)) +
    ggplot2::geom_line(colour = teal, linewidth = 1) +
    ggplot2::geom_point(colour = ink, size = 2) +
    ggplot2::labs(caption = "1 \u00b7 an exact linear relationship") +
    theme_panel()
  
  # 2 - uncertainty
  set.seed(42)
  noisy <- data.frame(x = stats::runif(35, 0, 10))
  noisy$y <- 0.6 * noisy$x + stats::rnorm(35, sd = 1.1)
  p2 <- ggplot2::ggplot(noisy, ggplot2::aes(x, y)) +
    ggplot2::geom_point(colour = grey, size = 1.6, alpha = 0.9) +
    ggplot2::geom_smooth(
      method = "lm", formula = y ~ x,
      se = FALSE, colour = teal, linewidth = 1
    ) +
    ggplot2::labs(caption = "2 \u00b7 uncertainty") +
    theme_panel()
  
  # 3 - a yes-or-no outcome
  set.seed(43)
  binary <- data.frame(x = stats::runif(30, -5, 5))
  binary$y <- stats::rbinom(30, 1, stats::plogis(1.3 * binary$x))
  curve_1 <- data.frame(x = seq(-5, 5, length.out = 200))
  curve_1$y <- stats::plogis(1.3 * curve_1$x)
  p3 <- ggplot2::ggplot() +
    ggplot2::geom_point(
      data = binary, ggplot2::aes(x, y),
      colour = grey, size = 1.6, alpha = 0.9
    ) +
    ggplot2::geom_line(data = curve_1, ggplot2::aes(x, y), colour = teal, linewidth = 1) +
    ggplot2::labs(caption = "3 \u00b7 a yes-or-no outcome") +
    theme_panel()
  
  # 4 - several predictors: two shifted sigmoids, points coloured by group
  set.seed(44)
  grp <- data.frame(
    x = stats::runif(40, -5, 6),
    g = rep(c("a", "b"), each = 20)
  )
  grp$y <- stats::rbinom(40, 1, stats::plogis(1.3 * (grp$x - ifelse(grp$g == "a", 0, 1.6))))
  curve_2 <- expand.grid(
    x = seq(-5, 6, length.out = 200),
    g = c("a", "b")
  )
  curve_2$y <- stats::plogis(1.3 * (curve_2$x - ifelse(curve_2$g == "a", 0, 1.6)))
  p4 <- ggplot2::ggplot() +
    ggplot2::geom_point(
      data = grp, ggplot2::aes(x, y, colour = g),
      size = 1.6, alpha = 0.9
    ) +
    ggplot2::geom_line(
      data = curve_2, ggplot2::aes(x, y, colour = g),
      linewidth = 1
    ) +
    ggplot2::scale_colour_manual(values = c(a = orange, b = teal), guide = "none") +
    ggplot2::labs(caption = "4 \u00b7 several predictors") +
    theme_panel()
  
  # ---- assemble on a fixed 4-column grid -----------------------------------
  # Slots beyond n_panels are blank spacers so every visible panel keeps its
  # 1/4-width position across the reveal sequence.
  panels <- list(p1, p2, p3, p4)
  slots  <- lapply(seq_len(4L), function(i) {
    if (i <= n_panels) panels[[i]] else patchwork::plot_spacer()
  })
  
  patchwork::wrap_plots(slots, nrow = 1)
}

# plot_fig_slide_02()

# SLIDE 3 - water ==============================================================

plot_fig_slide_03 <- function(stage = 3) {
  
  # plot_fig_slide_03() -----------------------------------------------------
  # Three-states-of-water infographic (freezes / tepid / boils), with
  # progressive reveal for a build-style presentation.
  #
  #   stage = 1  ->  tepid beaker only (shown at its usual centre position)
  #   stage = 2  ->  freeze + tepid beakers
  #   stage = 3  ->  freeze + tepid + boil beakers (full figure)
  #
  # The plot's coordinate frame (coord_equal xlim/ylim) is fixed regardless
  # of `stage`, so beakers never shift position across the build — only
  # revealed beakers, and their contents/labels, are drawn. Anything not
  # yet revealed is fully omitted (nothing drawn, no placeholder outline).
  #
  # Self-contained: attaches no packages. Every external call is namespaced
  # with `::`, and a base-only guard fails early with a clear message if a
  # required package is missing. Returns a ggplot object; the caller renders.
  
  # ---- validate stage ------------------------------------------------------
  if (!(length(stage) == 1L && stage %in% c(1, 2, 3))) {
    stop("plot_fig_slide_03(): `stage` must be one of 1, 2, or 3.", call. = FALSE)
  }
  
  visible <- switch(
    as.character(stage),
    "1" = "tepid",
    "2" = c("freeze", "tepid"),
    "3" = c("freeze", "tepid", "boil")
  )
  
  # ---- dependency guard (base tools only, before any pkg is used) --------
  .pkgs <- c("ggplot2", "ggforce", "dplyr", "tibble")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_03() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- palette -----------------------------------------------------------
  bg_grey     <- "#ECECEC"
  navy        <- "#1C2A55"   # thick beaker walls
  water_pale  <- "#B7D2E4"   # freezing  (pale, desaturated)
  water_mid   <- "#4FA3D6"   # tepid     (medium sky blue)
  water_hot   <- "#1E7FD1"   # boiling   (brighter, saturated)
  ice_fill    <- "#FFFFFF"
  ice_line    <- "#C7D6E2"
  bubble_fill <- "#FFFFFF"
  steam_grey  <- "#9AA1A9"
  label_col   <- "#1C2A55"
  temp_col    <- "#5A6472"
  
  # ---- geometry ----------------------------------------------------------
  # each beaker: interior from y = 0 (bottom) to y = top; half-width = hw
  top    <- 4
  hw     <- 1.15
  wall   <- 3.4            # wall linewidth (mm)
  inset  <- 0.06           # keep water just inside the wall centreline
  centres <- c(freeze = 2, tepid = 5.5, boil = 9)
  
  # beaker wall = open-topped U path (down left, across bottom, up right)
  beaker_path <- function(cx) {
    tibble::tibble(
      x = c(cx - hw, cx - hw, cx + hw, cx + hw),
      y = c(top,      0,       0,       top)
    )
  }
  walls <- dplyr::bind_rows(lapply(names(centres), function(n) {
    beaker_path(centres[[n]]) |> dplyr::mutate(grp = n)
  })) |>
    dplyr::filter(grp %in% visible)
  
  # rectangular water body up to fill height
  water_rect <- function(cx, fill_h) {
    tibble::tibble(
      xmin = cx - hw + inset, xmax = cx + hw - inset,
      ymin = inset,           ymax = fill_h
    )
  }
  water <- dplyr::bind_rows(
    water_rect(centres[["freeze"]], 2.85)      |> dplyr::mutate(fill = water_pale, name = "freeze"),
    water_rect(centres[["tepid"]],  top * 2/3) |> dplyr::mutate(fill = water_mid,  name = "tepid"),
    water_rect(centres[["boil"]],   2.95)      |> dplyr::mutate(fill = water_hot,  name = "boil")
  ) |>
    dplyr::filter(name %in% visible)
  
  # ---- ice cubes (5 rounded white squares, clustered low) ----------------
  # only relevant to the freezing beaker
  ice_layer <- NULL
  if ("freeze" %in% visible) {
    set.seed(1)
    cx <- centres[["freeze"]]
    ice <- tibble::tribble(
      ~x0,        ~y0,   ~s,
      cx - 0.55,  0.55,  0.46,
      cx + 0.05,  0.50,  0.50,
      cx + 0.58,  0.70,  0.42,
      cx - 0.28,  1.15,  0.48,
      cx + 0.38,  1.28,  0.44
    ) |>
      dplyr::mutate(
        xmin = x0 - s/2, xmax = x0 + s/2,
        ymin = y0 - s/2, ymax = y0 + s/2
      )
    
    ice_layer <- ggforce::geom_shape(
      data = do.call(rbind, lapply(seq_len(nrow(ice)), function(i) {
        r <- ice[i, ]
        tibble::tibble(
          x = c(r$xmin, r$xmax, r$xmax, r$xmin),
          y = c(r$ymin, r$ymin, r$ymax, r$ymax),
          grp = i
        )
      })),
      ggplot2::aes(x = x, y = y, group = grp),
      radius = grid::unit(2.2, "mm"),
      fill = ice_fill, colour = ice_line, linewidth = 0.4
    )
  }
  
  # ---- bubbles (white circles, varying sizes) ----------------------------
  # only relevant to the boiling beaker
  bubble_layer <- NULL
  steam_layer  <- NULL
  if ("boil" %in% visible) {
    bx <- centres[["boil"]]
    bubbles <- tibble::tribble(
      ~x,          ~y,    ~r,
      bx - 0.55,   0.55,  0.20,
      bx + 0.45,   0.70,  0.15,
      bx - 0.10,   1.05,  0.24,
      bx + 0.60,   1.35,  0.12,
      bx - 0.60,   1.55,  0.13,
      bx + 0.15,   1.75,  0.19,
      bx - 0.30,   2.15,  0.11,
      bx + 0.50,   2.30,  0.16,
      bx + 0.00,   2.55,  0.10
    ) |> dplyr::mutate(x0 = x, y0 = y)
    
    bubble_layer <- ggforce::geom_circle(
      data = bubbles,
      ggplot2::aes(x0 = x0, y0 = y0, r = r),
      fill = bubble_fill, colour = NA
    )
    
    # ---- steam (3 grey wavy vertical lines above the boiling beaker) ----
    steam_line <- function(x_base, phase, id) {
      t <- seq(0, 1, length.out = 60)
      tibble::tibble(
        y = top + 0.35 + t * 2.0,
        x = x_base + 0.18 * sin(2 * pi * 1.6 * t + phase),
        grp = paste0(id)
      )
    }
    steam <- dplyr::bind_rows(
      steam_line(bx - 0.55, 0.0,    "s1"),
      steam_line(bx + 0.00, pi / 2, "s2"),
      steam_line(bx + 0.55, pi,     "s3")
    )
    
    steam_layer <- ggplot2::geom_path(
      data = steam,
      ggplot2::aes(x = x, y = y, group = grp),
      colour = steam_grey, linewidth = 1.6,
      lineend = "round", alpha = 0.85
    )
  }
  
  # ---- labels ------------------------------------------------------------
  labels <- tibble::tribble(
    ~name,     ~x,                  ~label,    ~temp,
    "freeze",  centres[["freeze"]], "freezes", "0 \u00b0C / 32 \u00b0F",
    "tepid",   centres[["tepid"]],  "tepid",   "room temp",
    "boil",    centres[["boil"]],   "boils",   "100 \u00b0C / 212 \u00b0F"
  ) |>
    dplyr::filter(name %in% visible)
  
  # ---- plot --------------------------------------------------------------
  # NOTE: coord_equal() xlim/ylim are fixed at the full three-beaker extent
  # for every stage, so beakers stay in the same on-screen position as more
  # are revealed across the build.
  ggplot2::ggplot() +
    # water bodies
    ggplot2::geom_rect(
      data = water,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = water$fill
    ) +
    # ice cubes (rounded white squares) — freeze stage only
    ice_layer +
    # bubbles — boil stage only
    bubble_layer +
    # steam — boil stage only
    steam_layer +
    # beaker walls (open top)
    ggplot2::geom_path(
      data = walls,
      ggplot2::aes(x = x, y = y, group = grp),
      colour = navy, linewidth = wall,
      lineend = "round", linejoin = "mitre"
    ) +
    # labels + temps
    ggplot2::geom_text(
      data = labels, ggplot2::aes(x = x, y = -0.75, label = label),
      fontface = "bold", size = 7, colour = label_col
    ) +
    ggplot2::geom_text(
      data = labels, ggplot2::aes(x = x, y = -1.45, label = temp),
      size = 4.6, colour = temp_col
    ) +
    ggplot2::coord_equal(xlim = c(0.3, 10.7), ylim = c(-2.1, 6.7), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = bg_grey, colour = NA),
      panel.background = ggplot2::element_rect(fill = bg_grey, colour = NA),
      plot.margin      = ggplot2::margin(10, 10, 10, 10)
    )
}

# plot_fig_slide_03()

# SLIDE 4 - temperature ========================================================

plot_fig_slide_04 <- function(stage = 4L) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_04() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage validation ---------------------------------------------------
  # Any stage outside 1:4 (including non-integers) falls back to the full
  # plot (stage 4).
  if (!is.numeric(stage) || length(stage) != 1L || !(stage %in% 1:4)) {
    stage <- 4L
  }
  
  conversion <- tibble::tibble(
    celsius    = c(0, 20, 40, 60, 80, 100),
    fahrenheit = c(32, 68, 104, 140, 176, 212)
  )
  
  teal       <- "#1B9E9E"
  grey_arrow <- "grey60"
  
  # Arrow endpoints chosen so the slope equals the line's slope (1.8 F per C),
  # which guarantees the arrow is parallel to the line on screen.
  arrow_x    <- 62
  arrow_xend <- 80
  arrow_y    <- 178
  arrow_yend <- arrow_y + 1.8 * (arrow_xend - arrow_x)   # = 210.4
  
  p <- ggplot2::ggplot(conversion, ggplot2::aes(x = celsius, y = fahrenheit)) +
    ggplot2::geom_line(colour = teal, linewidth = 1) +
    ggplot2::scale_x_continuous(
      breaks = c(0, 20, 40, 60, 80, 100),
      limits = c(0, 100)
    ) +
    ggplot2::scale_y_continuous(breaks = c(32, 100, 150, 212)) +
    ggplot2::labs(
      x = if (stage >= 2) "Celsius (predictor)" else " ",
      y = if (stage >= 3) "Fahrenheit (outcome)" else " "
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      panel.grid = ggplot2::element_blank(),
      axis.line  = ggplot2::element_line(colour = "grey30"),
      axis.ticks = ggplot2::element_line(colour = "grey30")
    )
  
  if (stage >= 4) {
    p <- p +
      ggplot2::geom_point(colour = "black", size = 2.5) +
      ggplot2::annotate(
        "segment",
        x = arrow_x, xend = arrow_xend, y = arrow_y, yend = arrow_yend,
        colour = grey_arrow, linewidth = 1,
        arrow = grid::arrow(length = grid::unit(0.25, "cm"), type = "closed")
      ) +
      ggplot2::annotate(
        "text",
        x = 8, y = 192,
        label = "as Celsius rises,\nFahrenheit rises",
        colour = grey_arrow, hjust = 0, vjust = 1, size = 5, lineheight = 0.95
      )
  }
  
  p
}

# plot_fig_slide_04()

# SLIDE 5 ======================================================================

plot_fig_slide_05 <- function(stage = 4) {
  
  # plot_fig_slide_05() -------------------------------------------------
  # Two seesaw-style balance scales side by side, joined by the italic teal
  # word "tend". Each scale carries a teal stick figure on the left pan and
  # a navy weight block on the right pan, with the beam balanced (arms flat
  # and level); the left scale is
  # the small figure / "50 lb" pairing, the right the large figure / "150 lb"
  # pairing. Self-contained: attaches no packages, every external call is
  # namespaced with `::`, and a base-only guard fails early if a package is
  # missing. Returns a ggplot object; the caller renders.
  #
  # `stage` controls progressive reveal for the presentation build:
  #   1 - the two scales only; no stick figures, no weights, no "tend"
  #   2 - adds the left stick figure and weight on the left scale
  #   3 - adds the right stick figure and weight on the right scale
  #   4 - adds the "tend" text between the two scales (full plot)
  # Any value outside 1:4 (including non-integer input) falls back to the
  # full plot (stage 4).
  
  # ---- dependency guard (base tools only, before any pkg is used) --------
  .pkgs <- c("ggplot2", "ggforce", "dplyr", "tibble")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_05() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage validation ---------------------------------------------------
  stage <- if (isTRUE(stage %in% 1:4)) as.integer(stage) else 4L
  
  # which scale ids have their figure + weight revealed at this stage
  ids_to_show <- character(0)
  if (stage >= 2) ids_to_show <- c(ids_to_show, "left")
  if (stage >= 3) ids_to_show <- c(ids_to_show, "right")
  
  # ---- palette -----------------------------------------------------------
  teal       <- "#1B9E8C"   # figures and the word "tend"
  navy       <- "#1C2A55"   # beam, base, weight block, platforms
  grey_fulc  <- "#98A0AB"   # fulcrum triangle
  white      <- "#FFFFFF"   # weight label text
  bg_white   <- "#FFFFFF"
  
  # ---- fixed geometry (shared by both scales) ----------------------------
  base_hw_bot <- 0.90       # base trapezoid half-widths
  base_hw_top <- 0.50
  base_h      <- 0.35
  fulc_hw     <- 0.50       # fulcrum triangle half-width at its foot
  pivot_y     <- 2.20       # fulcrum apex / beam pivot height
  beam_hw     <- 1.60       # beam half-length
  beam_dy     <- 0.00       # 0 = balanced; both beam ends level (flat arms)
  support_h   <- 0.50       # height of triangular support under a pan
  pan_hw      <- 0.62       # platform half-width
  plank_h     <- 0.12       # platform plank thickness
  blk_hw      <- 0.45       # weight-block half-width
  blk_h       <- 0.72       # weight-block height
  
  # per-scale specification (only figure size and label differ)
  specs <- tibble::tibble(
    id     = c("left", "right"),
    cx     = c(3.0, 9.0),
    fig_h  = c(1.40, 2.10),
    fig_lw = c(2.4, 3.2),
    label  = c("50 lb", "150 lb")
  )
  
  # ---- geometry builders -------------------------------------------------
  # beam-end coordinates for a scale centred at cx (left end sits lower)
  beam_ends <- function(cx) {
    list(
      left  = c(x = cx - beam_hw, y = pivot_y - beam_dy),
      right = c(x = cx + beam_hw, y = pivot_y + beam_dy)
    )
  }
  # top surface of a pan sitting above a beam end
  pan_top_y <- function(end_y) end_y + support_h + plank_h
  
  base_poly <- function(cx) {
    tibble::tibble(
      x = c(cx - base_hw_bot, cx + base_hw_bot, cx + base_hw_top, cx - base_hw_top),
      y = c(0, 0, base_h, base_h)
    )
  }
  fulcrum_poly <- function(cx) {
    tibble::tibble(
      x = c(cx - fulc_hw, cx + fulc_hw, cx),
      y = c(base_h, base_h, pivot_y)
    )
  }
  # two triangular support lines + the plank rectangle for one pan
  supports_seg <- function(ex, ey) {
    tibble::tibble(
      x    = c(ex, ex),
      y    = c(ey, ey),
      xend = c(ex - pan_hw, ex + pan_hw),
      yend = c(ey + support_h, ey + support_h)
    )
  }
  plank_rect <- function(ex, ey) {
    tibble::tibble(
      xmin = ex - pan_hw, xmax = ex + pan_hw,
      ymin = ey + support_h, ymax = ey + support_h + plank_h
    )
  }
  
  # teal stick figure standing with feet at (cx, y_feet), total height h
  stick_figure <- function(cx, y_feet, h, lw, id) {
    y_crotch <- y_feet + 0.38 * h
    y_shldr  <- y_feet + 0.70 * h
    r_head   <- 0.13 * h
    y_head   <- y_shldr + r_head + 0.03 * h
    segs <- tibble::tibble(
      x    = c(cx,       cx,               cx,               cx,                    cx),
      y    = c(y_crotch, y_crotch,         y_crotch,         y_shldr - 0.02 * h,    y_shldr - 0.02 * h),
      xend = c(cx,       cx - 0.16 * h,    cx + 0.16 * h,    cx - 0.22 * h,         cx + 0.22 * h),
      yend = c(y_shldr,  y_feet,           y_feet,           y_shldr - 0.20 * h,    y_shldr - 0.20 * h),
      lw   = lw,
      id   = id
    )
    head <- tibble::tibble(x0 = cx, y0 = y_head, r = r_head, id = id)
    list(segs = segs, head = head)
  }
  
  # rounded weight block (as a 4-corner polygon for ggforce::geom_shape)
  block_poly <- function(cx, y_bot, id) {
    tibble::tibble(
      x   = c(cx - blk_hw, cx + blk_hw, cx + blk_hw, cx - blk_hw),
      y   = c(y_bot, y_bot, y_bot + blk_h, y_bot + blk_h),
      grp = id
    )
  }
  
  # ---- assemble geometry across both scales ------------------------------
  rows <- split(specs, seq_len(nrow(specs)))
  
  bases      <- dplyr::bind_rows(lapply(rows, function(s) base_poly(s$cx)    |> dplyr::mutate(grp = s$id)))
  fulcrums   <- dplyr::bind_rows(lapply(rows, function(s) fulcrum_poly(s$cx) |> dplyr::mutate(grp = s$id)))
  
  beams <- dplyr::bind_rows(lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    tibble::tibble(x = e$left["x"], y = e$left["y"], xend = e$right["x"], yend = e$right["y"], grp = s$id)
  }))
  
  supports <- dplyr::bind_rows(lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    dplyr::bind_rows(
      supports_seg(e$left["x"],  e$left["y"]),
      supports_seg(e$right["x"], e$right["y"])
    )
  }))
  
  planks <- dplyr::bind_rows(lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    dplyr::bind_rows(
      plank_rect(e$left["x"],  e$left["y"]),
      plank_rect(e$right["x"], e$right["y"])
    )
  }))
  
  # small navy pivot cap where beam meets fulcrum
  pivots <- dplyr::bind_rows(lapply(rows, function(s) {
    tibble::tibble(x0 = s$cx, y0 = pivot_y, r = 0.10, id = s$id)
  }))
  
  figs <- lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    stick_figure(e$left["x"], pan_top_y(e$left["y"]), s$fig_h, s$fig_lw, s$id)
  })
  fig_segs  <- dplyr::bind_rows(lapply(figs, `[[`, "segs"))
  fig_heads <- dplyr::bind_rows(lapply(figs, `[[`, "head"))
  
  blocks <- dplyr::bind_rows(lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    block_poly(s$cx + beam_hw, pan_top_y(e$right["y"]), s$id)
  }))
  block_labs <- dplyr::bind_rows(lapply(rows, function(s) {
    e <- beam_ends(s$cx)
    tibble::tibble(
      x     = s$cx + beam_hw,
      y     = pan_top_y(e$right["y"]) + blk_h / 2,
      label = s$label,
      id    = s$id
    )
  }))
  
  # ---- apply progressive-reveal filtering --------------------------------
  fig_segs   <- dplyr::filter(fig_segs,   id  %in% ids_to_show)
  fig_heads  <- dplyr::filter(fig_heads,  id  %in% ids_to_show)
  blocks     <- dplyr::filter(blocks,     grp %in% ids_to_show)
  block_labs <- dplyr::filter(block_labs, id  %in% ids_to_show)
  
  tend_layer <- if (stage >= 4) {
    ggplot2::annotate(
      "text", x = 6, y = 2.55, label = "tend",
      fontface = "italic", colour = teal, size = 12
    )
  } else {
    NULL
  }
  
  # ---- plot --------------------------------------------------------------
  ggplot2::ggplot() +
    # base + fulcrum
    ggplot2::geom_polygon(
      data = bases,
      ggplot2::aes(x = x, y = y, group = grp),
      fill = navy, colour = NA
    ) +
    ggplot2::geom_polygon(
      data = fulcrums,
      ggplot2::aes(x = x, y = y, group = grp),
      fill = grey_fulc, colour = NA
    ) +
    # triangular pan supports
    ggplot2::geom_segment(
      data = supports,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
      colour = navy, linewidth = 1.1, lineend = "round"
    ) +
    # platform planks
    ggplot2::geom_rect(
      data = planks,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = navy, colour = NA
    ) +
    # beam (flat / balanced)
    ggplot2::geom_segment(
      data = beams,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = grp),
      colour = navy, linewidth = 3.6, lineend = "round"
    ) +
    # pivot cap
    ggforce::geom_circle(
      data = pivots,
      ggplot2::aes(x0 = x0, y0 = y0, r = r),
      fill = navy, colour = NA
    ) +
    # weight blocks (rounded) + labels
    ggforce::geom_shape(
      data = blocks,
      ggplot2::aes(x = x, y = y, group = grp),
      radius = grid::unit(2, "mm"),
      fill = navy, colour = NA
    ) +
    ggplot2::geom_text(
      data = block_labs,
      ggplot2::aes(x = x, y = y, label = label),
      colour = white, fontface = "bold", size = 4.4
    ) +
    # stick figures (teal)
    ggplot2::geom_segment(
      data = fig_segs,
      ggplot2::aes(x = x, y = y, xend = xend, yend = yend, group = id, linewidth = lw),
      colour = teal, lineend = "round"
    ) +
    ggplot2::scale_linewidth_identity() +
    ggforce::geom_circle(
      data = fig_heads,
      ggplot2::aes(x0 = x0, y0 = y0, r = r, group = id),
      fill = teal, colour = NA
    ) +
    # the connecting word
    tend_layer +
    ggplot2::coord_equal(xlim = c(0.4, 11.6), ylim = c(-0.3, 5.0), expand = FALSE) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = bg_white, colour = NA),
      panel.background = ggplot2::element_rect(fill = bg_white, colour = NA),
      plot.margin      = ggplot2::margin(10, 10, 10, 10)
    )
}

# SLIDE 6 - height weight ======================================================

plot_fig_slide_06 <- function(stage = 6) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble", "dplyr")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_06() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage validation ---------------------------------------------------
  # Anything that isn't a single value in 1:6 falls back to the full plot.
  if (!is.numeric(stage) || length(stage) != 1L || !stage %in% 1:6) {
    stage <- 6
  }
  
  set.seed(123)
  
  # Simulate ~60 points: weight ~ -120 + 1.12 * height + noise
  sim <- tibble::tibble(
    height = stats::runif(60, min = 150, max = 196)
  ) |>
    dplyr::mutate(
      weight = -120 + 1.12 * height + stats::rnorm(dplyr::n(), mean = 0, sd = 6)
    )
  
  # Fit the same lm that geom_smooth() would draw, so residual segments and
  # the confidence band land exactly on the line
  model <- stats::lm(weight ~ height, data = sim)
  sim <- sim |>
    dplyr::mutate(fitted = stats::predict(model))
  
  # Fitted line + 95% confidence band, computed by hand (rather than via
  # geom_smooth) so the line and the band can be revealed on separate stages
  smooth_line <- tibble::tibble(
    height = seq(min(sim$height), max(sim$height), length.out = 100)
  )
  smooth_pred <- stats::predict(model, newdata = smooth_line, interval = "confidence")
  smooth_line <- smooth_line |>
    dplyr::mutate(
      fit = smooth_pred[, "fit"],
      lwr = smooth_pred[, "lwr"],
      upr = smooth_pred[, "upr"]
    )
  
  # Pick a few illustrative points: the largest residual within each of three
  # height bins (low / mid / high), kept clear of the beta-hat annotation
  resid_examples <- sim |>
    dplyr::mutate(
      resid = weight - fitted,
      bin = cut(height, breaks = c(150, 168, 178, 185))
    ) |>
    dplyr::filter(!is.na(bin)) |>
    dplyr::slice_max(abs(resid), n = 1, by = bin)
  
  p <- ggplot2::ggplot(sim, ggplot2::aes(x = height, y = weight))
  
  # ---- stage 6: confidence band (added first, so the line sits on top) ----
  if (stage >= 6) {
    p <- p +
      ggplot2::geom_ribbon(
        data = smooth_line,
        ggplot2::aes(x = height, ymin = lwr, ymax = upr),
        inherit.aes = FALSE,
        fill = "#CFE0DB",   # pale teal confidence band
        alpha = 0.6,
        colour = NA
      )
  }
  
  # ---- stage 4: the fitted line -------------------------------------------
  if (stage >= 4) {
    p <- p +
      ggplot2::geom_line(
        data = smooth_line,
        ggplot2::aes(x = height, y = fit),
        inherit.aes = FALSE,
        color = "#2E6E5E",  # dark teal line
        linewidth = 1.1
      )
  }
  
  # ---- stage 1: the points (always present) -------------------------------
  p <- p +
    ggplot2::geom_point(
      color = "#5B7B9A",   # grey-blue dots
      alpha = 0.55,
      size = 2.6
    )
  
  # ---- stage 5: residual segments + "residuals" label ----------------------
  if (stage >= 5) {
    p <- p +
      ggplot2::geom_segment(
        data = resid_examples,
        ggplot2::aes(x = height, xend = height, y = weight, yend = fitted),
        color = "#A6321E",
        linetype = "dashed",
        linewidth = 0.7
      ) +
      ggplot2::annotate(
        "text",
        x = 159, y = 80,
        label = "residuals",
        color = "#A6321E",
        size = 5,
        hjust = 0
      )
  }
  
  # ---- stage 6: beta-hat label + arrow pointing to the line ----------------
  if (stage >= 6) {
    p <- p +
      ggplot2::annotate(
        "text",
        x = 178, y = 103,
        label = "hat(beta) * ' (estimated slope)'",
        parse = TRUE,
        color = "#2E6E5E",
        size = 5,
        hjust = 0
      ) +
      ggplot2::annotate(
        "segment",
        x = 184, y = 100, xend = 187.5, yend = 94,
        color = "#2E6E5E",
        linewidth = 0.9,
        arrow = grid::arrow(length = grid::unit(0.25, "cm"), type = "closed")
      )
  }
  
  p +
    ggplot2::scale_x_continuous(
      breaks = seq(150, 200, by = 10),
      limits = c(148, 200)
    ) +
    ggplot2::scale_y_continuous(
      breaks = seq(40, 110, by = 10),
      limits = c(40, 110)
    ) +
    ggplot2::labs(
      x = if (stage >= 2) "Height (predictor)" else " ",
      y = if (stage >= 3) "Weight (outcome)" else " "
    ) +
    ggplot2::theme_classic(base_size = 14) +
    ggplot2::theme(
      axis.title = ggplot2::element_text(size = 15),
      axis.line  = ggplot2::element_line(color = "grey30"),
      axis.ticks = ggplot2::element_line(color = "grey30")
    )
}

# plot_fig_slide_06()

# SLIDE 7 - death status linear regression =====================================

plot_fig_slide_07 <- function(stage = 7) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble", "dplyr")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_07() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage validation ---------------------------------------------------
  # Valid stages are the integers 1-7. Anything else (out of range, NA,
  # non-numeric, non-scalar) falls back to stage 7, the full plot.
  #   1. x/y axes with ticks and numbers; points; dashed reference lines
  #   2. + x axis label "Age (predictor)"
  #   3. + y axis label "0 = survived"; y axis title "Death"
  #   4. + y axis label "1 = died"
  #   5. + blue OLS fit line
  #   6. + "impossible: above 1" label and red shading above 1
  #   7. + "impossible: below 0" label and red shading below 0 (full plot)
  if (!isTRUE(stage %in% 1:7)) {
    stage <- 7L
  }
  stage <- as.integer(stage)
  
  # --- Simulated data -------------------------------------------------------
  
  set.seed(123)
  survived <- tibble::tibble(
    age   = pmin(pmax(stats::rnorm(60, mean = 42, sd = 12), 20), 70),
    death = 0
  )
  
  set.seed(123)
  died <- tibble::tibble(
    age   = pmin(pmax(stats::rnorm(40, mean = 68, sd = 10), 47), 90),
    death = 1
  )
  deaths <- dplyr::bind_rows(survived, died)
  
  # --- Fixed y-axis limits ---------------------------------------------------
  # Hardcoded so every stage (1-7) shares the same y-range that stages 5-7
  # produce naturally once the fullrange OLS fit line is added (the fit line
  # extends well past 0/1 at the x-axis extremes, which is what widens the
  # y-scale from stage 5 onward). Values are the OLS-predicted death at
  # x = -5 and x = 120 (matching the scale_x_continuous limits below),
  # computed once from this fixed simulated dataset:
  #   lm(death ~ age, data = deaths) predicted at age = c(-5, 120)
  #   -> c(-0.9803804, 1.9910340)
  y_limits <- c(-0.9803804, 1.9910340)
  
  # --- Stage-dependent elements ----------------------------------------------
  
  # y-axis tick labels build up from plain numbers to descriptive labels
  y_tick_labels <- if (stage >= 4) {
    c("0 = survived", "1 = died")
  } else if (stage == 3) {
    c("0 = survived", "                   ")
  } else {
    c("                   ", "                   ")
  }
  
  x_axis_title <- if (stage >= 2) "Age (predictor)" else " "
  y_axis_title <- if (stage >= 3) "Death" else " "
  
  fit_layer <- if (stage >= 5) {
    ggplot2::geom_smooth(
      method    = "lm",
      formula   = y ~ x,
      se        = FALSE,
      fullrange = TRUE,
      colour    = "#2C7FB8",
      linewidth = 1
    )
  } else {
    NULL
  }
  
  above_one_layer <- if (stage >= 6) {
    list(
      ggplot2::annotate(
        "rect",
        xmin = -Inf, xmax = Inf, ymin = 1, ymax = Inf,
        fill = "firebrick", alpha = 0.10
      ),
      ggplot2::annotate(
        "text",
        x = -Inf, y = Inf, hjust = -0.15, vjust = 1.4,
        label = "impossible:\n above 1",
        colour = "firebrick", size = 5, lineheight = 0.9
      )
    )
  } else {
    NULL
  }
  
  below_zero_layer <- if (stage >= 7) {
    list(
      ggplot2::annotate(
        "rect",
        xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = 0,
        fill = "firebrick", alpha = 0.10
      ),
      ggplot2::annotate(
        "text",
        x = Inf, y = -Inf, hjust = 1.15, vjust = -0.6,
        label = "impossible:\nbelow 0 ",
        colour = "firebrick", size = 5, lineheight = 0.9
      )
    )
  } else {
    NULL
  }
  
  # --- Plot -----------------------------------------------------------------
  
  ggplot2::ggplot(deaths, ggplot2::aes(x = age, y = death)) +
    # impossible regions: above 1 (stage >= 6), below 0 (stage >= 7) --------
  above_one_layer +
    below_zero_layer +
    # reference lines, points (always present from stage 1) ----------------
  ggplot2::geom_hline(
    yintercept = c(0, 1),
    linetype   = "dashed",
    colour     = "grey60"
  ) +
    ggplot2::geom_jitter(
      width  = 1.5,
      height = 0,
      colour = "grey50",
      size   = 2,
      alpha  = 0.7
    ) +
    # OLS fit (stage >= 5) ---------------------------------------------------
  fit_layer +
    ggplot2::scale_x_continuous(
      breaks = seq(0, 120, by = 20),
      limits = c(-5, 120)
    ) +
    ggplot2::scale_y_continuous(
      breaks = c(0, 1),
      labels = y_tick_labels,
      limits = y_limits
    ) +
    ggplot2::labs(
      x = x_axis_title,
      y = y_axis_title
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank())
}

# plot_fig_slide_07()

# SLIDE 8 - ten people =========================================================

plot_fig_slide_08 <- function(stage = 3) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble", "dplyr", "tidyr")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_08() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage guard: any value outside 1:3 falls back to the full plot ----
  if (!stage %in% 1:3) stage <- 3
  
  # rows visible at each stage (row_y = 3 top / 2 middle / 1 bottom)
  rows_visible <- switch(
    stage,
    3,              # stage 1: top row only (+ number line, always drawn)
    c(3, 2),        # stage 2: top + middle row
    c(3, 2, 1)      # stage 3: top + middle + bottom row (full plot)
  )
  
  # ---- palette -------------------------------------------------------------
  col_red  <- "#B0392B"   # died
  col_gray <- "#C9CDD2"   # survived
  col_teal <- "#158F8B"   # the anchor annotation
  col_note <- "grey55"    # other annotations
  col_ink  <- "grey25"    # labels / arrow
  
  # ---- one reusable person silhouette (head circle + rounded-shoulder body) --
  person_template <- tibble::tibble(
    part = c(rep("body", 13), rep("head", 40)),
    px = c(
      -0.30, -0.30, -0.29, -0.25, -0.18, -0.09,  0.00,  0.09,  0.18,  0.25,  0.29,  0.30,  0.30,
      0.17 * cos(seq(0, 2 * pi, length.out = 40))
    ),
    py = c(
      0.00,  0.34,  0.42,  0.49,  0.55,  0.585, 0.60,  0.585, 0.55,  0.49,  0.42,  0.34,  0.00,
      0.80 + 0.17 * sin(seq(0, 2 * pi, length.out = 40))
    )
  )
  
  # ---- icon grid: 3 rows x 10 icons ----------------------------------------
  rows <- tibble::tibble(
    row_y = c(3, 2, 1),
    n_red = c(5, 8, 2)           # number of "died" icons per row
  )
  
  icons <- rows |>
    dplyr::mutate(x = list(1:10)) |>
    tidyr::unnest(x) |>
    dplyr::mutate(
      icon_id = dplyr::row_number(),
      fill    = dplyr::if_else(x <= n_red, col_red, col_gray)
    ) |>
    dplyr::filter(row_y %in% rows_visible)  # <- stage filter
  
  # ---- stamp the template at every icon position ---------------------------
  scale_person <- 0.78            # uniform scale (uniform => round heads)
  centre_y     <- 0.485           # vertical centre of the template
  
  people <- icons |>
    dplyr::cross_join(person_template) |>
    dplyr::mutate(
      gx  = x + px * scale_person,
      gy  = row_y + (py - centre_y) * scale_person,
      grp = paste(icon_id, part)
    )
  
  # ---- row labels + annotations --------------------------------------------
  labels <- tibble::tibble(
    row_y = c(3, 2, 1),
    label = c(
      "odds of death = 5 : 5 = 1",
      "odds of death = 8 : 2 = 4",
      "odds of survival = 2 : 8 = 0.25"
    ),
    note = c(
      "the anchor: no difference",
      "above the anchor",
      "below the anchor"
    ),
    note_col = c(col_teal, col_note, col_note)
  ) |>
    dplyr::filter(row_y %in% rows_visible)  # <- stage filter
  
  # ---- bottom scale arrow (always shown, from stage 1 onward) --------------
  x_left  <- 1
  x_right <- 10
  
  # ---- plot ----------------------------------------------------------------
  ggplot2::ggplot() +
    # people
    ggplot2::geom_polygon(
      data = people,
      ggplot2::aes(x = gx, y = gy, group = grp, fill = fill),
      colour = NA
    ) +
    # row labels
    ggplot2::geom_text(
      data = labels,
      ggplot2::aes(x = 11, y = row_y, label = label),
      hjust = 0, size = 4.6, colour = col_ink
    ) +
    # italic annotations under each label
    ggplot2::geom_text(
      data = labels,
      ggplot2::aes(x = 11, y = row_y - 0.33, label = note, colour = note_col),
      hjust = 0, size = 3.8, fontface = "italic"
    ) +
    # 0 -> infinity arrow
    ggplot2::geom_segment(
      ggplot2::aes(x = x_left, xend = x_right, y = 0, yend = 0),
      linewidth = 0.7, colour = col_ink,
      arrow = grid::arrow(length = grid::unit(0.18, "cm"), type = "closed")
    ) +
    ggplot2::annotate("text", x = x_left - 0.5,  y = 0, label = "0",
                      size = 4.6, colour = col_ink, hjust = 1) +
    ggplot2::annotate("text", x = x_right + 0.5, y = 0, label = "\u221E",
                      size = 5.5, colour = col_ink, hjust = 0) +
    ggplot2::annotate("text", x = (x_left + x_right) / 2, y = -0.45,
                      label = "odds: 0 \u2192 \u221E (no ceiling)",
                      size = 3.8, colour = col_note, fontface = "italic") +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_colour_identity() +
    ggplot2::coord_fixed(ratio = 1, xlim = c(0, 18), ylim = c(-0.9, 3.6), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(20, 20, 20, 20))
}

# plot_fig_slide_08()

# SLIDE 9 - number line ========================================================

plot_fig_slide_09 <- function(stage = 9) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_09() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- validate stage ------------------------------------------------
  # stage controls progressive reveal, 1 (top axis + anchor) through
  # 9 (full plot). Anything outside 1-9 falls back to the full plot.
  if (!is.numeric(stage) || length(stage) != 1L || is.na(stage) ||
      stage < 1 || stage > 9) {
    stage <- 9L
  } else {
    stage <- as.integer(stage)
  }
  
  # ---- palette -----------------------------------------------------------
  navy <- "#1b2b34"   # axis lines + primary numbers
  teal <- "#2f7d64"   # anchor / log side / symmetric
  red  <- "#c0463a"   # odds brackets / lopsided
  grey <- "#8a9299"   # secondary labels + zero tick
  
  # ---- coordinate mappings -----------------------------------------------
  # Top axis is linear in the odds; bottom axis is linear in the log-odds.
  # The two slope constants (1.85 / 1.70) set how stretched each line is.
  x_top <- function(v) 1.20 + 1.85 * v
  x_bot <- function(w) 4.90 + 1.70 * w
  
  y_top <- 6
  y_bot <- 0
  ax_l  <- 1.00       # left end of both axis lines
  ax_r  <- 9.50       # right end (arrow head)
  th    <- 0.18       # tick half-height
  
  # ---- geometry helpers --------------------------------------------------
  # A square bracket = one horizontal segment plus two end ticks.
  # dir = +1 ticks point up (toward an axis above); dir = -1 point down.
  bracket <- function(x1, x2, yb, dir, tick = 0.30) {
    tibble::tibble(
      x    = c(x1, x1, x2),
      xend = c(x2, x1, x2),
      y    = c(yb, yb, yb),
      yend = c(yb, yb + dir * tick, yb + dir * tick)
    )
  }
  
  # Top axis: single line, right-pointing arrow only.
  # Bottom axis: single line, arrows on BOTH ends (log-odds runs -Inf -> +Inf).
  top_axis <- tibble::tibble(x = ax_l, xend = ax_r, y = y_top, yend = y_top)
  bot_axis <- tibble::tibble(x = ax_l, xend = ax_r, y = y_bot, yend = y_bot)
  
  arrow_head      <- grid::arrow(length = grid::unit(0.22, "cm"), type = "closed")
  arrow_head_both <- grid::arrow(length = grid::unit(0.22, "cm"), type = "closed", ends = "both")
  arrow_x <- mean(x_top(c(0.25, 4)))   # centre the "take the log" arrow
  
  # ---- build plot, one reveal stage at a time ----------------------------
  p <- ggplot2::ggplot()
  
  # ---- stage 1: top number line; label 1 anchor --------------------------
  if (stage >= 1) {
    p <- p +
      ggplot2::geom_segment(
        data = top_axis, ggplot2::aes(x, y, xend = xend, yend = yend),
        colour = navy, linewidth = 0.9, arrow = arrow_head
      ) +
      ggplot2::annotate(
        "segment", x = x_top(1), xend = x_top(1),
        y = y_top - th, yend = y_top + th,
        colour = navy, linewidth = 0.9
      ) +
      ggplot2::annotate(
        "text", x = x_top(1), y = y_top + 0.55,
        label = "1", fontface = "bold", colour = navy, size = 6
      ) +
      ggplot2::annotate(
        "text", x = x_top(1), y = y_top + 1.15,
        label = "anchor", colour = teal, fontface = "italic", size = 4.4
      )
  }
  
  # ---- stage 2: add label 4 death -----------------------------------------
  if (stage >= 2) {
    p <- p +
      ggplot2::annotate(
        "segment", x = x_top(4), xend = x_top(4),
        y = y_top - th, yend = y_top + th,
        colour = navy, linewidth = 0.9
      ) +
      ggplot2::annotate(
        "text", x = x_top(4), y = y_top + 0.55,
        label = "4", fontface = "plain", colour = navy, size = 6
      ) +
      ggplot2::annotate(
        "text", x = x_top(4), y = y_top + 1.15,
        label = "death", colour = grey, fontface = "italic", size = 4.4
      )
  }
  
  # ---- stage 3: add label 0.25 survival -----------------------------------
  if (stage >= 3) {
    p <- p +
      ggplot2::annotate(
        "segment", x = x_top(0.25), xend = x_top(0.25),
        y = y_top - th, yend = y_top + th,
        colour = navy, linewidth = 0.9
      ) +
      ggplot2::annotate(
        "text", x = x_top(0.25), y = y_top + 0.55,
        label = "0.25", fontface = "plain", colour = navy, size = 6
      ) +
      ggplot2::annotate(
        "text", x = x_top(0.25), y = y_top + 1.15,
        label = "survival", colour = grey, fontface = "italic", size = 4.4
      )
  }
  
  # ---- stage 4: add label odds 0 to infinity ------------------------------
  if (stage >= 4) {
    p <- p +
      ggplot2::annotate(
        "segment", x = x_top(0), xend = x_top(0),
        y = y_top - th, yend = y_top + th,
        colour = grey, linewidth = 0.9
      ) +
      ggplot2::annotate(
        "text", x = x_top(0), y = y_top - 0.45,
        label = "0", colour = grey, size = 4.2
      ) +
      ggplot2::annotate(
        "text", x = ax_r + 0.35, y = y_top, hjust = 0,
        label = "odds: 0 \u2192 \u221e", colour = grey, size = 4.4
      )
  }
  
  # ---- stage 5: add red label 3.00 above the anchor (+ red bracket) -------
  if (stage >= 5) {
    upper_br <- bracket(x_top(1), x_top(4), y_top - 0.80, dir = 1)
    p <- p +
      ggplot2::geom_segment(
        data = upper_br, ggplot2::aes(x, y, xend = xend, yend = yend),
        colour = red, linewidth = 0.7
      ) +
      ggplot2::annotate(
        "text", x = mean(x_top(c(1, 4))), y = y_top - 1.35,
        label = "3.00 above the anchor", colour = red, size = 4.4
      )
  }
  
  # ---- stage 6: add red label 0.75 below (+ red bracket) ------------------
  if (stage >= 6) {
    lower_br <- bracket(x_top(0.25), x_top(1), y_top - 0.80, dir = 1)
    p <- p +
      ggplot2::geom_segment(
        data = lower_br, ggplot2::aes(x, y, xend = xend, yend = yend),
        colour = red, linewidth = 0.7
      ) +
      ggplot2::annotate(
        "text", x = mean(x_top(c(0.25, 1))), y = y_top - 1.35,
        label = "0.75 below", colour = red, size = 4.4
      )
  }
  
  # ---- stage 7: add lopsided label -----------------------------------------
  if (stage >= 7) {
    p <- p +
      ggplot2::annotate(
        "text", x = arrow_x, y = y_top - 2.05,
        label = "lopsided", colour = red,
        fontface = "italic", size = 5
      )
  }
  
  # ---- stage 8: add "take the log" label (+ down arrow) --------------------
  if (stage >= 8) {
    p <- p +
      ggplot2::annotate(
        "segment", x = arrow_x, xend = arrow_x, y = 3.35, yend = 2.55,
        colour = teal, linewidth = 1.1,
        arrow = grid::arrow(length = grid::unit(0.28, "cm"), type = "closed")
      ) +
      ggplot2::annotate(
        "text", x = arrow_x + 0.30, y = 2.95, hjust = 0,
        label = "take the log", colour = teal,
        fontface = "bold", size = 5.2
      )
  }
  
  # ---- stage 9: add the bottom number line (the rest of the figure) -------
  if (stage >= 9) {
    bot_ticks <- tibble::tibble(x = x_bot(c(-1.39, 0, 1.39)))
    grn_br <- rbind(
      bracket(x_bot(-1.39), x_bot(0),    y_bot + 0.80, dir = -1),
      bracket(x_bot(0),     x_bot(1.39), y_bot + 0.80, dir = -1)
    )
    
    p <- p +
      ggplot2::geom_segment(
        data = bot_axis, ggplot2::aes(x, y, xend = xend, yend = yend),
        colour = navy, linewidth = 0.9, arrow = arrow_head_both
      ) +
      ggplot2::geom_segment(
        data = bot_ticks,
        ggplot2::aes(x = x, xend = x, y = y_bot - th, yend = y_bot + th),
        colour = navy, linewidth = 0.9
      ) +
      ggplot2::geom_segment(
        data = grn_br, ggplot2::aes(x, y, xend = xend, yend = yend),
        colour = teal, linewidth = 0.7
      ) +
      ggplot2::annotate(
        "text", x = x_bot(c(-1.39, 0, 1.39)), y = y_bot - 0.55,
        label = c("\u22121.39", "0", "+1.39"),
        fontface = c("plain", "bold", "plain"), colour = navy, size = 6
      ) +
      ggplot2::annotate(
        "text", x = x_bot(c(-1.39, 0, 1.39)), y = y_bot - 1.15,
        label = c("survival", "anchor", "death"),
        colour = c(grey, teal, grey), fontface = "italic", size = 4.4
      ) +
      ggplot2::annotate(
        "text", x = mean(x_bot(c(-1.39, 0))), y = y_bot + 1.35,
        label = "1.39", colour = teal, size = 4.4
      ) +
      ggplot2::annotate(
        "text", x = mean(x_bot(c(0, 1.39))), y = y_bot + 1.35,
        label = "1.39", colour = teal, size = 4.4
      ) +
      ggplot2::annotate(
        "text", x = x_bot(1.39) + 0.55, y = y_bot + 1.35, hjust = 0,
        label = "symmetric", colour = teal,
        fontface = "italic", size = 5
      ) +
      ggplot2::annotate(
        "text", x = ax_r + 0.35, y = y_bot, hjust = 0,
        label = "log-odds: \u2212\u221e \u2192 +\u221e",
        colour = grey, size = 4.4
      )
  }
  
  p +
    ggplot2::coord_cartesian(xlim = c(0.8, 13), ylim = c(-1.8, 7.6), clip = "off") +
    ggplot2::theme_void()
}


# SLIDE 10 - two views ========================================================

plot_fig_slide_10 <- function(stage = 2) {
  
  # ---- dependency guard --------------------------------------------------
  .pkgs <- c("ggplot2", "tibble", "patchwork")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_10() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage validation ---------------------------------------------------
  # Valid stages are 1-2. Anything else falls back to the full reveal (stage 2).
  if (!is.numeric(stage) || length(stage) != 1L || is.na(stage) ||
      !(stage %in% c(1, 2))) {
    stage <- 2
  }
  
  # ---- Model coefficients ------------------------------------------------
  # Chosen so the log-odds line runs from ~-5 (age 0) to ~+5 (age 110) and
  # crosses zero (probability 0.5) near age 57-58.
  b0 <- -5.227      # intercept
  b1 <-  0.0909     # slope per year of age
  
  # ---- Palette -----------------------------------------------------------
  teal     <- "#0F766E"   # dark teal line
  slate    <- "#334155"   # dark slate arrow
  ref_grey <- "grey78"    # zero reference line
  bound    <- "grey55"    # dashed 0 / 1 bounds
  
  # ---- Data --------------------------------------------------------------
  d <- tibble::tibble(age = seq(0, 110, length.out = 500))
  d$log_odds <- b0 + b1 * d$age
  d$prob     <- stats::plogis(d$log_odds)   # exp(x) / (1 + exp(x))
  
  # ---- Shared theme ------------------------------------------------------
  base_theme <- ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = "white", colour = NA),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.grid       = ggplot2::element_blank(),
      axis.line        = ggplot2::element_line(colour = "grey35", linewidth = 0.5),
      axis.ticks       = ggplot2::element_line(colour = "grey35", linewidth = 0.4),
      plot.title       = ggplot2::element_text(face = "bold", size = 14,
                                               margin = ggplot2::margin(b = 10)),
      axis.title       = ggplot2::element_text(colour = "grey25"),
      plot.margin      = ggplot2::margin(12, 14, 12, 14)
    )
  
  # ---- Left panel: log-odds (linear) -------------------------------------
  p_left <- ggplot2::ggplot(d, ggplot2::aes(x = age, y = log_odds)) +
    ggplot2::geom_hline(yintercept = 0, colour = ref_grey, linewidth = 0.7) +
    ggplot2::geom_line(colour = teal, linewidth = 1.5) +
    ggplot2::annotate(
      "text", x = 4, y = 3.7, hjust = 0, size = 4.6, parse = TRUE,
      label = '"log-odds"(pi) == beta[0] + beta[1] %.% "age"'
    ) +
    ggplot2::annotate(
      "text", x = 4, y = 2.95, hjust = 0, size = 3.7,
      colour = "grey45", label = "(the logit)"
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, 100, 20), limits = c(0, 111),
      expand = ggplot2::expansion(mult = c(0.01, 0.02))
    ) +
    ggplot2::scale_y_continuous(breaks = seq(-4, 4, 2), limits = c(-5.6, 5.6)) +
    ggplot2::labs(
      title = "Log-odds scale \u2014 a straight line",
      x = "Age", y = "Log-odds of death"
    ) +
    base_theme
  
  # ---- Stage 1: left panel only, blank space reserved --------------------
  if (stage == 1) {
    p_blank_arrow <- patchwork::plot_spacer()
    p_blank_right <- patchwork::plot_spacer()
    
    return(
      p_left + p_blank_arrow + p_blank_right +
        patchwork::plot_layout(widths = c(1, 0.2, 1))
    )
  }
  
  # ---- Right panel: probability (S-curve) --------------------------------
  p_right <- ggplot2::ggplot(d, ggplot2::aes(x = age, y = prob)) +
    ggplot2::geom_hline(yintercept = c(0, 1), colour = bound,
                        linetype = "dashed", linewidth = 0.55) +
    ggplot2::geom_line(colour = teal, linewidth = 1.5) +
    ggplot2::annotate(
      "text", x = 108, y = 0.20, hjust = 1, size = 4.6, parse = TRUE,
      label = paste0(
        'pi == frac(e^(beta[0] + beta[1] %.% "age"),',
        '~1 + e^(beta[0] + beta[1] %.% "age"))'
      )
    ) +
    ggplot2::scale_x_continuous(
      breaks = seq(0, 100, 20), limits = c(0, 111),
      expand = ggplot2::expansion(mult = c(0.01, 0.02))
    ) +
    ggplot2::scale_y_continuous(breaks = c(0, 0.5, 1), limits = c(-0.06, 1.06)) +
    ggplot2::labs(
      title = "Probability scale \u2014 an S-curve in [0, 1]",
      x = "Age", y = "Probability of death"
    ) +
    base_theme
  
  # ---- Connecting arrow --------------------------------------------------
  p_arrow <- ggplot2::ggplot() +
    ggplot2::annotate(
      "segment", x = 0.15, xend = 0.85, y = 0.5, yend = 0.5,
      colour = slate, linewidth = 1.7,
      arrow = grid::arrow(length = grid::unit(0.13, "inch"), type = "closed")
    ) +
    ggplot2::scale_x_continuous(limits = c(0, 1)) +
    ggplot2::scale_y_continuous(limits = c(0, 1)) +
    ggplot2::theme_void()
  
  # ---- Stage 2 (or fallback): full plot -----------------------------------
  p_left + p_arrow + p_right +
    patchwork::plot_layout(widths = c(1, 0.2, 1))
}

# SLIDE 11 - coefficient =======================================================

plot_fig_slide_11 <- function() {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_11() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- palette -----------------------------------------------------------

  # thin baseline that runs the full width
  axis_grey   <- "grey45"
  
  # "Lower odds" title / beta label 
  # left segment (lower odds)
  teal  <- "#0F766E"
  
  # right segment (higher odds)
  # "Higher odds" title / beta label
  red <- "#c0463a"   

  # bold anchor equation 
  # muted caption 
  # the target ring in the middle
  slate   <- "#334155"   
  
  # ---- geometry ----------------------------------------------------------
  # coord_fixed keeps the anchor a true circle; the x/y limits set the
  # overall canvas proportions seen in the reference art.
  gap   <- 0.055                                 # blank space each side of centre
  theta <- seq(0, 2 * pi, length.out = 120)
  ring  <- tibble::tibble(x = gap * cos(theta), y = gap * sin(theta))
  
  ggplot2::ggplot() +
    
    # full-width hairline baseline (extends slightly past the coloured ends)
    ggplot2::annotate(
      "segment", x = -1.08, xend = 1.08, y = 0, yend = 0,
      colour = axis_grey, linewidth = 0.4
    ) +
    
    # coloured half-lines
    ggplot2::annotate(
      "segment", x = -0.9, xend = -gap, y = 0, yend = 0,
      colour = teal, linewidth = 1.6, lineend = "round"
    ) +
    ggplot2::annotate(
      "segment", x = gap, xend = 0.9, y = 0, yend = 0,
      colour = red, linewidth = 1.6, lineend = "round"
    ) +
    
    # vertical dashed guide through the anchor
    ggplot2::annotate(
      "segment", x = 0, xend = 0, y = -0.12, yend = 0.20,
      colour = slate, linewidth = 0.4, linetype = "22"
    ) +
    
    # anchor target: dashed ring + solid inner ring + dark centre dot
    ggplot2::geom_path(
      data = ring, ggplot2::aes(x, y),
      colour = slate, linewidth = 0.5, linetype = "22"
    ) +
    ggplot2::annotate(
      "point", x = 0, y = 0, shape = 21, size = 6,
      colour = slate, stroke = 1
    ) +
    ggplot2::annotate("point", x = 0, y = 0, size = 2, colour = "grey50") +
    
    # section titles
    ggplot2::annotate(
      "text", x = -0.55, y = 0.42, label = "Lower odds",
      colour = teal, fontface = "bold", size = 7
    ) +
    ggplot2::annotate(
      "text", x = 0.55, y = 0.42, label = "Higher odds",
      colour = red, fontface = "bold", size = 7
    ) +
    
    # beta / odds-ratio labels under each half
    ggplot2::annotate(
      "text", x = -0.55, y = -0.26, label = "\u03b2 < 0 \u2192 OR < 1",
      colour = teal, size = 5.5
    ) +
    ggplot2::annotate(
      "text", x = 0.55, y = -0.26, label = "\u03b2 > 0 \u2192 OR > 1",
      colour = red, size = 5.5
    ) +
    
    # anchor equation + caption
    ggplot2::annotate(
      "text", x = 0, y = -0.40, label = "\u03b2 = 0 \u00b7 OR = 1",
      colour = slate, fontface = "bold", size = 6
    ) +
    ggplot2::annotate(
      "text", x = 0, y = -0.50, label = "The anchor \u2014 no difference",
      colour = slate, size = 4.8
    ) +
    
    ggplot2::coord_fixed(
      ratio = 1, xlim = c(-1.1, 1.1), ylim = c(-0.55, 0.5), clip = "off"
    ) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(colour = NA),
      panel.background = ggplot2::element_rect(colour = NA),
      plot.margin      = ggplot2::margin(10, 10, 10, 10)
    )
}

# SLIDE 12 - odds ratio ========================================================

plot_fig_slide_12 <- function(stage = 4) {
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "tibble", "dplyr", "tidyr")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_12() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage guard --------------------------------------------------------
  #   1: top row + number line
  #   2: + second row
  #   3: + third row
  #   4: + bottom row (full plot) -- default, and fallback for any
  #      out-of-range value
  if (length(stage) != 1L || is.na(stage) || !stage %in% 1:4) {
    stage <- 4
  }
  
  # ---- palette (identical to slide 08) -----------------------------------
  col_red  <- "#B0392B"   # died
  col_gray <- "#C9CDD2"   # survived
  col_teal <- "#158F8B"   # the anchor annotation
  col_note <- "grey55"    # other annotations
  col_ink  <- "grey25"    # labels / arrow
  col_band <- "grey92"    # reference-row highlight
  
  # ---- one reusable person silhouette (identical to slide 08) ------------
  person_template <- tibble::tibble(
    part = c(rep("body", 13), rep("head", 40)),
    px = c(
      -0.30, -0.30, -0.29, -0.25, -0.18, -0.09,  0.00,  0.09,  0.18,  0.25,  0.29,  0.30,  0.30,
      0.17 * cos(seq(0, 2 * pi, length.out = 40))
    ),
    py = c(
      0.00,  0.34,  0.42,  0.49,  0.55,  0.585, 0.60,  0.585, 0.55,  0.49,  0.42,  0.34,  0.00,
      0.80 + 0.17 * sin(seq(0, 2 * pi, length.out = 40))
    )
  )
  
  # ---- icon grid: 4 rows x 10 icons --------------------------------------
  #   row 4 = reference set; rows 3, 2, 1 = the three comparison sets
  #   rows are listed top -> bottom, so the first `stage` rows here are
  #   exactly the rows revealed by that stage
  rows <- tibble::tibble(
    row_y = c(4, 3, 2, 1),
    n_red = c(6, 9, 6, 5)          # number of "died" icons per row
  )
  
  rows_shown <- rows$row_y[seq_len(stage)]
  
  icons <- rows |>
    dplyr::filter(row_y %in% rows_shown) |>
    dplyr::mutate(x = list(1:10)) |>
    tidyr::unnest(x) |>
    dplyr::mutate(
      icon_id = dplyr::row_number(),
      fill    = dplyr::if_else(x <= n_red, col_red, col_gray)
    )
  
  # ---- stamp the template at every icon position -------------------------
  scale_person <- 0.78
  centre_y     <- 0.485
  
  people <- icons |>
    dplyr::cross_join(person_template) |>
    dplyr::mutate(
      gx  = x + px * scale_person,
      gy  = row_y + (py - centre_y) * scale_person,
      grp = paste(icon_id, part)
    )
  
  # ---- reference-row highlight band --------------------------------------
  #   row 4 (the reference set) is present from stage 1 onward, so the
  #   band is always drawn
  ref_band <- tibble::tibble(xmin = 0.4, xmax = 20.6, ymin = 3.5, ymax = 4.5)
  
  # ---- row labels + annotations ------------------------------------------
  #   headline = the odds ratio (the point of the slide);
  #   note     = the odds behind it + anchor language (echoes slide 08)
  labels <- tibble::tibble(
    row_y = c(4, 3, 2, 1),
    label = c(
      "reference set  \u00b7  odds = 6 : 4 = 1.5",
      "OR = 9 / 1.5 = 6",
      "OR = 1.5 / 1.5 = 1",
      "OR = 1 / 1.5 \u2248 0.67"
    ),
    note = c(
      "the baseline we compare against",
      "odds 9 vs 1.5  \u2014  above the anchor, higher odds",
      "odds 1.5 vs 1.5  \u2014  the anchor, no change",
      "odds 1 vs 1.5  \u2014  below the anchor, lower odds"
    ),
    note_col = c(col_note, col_note, col_teal, col_note)
  ) |>
    dplyr::filter(row_y %in% rows_shown)
  
  # ---- bottom scale arrow (schematic) -------------------------------------
  #   the number line is present from stage 1 onward, independent of `stage`
  x_left   <- 1
  x_right  <- 10
  x_anchor <- 4.5   # schematic position of OR = 1 on the arrow
  
  # ---- plot --------------------------------------------------------------
  ggplot2::ggplot() +
    # reference-row band (drawn first, sits behind the people)
    ggplot2::geom_rect(
      data = ref_band,
      ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = col_band, colour = NA
    ) +
    # people
    ggplot2::geom_polygon(
      data = people,
      ggplot2::aes(x = gx, y = gy, group = grp, fill = fill),
      colour = NA
    ) +
    # row headlines
    ggplot2::geom_text(
      data = labels,
      ggplot2::aes(x = 11, y = row_y, label = label),
      hjust = 0, size = 4.6, colour = col_ink
    ) +
    # italic annotations under each headline
    ggplot2::geom_text(
      data = labels,
      ggplot2::aes(x = 11, y = row_y - 0.33, label = note, colour = note_col),
      hjust = 0, size = 3.8, fontface = "italic"
    ) +
    # 0 -> infinity arrow
    ggplot2::geom_segment(
      ggplot2::aes(x = x_left, xend = x_right, y = 0, yend = 0),
      linewidth = 0.7, colour = col_ink,
      arrow = grid::arrow(length = grid::unit(0.18, "cm"), type = "closed")
    ) +
    ggplot2::annotate("text", x = x_left - 0.5, y = 0, label = "0",
                      size = 4.6, colour = col_ink, hjust = 1) +
    ggplot2::annotate("text", x = x_right + 0.5, y = 0, label = "\u221E",
                      size = 5.5, colour = col_ink, hjust = 0) +
    # anchor tick at OR = 1
    ggplot2::annotate("segment", x = x_anchor, xend = x_anchor, y = -0.17, yend = 0.17,
                      linewidth = 0.8, colour = col_teal) +
    ggplot2::annotate("text", x = x_anchor, y = 0.34, label = "OR = 1",
                      size = 3.6, colour = col_teal, fontface = "italic") +
    ggplot2::annotate("text", x = (x_left + x_right) / 2, y = -0.5,
                      label = "odds ratio: 0 \u2192 \u221E  \u00b7  1 = no change",
                      size = 3.8, colour = col_note, fontface = "italic") +
    ggplot2::scale_fill_identity() +
    ggplot2::scale_colour_identity() +
    ggplot2::coord_fixed(ratio = 1, xlim = c(0, 21), ylim = c(-0.9, 4.6), clip = "off") +
    ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(20, 20, 20, 20))
}

# SLIDE 13 - adjustment ========================================================
plot_fig_slide_13 <- function(stage = 12) {
  
  # ---- dependency guard ---------------------------------------------------
  .pkgs <- c("ggplot2", "tibble", "patchwork", "ggtext")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_13() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- stage guard ---------------------------------------------------------
  # stage drives the progressive reveal: 1 = bare left-panel x axis,
  # 12 = full two-panel figure (default). Anything invalid -> full plot.
  if (!is.numeric(stage) || length(stage) != 1L || is.na(stage) ||
      stage < 1 || stage > 12) {
    stage <- 12
  }
  stage <- floor(stage)
  
  # ---- colour grammar -----------------------------------------------------
  # teal  = the adjusted / within-group / trustworthy thread (runs both panels)
  # red   = reserved ONLY for the misleading pooled line
  # slate = the untreated reference group (not "wrong", just a baseline)
  teal  <- "#1B9E9E"
  red   <- "#C0392B"
  slate <- "#4C566A"
  ink   <- "grey30"
  note  <- "grey45"
  
  # =========================================================================
  # LEFT PANEL — "each coefficient: the others held constant"
  # Reveal order: x axis (1) -> x ticks/label (2) -> lines (3) ->
  # treated label (4) -> untreated label (5) -> arrow + y label (6) ->
  # arrow label (7) -> caption (8)
  # =========================================================================
  age   <- seq(0, 110, by = 1)
  n_age <- length(age)                 # capture before it becomes a column
  slope <- 0.075                       # shared slope => lines stay parallel
  untreated <- -4.4 + slope * age      # untreated intercept
  treated   <- -5.7 + slope * age      # treated: same slope, lower by 1.3
  lines <- tibble::tibble(
    age     = rep(age, 2),
    logodds = c(untreated, treated),
    grp     = rep(c("untreated", "treated"), each = n_age)
  )
  
  # Gap read at a single age (60): the vertical distance IS the coefficient.
  gap_x  <- 60
  gap_lo <- -5.7 + slope * gap_x       # treated  = -1.2
  gap_hi <- -4.4 + slope * gap_x       # untreated =  0.1
  
  left <- ggplot2::ggplot(lines, ggplot2::aes(age, logodds, colour = grp)) +
    # stage 3: the two sloped lines (grey above, teal below)
    (if (stage >= 3) ggplot2::geom_line(linewidth = 1)) +
    # stage 6: the constant group difference, marked with a two-headed arrow
    (if (stage >= 6) ggplot2::annotate(
      "segment",
      x = gap_x, xend = gap_x, y = gap_lo, yend = gap_hi,
      colour = ink, linewidth = 0.8,
      arrow = grid::arrow(ends = "both", length = grid::unit(0.18, "cm"),
                          type = "closed")
    )) +
    # stage 7: label for that arrow
    (if (stage >= 7) ggplot2::annotate(
      "text", x = gap_x + 4, y = mean(c(gap_lo, gap_hi)),
      label = "group difference\n('effect' of treatment)",
      colour = note, hjust = 0, vjust = 0.5, size = 4.4, lineheight = 0.95
    )) +
    # stage 5: direct label for the untreated (grey) line
    (if (stage >= 5) ggplot2::annotate("text", x = 112, y = -4.4 + slope * 110,
                                       label = "untreated", colour = slate,
                                       hjust = 0, size = 4)) +
    # stage 4: direct label for the treated (teal) line
    (if (stage >= 4) ggplot2::annotate("text", x = 112, y = -5.7 + slope * 110,
                                       label = "treated", colour = teal,
                                       hjust = 0, size = 4)) +
    ggplot2::scale_colour_manual(values = c(untreated = slate, treated = teal),
                                 guide = "none") +
    ggplot2::scale_x_continuous(breaks = seq(0, 100, 20), limits = c(0, 128)) +
    ggplot2::labs(
      x = if (stage >= 1) "Age" else " ",
      y = if (stage >= 6) "Log-odds of death" else " ",
      caption = if (stage >= 8)
        "Each coefficient: one predictor, the others held constant." else " "
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      panel.grid   = ggplot2::element_blank(),
      # stage 1: bare x axis line, present from the very first stage
      axis.line.x  = ggplot2::element_line(colour = ink),
      # stage 2: ticks and numbers join the axis line
      axis.ticks.x = if (stage >= 1) ggplot2::element_line(colour = ink) else ggplot2::element_blank(),
      axis.text.x  = if (stage >= 1) ggplot2::element_text() else ggplot2::element_blank(),
      axis.text.y  = ggplot2::element_blank(),   # numbers dropped by request
      axis.ticks.y = ggplot2::element_blank(),
      plot.caption = ggplot2::element_text(hjust = 0, colour = note, size = 11)
    )
  
  # =========================================================================
  # RIGHT PANEL — "leave a predictor out and the pooled trend reverses"
  # Reveal order: axes/labels/points (9) -> pooled line + label (10) ->
  # within-group lines + label (11) -> caption (12)
  # Before stage 9 this panel stays blank but keeps its slot in the layout.
  # =========================================================================
  set.seed(13)
  n_per        <- 12
  centres_x    <- c(2, 5, 8)           # groups shifted up-and-right together...
  centres_y    <- c(2, 5, 8)           # ...creating a positive BETWEEN-group trend
  within_slope <- -0.8                 # ...while each group runs downward
  
  make_group <- function(cx, cy, g) {
    x <- cx + stats::runif(n_per, -0.9, 0.9)
    y <- cy + within_slope * (x - cx) + stats::rnorm(n_per, 0, 0.35)
    tibble::tibble(group = g, x = x, y = y)
  }
  pts <- rbind(
    make_group(centres_x[1], centres_y[1], "A"),
    make_group(centres_x[2], centres_y[2], "B"),
    make_group(centres_x[3], centres_y[3], "C")
  )
  
  right <- ggplot2::ggplot(pts, ggplot2::aes(x, y)) +
    # stage 9: the data points (teal)
    (if (stage >= 9) ggplot2::geom_point(colour = teal, size = 2, alpha = 0.85)) +
    # stage 10: pooled fit (the misleading one)
    (if (stage >= 10) ggplot2::geom_smooth(ggplot2::aes(group = 1),
                                           method = "lm", formula = y ~ x, se = FALSE,
                                           colour = red, linewidth = 1, linetype = "dashed")) +
    # stage 11: within-group fits (the honest signal)
    (if (stage >= 11) ggplot2::geom_smooth(ggplot2::aes(group = group),
                                           method = "lm", formula = y ~ x, se = FALSE,
                                           colour = teal, linewidth = 1)) +
    # stage 10: red "pooled" label
    (if (stage >= 10) ggplot2::annotate("text", x = 7.4, y = 9.2, label = "pooled",
                                        colour = red, hjust = 0, size = 4.6)) +
    # stage 11: teal "within group" label
    (if (stage >= 11) ggplot2::annotate("text", x = 1.2, y = 3.5, label = "within group",
                                        colour = teal, hjust = 0, size = 4.6)) +
    ggplot2::coord_cartesian(xlim = c(0.5, 9.5), ylim = c(0.5, 9.8)) +
    ggplot2::labs(
      x = if (stage >= 9) "Predictor" else " ",
      y = if (stage >= 9) "Outcome" else " ",
      caption = if (stage >= 12) "Group left out \u2192 trend reverses." else " "
    ) +
    ggplot2::theme_minimal(base_size = 14) +
    ggplot2::theme(
      panel.grid   = ggplot2::element_blank(),
      # stage 9: x and y axis lines appear together; blank (but reserved) before that
      axis.line    = if (stage >= 9) ggplot2::element_line(colour = ink) else ggplot2::element_blank(),
      axis.text    = ggplot2::element_blank(),   # conceptual axes, no numbers, ever
      axis.ticks   = ggplot2::element_blank(),
      plot.caption = ggplot2::element_text(hjust = 0, colour = note, size = 11)
    )
  
  # =========================================================================
  # PAYOFF STRIP — one line, mostly quiet ink, the key phrase in teal.
  # =========================================================================
  payoff <- ggplot2::ggplot() +
    ggtext::geom_richtext(
      data = tibble::tibble(
        x = 0, y = 0,
        label = " "
        # label = paste0(
        #   "Exponentiated, an adjusted coefficient is an ",
        #   "<b style='color:", teal, "'>adjusted odds ratio</b>"
        # )
      ),
      ggplot2::aes(x, y, label = label),
      fill = NA, label.color = NA, size = 5, hjust = 0.5, vjust = 0.5
    ) +
    ggplot2::theme_void()
  
  # ---- assemble: two panels over the payoff strip -------------------------
  # Right panel gets a touch more width so the reversal reads as the hero.
  # This layout is fixed across all stages so the right panel's slot stays
  # reserved (blank) until its own reveal begins at stage 9.
  top <- (left | right) + patchwork::plot_layout(widths = c(1, 1.1))
  top / payoff + patchwork::plot_layout(heights = c(6, 1))
}

plot_fig_slide_15 <- function(stage = 4) {
  
  # ---- stage argument guard -----------------------------------------------
  # 1: top banner + citation
  # 2: + left panel  ("THE SIGNAL" — nasal swab illustration)
  # 3: + middle panel ("THE SPLIT"  — thermal spine / 66C threshold)
  # 4: + right panel ("THE STUDY"  — cohort + outcomes summary)  [default/full]
  if (!is.numeric(stage) || length(stage) != 1L || is.na(stage) ||
      stage < 1 || stage > 4) {
    stage <- 4
  }
  
  # ---- dependency guard (base tools only) --------------------------------
  .pkgs <- c("ggplot2", "grid", "tibble", "dplyr")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_15() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- fonts ---------------------------------------------------------------
  
  serif <- "serif"
  sans  <- "sans"
  if (requireNamespace("systemfonts", quietly = TRUE)) {
    avail <- systemfonts::system_fonts()$family
    if ("Georgia" %in% avail) serif <- "Georgia"
    else if ("Times New Roman" %in% avail) serif <- "Times New Roman"
    if ("Helvetica" %in% avail) sans <- "Helvetica"
    else if ("Arial" %in% avail) sans <- "Arial"
    else if ("Liberation Sans" %in% avail) sans <- "Liberation Sans"
  }
  
  # ---- palette --------------------------------
  ink          <- "#17202A"  # headline / primary text / dark icon strokes
  grey_txt     <- "#566068"  # body copy, section eyebrows, secondary labels
  grey_line    <- "#E4E7EA"  # header/footer dividers, card borders
  grey_arrow   <- "#99A2A9"  # connector lines + arrowheads
  axis_grey    <- "#C9D0D5"  # melt-curve chart axes
  curve_grey   <- "#3A434B"  # melt-curve line
  footer_grey  <- "#8A929A"  # footer text
  
  red_dark     <- "#B12C17"  # eyebrow / "ABOVE 66C - HIGH-RISK" / Tm label
  red_icon     <- "#DD3A22"  # Tm dashed line, soil/water icon strokes
  red_chip_fl  <- "#FCEAE5"  # soil/water chip fill
  red_chip_st  <- "#F1C3B6"  # soil/water chip stroke
  
  teal_dark    <- "#1F5A67"  # "LOWER Tm" / "BELOW 66C - LOWER-RISK"
  teal_icon    <- "#2C7A8C"  # all-other-species icon stroke
  teal_chip_fl <- "#E7F1F3"  # all-other-species chip fill
  teal_chip_st <- "#BBD7DD"  # all-other-species chip stroke
  
  pill_fill    <- "#F1F4F6"  # Tm-group / clinical-trait / OUTCOME pills
  pill_stroke  <- "#D6DCE0"
  
  hot_grad  <- c("#DD3A22", "#F4B3A0")  # thermal spine, top -> bottom (hot)
  cool_grad <- c("#A9D0D8", "#2C7A8C")  # thermal spine, top -> bottom (cool)
  
  # ---- geometry helpers (native SVG pixel space, y flipped for ggplot) ---
  W <- 1280L
  H <- 720L
  py <- function(y) H - y                    # svg-y (top=0) -> plot-y (up)
  
  circle <- function(cx, cy, r, n = 120) {
    a <- seq(0, 2 * pi, length.out = n)
    data.frame(x = cx + r * cos(a), y = cy + r * sin(a))
  }
  
  # letter-spacing stand-in: inserts thin spaces between characters so
  # tracked headers/eyebrows read closer to the source's letter-spacing
  track <- function(s, sp = "\u2009") gsub("(.)(?=.)", paste0("\\1", sp), s, perl = TRUE)
  
  # px (SVG font-size / stroke-width) -> ggplot's mm-based `size`/`linewidth`
  pt2mm <- function(px) px / 2.845276
  
  # r_px is the corner radius in the same native pixel units as the box
  # coordinates (i.e. equivalent to an SVG rect's rx). Using "native" units
  # for the radius -- not "snpc", which is relative to the whole panel --
  # keeps rounding consistent across boxes of different sizes.
  rrect <- function(xmin, xmax, ymin, ymax, r_px, fill = NA, col = NA, lwd = 1) {
    grid::roundrectGrob(
      x = grid::unit(mean(c(xmin, xmax)), "native"),
      y = grid::unit(mean(c(ymin, ymax)), "native"),
      width  = grid::unit(xmax - xmin, "native"),
      height = grid::unit(ymax - ymin, "native"),
      r = grid::unit(r_px, "native"),
      gp = grid::gpar(fill = fill, col = col, lwd = lwd)
    )
  }
  
  place_grob <- function(grob) {
    ggplot2::annotation_custom(grob, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf)
  }
  
  # cubic Bezier -> sampled polyline (reused for the melt curve AND,
  # below, for the water-droplet icon)
  bez <- function(p0, p1, p2, p3, n = 60) {
    t <- seq(0, 1, length.out = n)
    x <- (1 - t)^3 * p0[1] + 3 * (1 - t)^2 * t * p1[1] + 3 * (1 - t) * t^2 * p2[1] + t^3 * p3[1]
    y <- (1 - t)^3 * p0[2] + 3 * (1 - t)^2 * t * p1[2] + 3 * (1 - t) * t^2 * p2[2] + t^3 * p3[2]
    data.frame(x = x, y = y)
  }
  
  gradient_spine_layer <- function(cx, y_top, y_bot, w, top_colors, bottom_colors,
                                   seam_y, n_bands = 200, n_cap = 40) {
    hot_ramp  <- grDevices::colorRampPalette(top_colors,    space = "Lab")
    cool_ramp <- grDevices::colorRampPalette(bottom_colors, space = "Lab")
    
    edges <- seq(y_top, y_bot, length.out = n_bands + 1)
    seam_frac <- (y_top - seam_y) / (y_top - y_bot)
    n_hot  <- max(2L, round(n_bands * seam_frac))
    n_cool <- max(2L, n_bands - n_hot)
    cols <- c(hot_ramp(n_hot), cool_ramp(n_cool))          # top -> bottom, hard seam
    
    bands <- data.frame(
      xmin = cx - w / 2, xmax = cx + w / 2,
      ymin = edges[-1], ymax = edges[-length(edges)],
      fill = cols
    )
    
    r <- w / 2
    cap_top <- data.frame(
      x    = cx + r * cos(seq(0, pi, length.out = n_cap)),
      y    = y_top + r * sin(seq(0, pi, length.out = n_cap)),
      fill = cols[1]
    )
    cap_bot <- data.frame(
      x    = cx + r * cos(seq(pi, 2 * pi, length.out = n_cap)),
      y    = y_bot + r * sin(seq(pi, 2 * pi, length.out = n_cap)),
      fill = cols[length(cols)]
    )
    
    list(
      ggplot2::geom_rect(data = bands,
                         ggplot2::aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill),
                         colour = NA, inherit.aes = FALSE),
      ggplot2::geom_polygon(data = cap_top, ggplot2::aes(x, y, fill = fill), colour = NA, inherit.aes = FALSE),
      ggplot2::geom_polygon(data = cap_bot, ggplot2::aes(x, y, fill = fill), colour = NA, inherit.aes = FALSE),
      ggplot2::scale_fill_identity()
    )
  }
  
  tri_arrow <- function(cx, cy, dir = c("up", "down", "right"), colour, size = 7) {
    dir <- match.arg(dir)
    pts <- switch(dir,
                  up    = data.frame(x = c(cx - size * 0.55, cx + size * 0.55, cx),
                                     y = c(cy - size * 0.45, cy - size * 0.45, cy + size * 0.55)),
                  down  = data.frame(x = c(cx - size * 0.55, cx + size * 0.55, cx),
                                     y = c(cy + size * 0.45, cy + size * 0.45, cy - size * 0.55)),
                  right = data.frame(x = c(cx - size * 0.45, cx - size * 0.45, cx + size * 0.55),
                                     y = c(cy - size * 0.55, cy + size * 0.55, cy))
    )
    ggplot2::geom_polygon(data = pts, ggplot2::aes(x, y), fill = colour, colour = NA)
  }
  
  # ---- Module 1 illustration: stylized lung + bronchial-tree drawing,
  # returned as a standalone ggplot object (its own local coordinate space,
  # coord_fixed, theme_void). Embedded into the slide below via
  # annotation_custom() + ggplotGrob(), the same way the rounded-rect chips
  # elsewhere on the slide reuse a grob built outside the main `p` object. --
  f_lung <- function() {
    
    # ---- Define a rough lung silhouette (medial edge near x = 0, lateral bulge
    # further out), then smooth it into a closed curve with a Catmull-Rom spline
    # (avoids the overshoot/ripple a periodic cubic spline can produce at sharp
    # corners) ----
    catmull_rom_closed <- function(x, y, n_per_seg = 24) {
      m <- length(x)
      wrap <- function(i) ((i - 1) %% m) + 1
      out_x <- numeric(0)
      out_y <- numeric(0)
      for (i in seq_len(m)) {
        p0 <- c(x[wrap(i - 1)], y[wrap(i - 1)])
        p1 <- c(x[wrap(i)],     y[wrap(i)])
        p2 <- c(x[wrap(i + 1)], y[wrap(i + 1)])
        p3 <- c(x[wrap(i + 2)], y[wrap(i + 2)])
        t <- seq(0, 1, length.out = n_per_seg + 1)[-(n_per_seg + 1)]
        t2 <- t^2
        t3 <- t^3
        seg_x <- 0.5 * (2 * p1[1] + (-p0[1] + p2[1]) * t +
                          (2 * p0[1] - 5 * p1[1] + 4 * p2[1] - p3[1]) * t2 +
                          (-p0[1] + 3 * p1[1] - 3 * p2[1] + p3[1]) * t3)
        seg_y <- 0.5 * (2 * p1[2] + (-p0[2] + p2[2]) * t +
                          (2 * p0[2] - 5 * p1[2] + 4 * p2[2] - p3[2]) * t2 +
                          (-p0[2] + 3 * p1[2] - 3 * p2[2] + p3[2]) * t3)
        out_x <- c(out_x, seg_x)
        out_y <- c(out_y, seg_y)
      }
      tibble::tibble(x = out_x, y = out_y)
    }
    
    make_lung_outline <- function(mirror = 1) {
      # Hand-placed control points tracing one lung, starting at the apex and
      # moving down the medial (inner) side, around the rounded base, and back
      # up the lateral (outer) side.
      x <- mirror * c(-0.9, -0.5, -0.5, -0.7, -0.6, -0.9, -1.4,
                      -2.4, -3.3, -3.7, -3.7, -3.3, -2.2, -1.1)
      y <- c(10.0, 9.3, 7.8, 6.0, 3.5, 1.6, 0.3,
             0.0, 1.0, 3.0, 5.5, 7.8, 9.4, 10.0)
      catmull_rom_closed(x, y)
    }
    
    lung_left  <- make_lung_outline(mirror =  1)
    lung_right <- make_lung_outline(mirror = -1)
    lungs <- dplyr::bind_rows(
      dplyr::mutate(lung_left,  lung = "left"),
      dplyr::mutate(lung_right, lung = "right")
    )
    
    # ---- Build a stylized bronchial tree (trachea -> main bronchi ->
    # progressively finer branches) with recursive binary subdivision. Each
    # branch's heading is expressed as an angle from "straight down" (0 rad),
    # so a lung's tree drifts outward from the carina and then subdivides
    # around that heading. Width tapers by generation so deeper branches read
    # as finer airways. This is a stylized approximation, not clipped to the
    # lung outline -- deep generations may occasionally cross the silhouette
    # edge; reduce max_generation or the length shrink factor if that's too
    # busy for your use case. ----
    grow_branch <- function(x0, y0, angle, length, generation,
                            max_generation, branch_id, side) {
      x1 <- x0 + length * sin(angle)
      y1 <- y0 - length * cos(angle)
      
      segment <- tibble::tibble(
        x = x0, y = y0, xend = x1, yend = y1,
        generation = generation, branch_id = branch_id, side = side
      )
      
      if (generation >= max_generation) {
        return(segment)
      }
      
      # Two child branches, angled outward from the current heading, with a
      # little random jitter so the tree doesn't look perfectly symmetric
      angle_spread <- stats::runif(1, 0.35, 0.55)
      jitter       <- stats::runif(2, -0.08, 0.08)
      
      child_a <- grow_branch(
        x1, y1, angle - angle_spread + jitter[1],
        length * 0.72, generation + 1, max_generation,
        paste0(branch_id, "0"), side
      )
      child_b <- grow_branch(
        x1, y1, angle + angle_spread + jitter[2],
        length * 0.72, generation + 1, max_generation,
        paste0(branch_id, "1"), side
      )
      
      dplyr::bind_rows(segment, child_a, child_b)
    }
    
    make_bronchial_tree <- function(seed = 42, max_generation = 5) {
      set.seed(seed)
      
      # Trachea: straight midline tube from above the apex down to the carina
      trachea <- tibble::tibble(
        x = 0, y = 11.4, xend = 0, yend = 8.6,
        generation = 0, branch_id = "t", side = "trachea"
      )
      
      # Main bronchi angle out from the carina toward each hilum, then branch
      # recursively inside the corresponding lung (angle < 0 heads toward
      # negative x / lung_left; angle > 0 heads toward positive x / lung_right)
      bronchus_left <- grow_branch(
        x0 = 0, y0 = 8.6, angle = -0.75, length = 2.1,
        generation = 1, max_generation = max_generation,
        branch_id = "l", side = "left"
      )
      bronchus_right <- grow_branch(
        x0 = 0, y0 = 8.6, angle = 0.75, length = 2.1,
        generation = 1, max_generation = max_generation,
        branch_id = "r", side = "right"
      )
      
      dplyr::bind_rows(trachea, bronchus_left, bronchus_right)
    }
    
    bronchial_tree <- make_bronchial_tree() |>
      dplyr::mutate(width = 0.9 * 0.78^generation)
    
    # ---- Plot ----
    lung_fill    <- "#D98E85"
    airway_color <- "#7A3B34"
    
    p <- ggplot2::ggplot() +
      ggplot2::geom_polygon(
        data = lungs,
        ggplot2::aes(x = x, y = y, group = lung),
        fill = lung_fill, color = NA
      ) +
      ggplot2::geom_segment(
        data = bronchial_tree,
        ggplot2::aes(x = x, y = y, xend = xend, yend = yend,
                     linewidth = width),
        color = airway_color, lineend = "round"
      ) +
      ggplot2::scale_linewidth_identity() +
      ggplot2::coord_fixed() +
      ggplot2::theme_void()
    
    p
    
  }
  
  # =========================================================================
  # BUILD PLOT
  # =========================================================================
  p <- ggplot2::ggplot() +
    ggplot2::coord_fixed(xlim = c(0, W), ylim = c(0, H), expand = FALSE, clip = "off")
  
  # ---- background ----------------------------------------------------------
  p <- p + ggplot2::annotate("rect", xmin = 0, xmax = W, ymin = 0, ymax = H,
                             fill = "white", colour = NA)
  
  # =========================================================================
  # STAGE 1 — HEADER (top banner), FOOTER, AND CITATION
  # =========================================================================
  if (stage >= 1) {
    
    # ---- header / top banner --------------------------------------------
    p <- p +
      ggplot2::annotate("text", x = 56, y = py(44), label = track("BACTERIAL LUNG INFECTION"),
                        family = sans, fontface = "bold", size = pt2mm(11.5),
                        colour = red_dark, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 56, y = py(78), label = "Legionella 5S rRNA PCR melting temperature analysis",
                        family = serif, fontface = "bold", size = pt2mm(30),
                        colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 56, y = py(104),
                        label = "A real-time PCR test returned a melting temperature (Tm) that splits the infecting bacteria into higher- and lower-risk species.",
                        family = sans, size = pt2mm(14.5), colour = grey_txt, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 56, y = py(125),
                        label = "Associations between Tm and clinical outcomes were assessed using multivariable logistic regression.",
                        family = sans, size = pt2mm(14.5), colour = grey_txt, hjust = 0, vjust = 0) +
      ggplot2::annotate("segment", x = 56, xend = 1224, y = py(148), yend = py(148),
                        colour = grey_line, linewidth = 0.5)
    
    # ---- citation (relocated here so it is present from stage 1 on) -----
    p <- p +
      ggplot2::annotate("text", x = 884, y = py(660), label = "
      Pulsipher AM, Khattar G, Harris E, White V, Stout C, Vikram HR, 
      Patel R, Simner PJ. 2026. Legionella 5S rRNA PCR melting temperature 
      analysis discriminates high-risk species associated with disease severity. 
      J Clin Microbiol 64:e00356-26.https://doi.org/10.1128/jcm.00356-26",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0)
    
    # ---- footer ------------------------------------------------------------
    p <- p +
      ggplot2::annotate("segment", x = 56, xend = 1224, y = py(676), yend = py(676), colour = grey_line, linewidth = 0.5) +
      ggplot2::annotate("text", x = 56, y = py(698), label = " ",
                        family = sans, size = pt2mm(11), colour = footer_grey, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 1224, y = py(698), label = " ",
                        family = sans, size = pt2mm(11), colour = footer_grey, hjust = 1, vjust = 0)
  }
  
  # =========================================================================
  # STAGE 2 — LEFT PANEL: MODULE 1 — THE SIGNAL (nasal-swab illustration)
  # =========================================================================
  if (stage >= 2) {
    
    p <- p +
      ggplot2::annotate("text", x = 56, y = py(174), label = track("THE SIGNAL"),
                        family = sans, fontface = "bold", size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0)
    
    # ---- lung illustration, built by f_lung() as a standalone ggplot in its
    # own local coordinate space, then embedded here as a grob. Sized by
    # fitting to the column width and preserving f_lung()'s own aspect ratio
    # (a portrait drawing, so -- unlike the old landscape swab scene -- it
    # runs taller than it is wide and extends further down the column). -----
    
    lung_plot <- f_lung()
    lung_grob <- ggplot2::ggplotGrob(lung_plot)
    
    # Read the illustration's own data extent straight off its built layers
    # (geom_polygon for the lungs, geom_segment for the bronchial tree) so the
    # fitted aspect ratio always matches what f_lung() actually draws, rather
    # than a hard-coded guess.
    lung_poly_data <- ggplot2::layer_data(lung_plot, 1)
    lung_seg_data  <- ggplot2::layer_data(lung_plot, 2)
    lung_x_range <- range(c(lung_poly_data$x, lung_seg_data$x, lung_seg_data$xend))
    lung_y_range <- range(c(lung_poly_data$y, lung_seg_data$y, lung_seg_data$yend))
    
    ill_src_w <- diff(lung_x_range)
    ill_src_h <- diff(lung_y_range)
    
    ill_dest_xmin    <- 56    # left-aligned with the rest of the slide
    ill_dest_xmax    <- 284   # leaves a ~44px gap before "THE SPLIT" column
    ill_dest_top_svg <- 200   # svg-style distance from the top (matches py())
    
    ill_scale    <- (ill_dest_xmax - ill_dest_xmin) / ill_src_w
    ill_dest_top <- py(ill_dest_top_svg)
    ill_bottom_svg <- ill_dest_top_svg + ill_src_h * ill_scale
    
    p <- p +
      ggplot2::annotation_custom(
        lung_grob,
        xmin = ill_dest_xmin, xmax = ill_dest_xmax,
        ymin = py(ill_bottom_svg), ymax = ill_dest_top
      )
    
    # ---- short caption beneath the illustration -------------------------------
    ill_caption_cx <- (ill_dest_xmin + ill_dest_xmax) / 2
    
    p <- p +
      ggplot2::annotate("text", x = ill_caption_cx, y = py(ill_bottom_svg + 22),
                        label = "Bacterial pneumonia", family = sans, fontface = "bold",
                        size = pt2mm(15.5), colour = ink, hjust = 0.5, vjust = 0) +
      ggplot2::annotate("text", x = ill_caption_cx, y = py(ill_bottom_svg + 42),
                        label = "the lung infection identified by PCR",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0.5, vjust = 0)
  }
  
  # =========================================================================
  # STAGE 3 — MIDDLE PANEL: MODULE 2 — THE SPLIT (hero thermal spine)
  # =========================================================================
  if (stage >= 3) {
    
    p <- p +
      ggplot2::annotate("text", x = 328, y = py(174), label = track("THE SPLIT"),
                        family = sans, fontface = "bold", size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0)
    
    spine_top <- 214; spine_bot <- 610; spine_seam <- 430
    
    p <- p + gradient_spine_layer(
      cx = 371, y_top = py(spine_top), y_bot = py(spine_bot),
      w = 46, top_colors = hot_grad, bottom_colors = cool_grad,
      seam_y = py(spine_seam)
    )
    
    p <- p +
      ggplot2::annotate("text", x = 336, y = py(205), label = track("HIGHER Tm"),
                        family = sans, fontface = "bold", size = pt2mm(10), colour = red_dark, hjust = 1, vjust = 0.35) +
      ggplot2::annotate("text", x = 336, y = py(628), label = track("LOWER Tm"),
                        family = sans, fontface = "bold", size = pt2mm(10), colour = teal_dark, hjust = 1, vjust = 0.65)
    p <- p +
      tri_arrow(cx = 348, cy = py(205) + 3, dir = "up",   colour = red_dark,  size = 7) +
      tri_arrow(cx = 348, cy = py(628) - 3, dir = "down", colour = teal_dark, size = 7)
    
    p <- p +
      ggplot2::annotate("segment", x = 332, xend = 428, y = py(430), yend = py(430),
                        colour = ink, linewidth = pt2mm(3) * 2.13,
                        arrow = grid::arrow(type = "closed", length = grid::unit(3, "mm"))) +
      ggplot2::annotate("text", x = 450, y = py(444), label = "66 \u00B0C",
                        family = serif, fontface = "bold", size = pt2mm(42), colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 452, y = py(466), label = "melting-temperature threshold",
                        family = sans, size = pt2mm(11), colour = grey_txt, hjust = 0, vjust = 0)
    
    p <- p +
      ggplot2::annotate("text", x = 450, y = py(238), label = track("ABOVE 66 \u00B0C \u00B7 HIGHER RISK"),
                        family = sans, fontface = "bold", size = pt2mm(12), colour = red_dark, hjust = 0, vjust = 0)
    
    chip <- function(xmin, xmax, ymin, ymax, fill, col) {
      place_grob(rrect(xmin, xmax, py(ymax), py(ymin), r_px = 12, fill = fill, col = col, lwd = pt2mm(1.2) * 2.13))
    }
    p <- p + chip(450, 628, 256, 380, red_chip_fl, red_chip_st)
    p <- p + chip(646, 824, 256, 380, red_chip_fl, red_chip_st)
    
    soil_dots <- data.frame(x = c(531, 540, 549), y = py(290))
    p <- p +
      ggplot2::annotate("segment", x = 523, xend = 555, y = py(284), yend = py(284),
                        colour = red_icon, linewidth = pt2mm(2) * 2.13, lineend = "round") +
      ggplot2::geom_point(data = soil_dots, ggplot2::aes(x, y), colour = red_icon, size = 1.1) +
      ggplot2::annotate("segment", x = 523, xend = 555, y = py(296), yend = py(296),
                        colour = red_icon, linewidth = pt2mm(2) * 2.13, lineend = "round") +
      ggplot2::annotate("segment", x = 527, xend = 551, y = py(303), yend = py(303),
                        colour = red_icon, linewidth = pt2mm(2) * 2.13, lineend = "round") +
      ggplot2::annotate("text", x = 539, y = py(332), label = "L. longbeachae",
                        family = sans, fontface = "bold", size = pt2mm(15.5), colour = ink, hjust = 0.5, vjust = 0) +
      ggplot2::annotate("text", x = 539, y = py(352), label = "found in soil",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0.5, vjust = 0)
    
    drop_top <- c(735, 272); drop_bot <- c(735, 296)
    drop_r1  <- bez(drop_top, c(744, 284), c(742, 296), drop_bot)
    drop_r2  <- bez(drop_bot, c(728, 296), c(726, 284), drop_top)
    drop <- rbind(drop_r1, drop_r2)
    drop$y <- py(drop$y)
    p <- p +
      ggplot2::geom_path(data = drop, ggplot2::aes(x, y), colour = red_icon, linewidth = pt2mm(2) * 2.13, lineend = "round", linejoin = "round") +
      ggplot2::annotate("text", x = 735, y = py(332), label = "L. pneumophila",
                        family = sans, fontface = "bold", size = pt2mm(15.5), colour = ink, hjust = 0.5, vjust = 0) +
      ggplot2::annotate("text", x = 735, y = py(352), label = "found in water",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0.5, vjust = 0)
    
    p <- p +
      ggplot2::annotate("text", x = 450, y = py(500), label = track("BELOW 66 \u00B0C \u00B7 LOWER RISK"),
                        family = sans, fontface = "bold", size = pt2mm(12), colour = teal_dark, hjust = 0, vjust = 0) +
      place_grob(rrect(450, 824, py(590), py(516), r_px = 12, fill = teal_chip_fl, col = teal_chip_st, lwd = pt2mm(1.2) * 2.13))
    
    ring <- function(cx, cy) circle(cx, py(cy), 5)
    p <- p +
      ggplot2::geom_path(data = ring(472, 549), ggplot2::aes(x, y), colour = teal_icon, linewidth = pt2mm(1.8) * 2.13) +
      ggplot2::geom_path(data = ring(483, 554), ggplot2::aes(x, y), colour = teal_icon, linewidth = pt2mm(1.8) * 2.13) +
      ggplot2::geom_path(data = ring(473, 559), ggplot2::aes(x, y), colour = teal_icon, linewidth = pt2mm(1.8) * 2.13) +
      ggplot2::annotate("text", x = 508, y = py(548), label = "All other species",
                        family = sans, fontface = "bold", size = pt2mm(15.5), colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 508, y = py(568), label = "Tm below the threshold",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0)
  }
  
  # =========================================================================
  # STAGE 4 — RIGHT PANEL: MODULE 3 — THE STUDY
  # =========================================================================
  if (stage >= 4) {
    
    p <- p +
      ggplot2::annotate("text", x = 884, y = py(174), label = track("THE STUDY"),
                        family = sans, fontface = "bold", size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0)
    
    p <- p +
      ggplot2::annotate("text", x = 884, y = py(256), label = "189",
                        family = serif, fontface = "bold", size = pt2mm(40), colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 992, y = py(256), label = "adults",
                        family = sans, size = pt2mm(17), colour = grey_txt, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 884, y = py(280), label = "with a recorded melting temperature (Tm)",
                        family = sans, size = pt2mm(12.5), colour = grey_txt, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 884, y = py(300), label = "Confirmed bacterial infection \u00B7 several hospitals",
                        family = sans, size = pt2mm(12), colour = grey_txt, hjust = 0, vjust = 0) +
      ggplot2::annotate("segment", x = 884, xend = 1224, y = py(318), yend = py(318), colour = grey_line, linewidth = 0.5)
    
    p <- p +
      ggplot2::annotate("text", x = 884, y = py(342), label = track("PREDICTORS"),
                        family = sans, fontface = "bold", size = pt2mm(11), colour = grey_txt, hjust = 0, vjust = 0) +
      place_grob(rrect(884, 980, py(380), py(352), r_px = 14, fill = pill_fill, col = pill_stroke, lwd = pt2mm(1) * 2.13)) +
      ggplot2::annotate("text", x = 932, y = py(370), label = "Tm group",
                        family = sans, size = pt2mm(12.5), colour = ink, hjust = 0.5, vjust = 0) +
      place_grob(rrect(988, 1174, py(380), py(352), r_px = 14, fill = pill_fill, col = pill_stroke, lwd = pt2mm(1) * 2.13)) +
      ggplot2::annotate("text", x = 1081, y = py(370), label = "age, BMI, HTN, IC",
                        family = sans, size = pt2mm(12.5), colour = ink, hjust = 0.5, vjust = 0)
    
    p <- p +
      ggplot2::annotate("text", x = 884, y = py(414), label = track("TWO OUTCOMES"),
                        family = sans, fontface = "bold", size = pt2mm(11), colour = grey_txt, hjust = 0, vjust = 0)
    
    p <- p +
      place_grob(rrect(884, 1224, py(484), py(426), r_px = 12, fill = "white", col = grey_line, lwd = pt2mm(1.2) * 2.13))
    
    icu <- function(lw = pt2mm(2) * 2.13) {
      list(
        ggplot2::annotate("segment", x = 900, xend = 924, y = py(460), yend = py(460), colour = ink, linewidth = lw, lineend = "round"),
        ggplot2::annotate("segment", x = 900, xend = 900, y = py(460), yend = py(449), colour = ink, linewidth = lw, lineend = "round"),
        ggplot2::annotate("segment", x = 902, xend = 902, y = py(460), yend = py(466), colour = ink, linewidth = lw, lineend = "round"),
        ggplot2::annotate("segment", x = 922, xend = 922, y = py(460), yend = py(466), colour = ink, linewidth = lw, lineend = "round"),
        ggplot2::annotate("segment", x = 917, xend = 917, y = py(447), yend = py(453), colour = ink, linewidth = lw, lineend = "round"),
        ggplot2::annotate("segment", x = 914, xend = 920, y = py(450), yend = py(450), colour = ink, linewidth = lw, lineend = "round")
      )
    }
    p <- p + icu() +
      ggplot2::annotate("text", x = 946, y = py(450), label = "Admitted to ICU",
                        family = sans, fontface = "bold", size = pt2mm(15), colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 946, y = py(469), label = "reached intensive care",
                        family = sans, size = pt2mm(11.5), colour = grey_txt, hjust = 0, vjust = 0) +
      place_grob(rrect(1132, 1208, py(464), py(440), r_px = 12, fill = pill_fill, col = pill_stroke, lwd = pt2mm(1) * 2.13)) +
      ggplot2::annotate("text", x = 1170, y = py(456), label = track(" "),
                        family = sans, fontface = "bold", size = pt2mm(9.5), colour = grey_txt, hjust = 0.5, vjust = 0.35)
    
    p <- p +
      place_grob(rrect(884, 1224, py(550), py(492), r_px = 12, fill = "white", col = grey_line, lwd = pt2mm(1.2) * 2.13))
    
    ekg_lw  <- pt2mm(2) * 2.13
    ekg_pts <- data.frame(
      x = c(900, 905, 908, 911, 914, 924),
      y = c(518, 518, 508, 528, 518, 518)
    )
    ekg_pts$y <- py(ekg_pts$y)
    p <- p +
      ggplot2::geom_path(data = ekg_pts, ggplot2::aes(x, y), colour = ink,
                         linewidth = ekg_lw, lineend = "round", linejoin = "round") +
      ggplot2::annotate("text", x = 946, y = py(516), label = "Death within 90 days",
                        family = sans, fontface = "bold", size = pt2mm(15), colour = ink, hjust = 0, vjust = 0) +
      ggplot2::annotate("text", x = 946, y = py(535), label = "90-day mortality",
                        family = sans, size = pt2mm(11.5), colour = grey_txt, hjust = 0, vjust = 0) +
      place_grob(rrect(1132, 1208, py(530), py(506), r_px = 12, fill = pill_fill, col = pill_stroke, lwd = pt2mm(1) * 2.13)) +
      ggplot2::annotate("text", x = 1170, y = py(522), label = track(" "),
                        family = sans, fontface = "bold", size = pt2mm(9.5), colour = grey_txt, hjust = 0.5, vjust = 0.35)
  }
  
  # ---- theme -----------------------------------------------------------
  p <- p + ggplot2::theme_void() +
    ggplot2::theme(plot.margin = ggplot2::margin(0, 0, 0, 0))
  
  p
}

plot_fig_slide_16 <- function(stage = 8) {
  
  # ---- dependency guard ---------------------------------------------------
  .pkgs <- c("ggplot2", "tibble", "gt", "ggtext", "cli")
  .missing <- .pkgs[!vapply(.pkgs, requireNamespace, logical(1), quietly = TRUE)]
  if (length(.missing) > 0L) {
    stop(
      "plot_fig_slide_16() requires the following package(s): ",
      paste(.missing, collapse = ", "),
      call. = FALSE
    )
  }
  
  # ---- Stage validation -----------------------------------------------------
  # stage controls progressive reveal, 1-8. Stage 8 (default) is the full,
  # unemphasized table. Anything outside 1-8 silently falls back to 8.
  stage_is_valid <- is.numeric(stage) && length(stage) == 1L && !is.na(stage) &&
    stage == round(stage) && stage %in% 1:8
  
  if (!stage_is_valid) {
    cli::cli_warn("{.arg stage} must be a whole number from 1 to 8; using 8 (full table).")
    stage <- 8L
  }
  stage <- as.integer(stage)
  
  # ---- Data -----------------------------------------------------------------
  # Odds ratios are numeric (formatted to 2 decimals below).
  # CI and P-value are stored as character strings so the exact decimal
  # formatting shown in the source table (e.g. "0.007" vs "0.03") is preserved.
  
  grp_mortality <- "90-Day Mortality (n = 42/189; 22.2%)"
  grp_icu       <- "Intensive Care Unit Admission (n = 69/189; 36.5%)"
  
  table5 <- tibble::tribble(
    ~outcome_group,  ~variable,                          ~uni_or, ~uni_ci,      ~uni_p,  ~multi_or, ~multi_ci,    ~multi_p,
    grp_mortality,   "Age",                               1.03,   "1.00–1.06",  "0.03",  1.04,      "1.00–1.07",  "0.03",
    grp_mortality,   "Body mass index",                   0.99,   "0.96–1.02",  "0.66",  0.99,      "0.97–1.02",  "0.66",
    grp_mortality,   "Hypertension",                      1.32,   "0.66–2.67",  "0.43",  1.34,      "0.64–2.80",  "0.43",
    grp_mortality,   "Immunocompromise",                  1.42,   "0.69–2.92",  "0.34",  1.63,      "0.77–3.45",  "0.20",
    grp_mortality,   "PCR melting temperature ≥ 66°C",    0.80,   "0.38–1.67",  "0.55",  0.77,      "0.36–1.66",  "0.51",
    grp_icu,         "Age",                               1.00,   "0.98–1.03",  "0.71",  1.00,      "0.98–1.03",  "0.82",
    grp_icu,         "Body mass index",                   1.00,   "0.99–1.02",  "0.88",  1.00,      "0.98–1.01",  "0.77",
    grp_icu,         "Hypertension",                      2.36,   "1.26–4.42",  "0.007", 2.10,      "1.09–4.03",  "0.03",
    grp_icu,         "Immunocompromise",                  0.78,   "0.43–1.42",  "0.42",  0.71,      "0.38–1.34",  "0.29",
    grp_icu,         "PCR melting temperature ≥ 66°C",    3.16,   "1.50–6.65",  "0.002", 2.85,      "1.33–6.11",  "0.007"
  )
  
  # ---- Table ------------------------------------------------------------------
  
  table5_gt <- table5 |>
    gt::gt(rowname_col = "variable", groupname_col = "outcome_group") |>
    
    # Title
    gt::tab_header(
      title = gt::md("**TABLE 5** Logistic regression for 90-day mortality and intensive care unit admission")
    ) |>
    
    # Column labels
    gt::tab_stubhead(label = "Variable") |>
    gt::cols_label(
      uni_or   = "Univariate odds ratio",
      uni_ci   = "95% CI",
      uni_p    = "P-value",
      multi_or = "Multivariable odds ratio",
      multi_ci = "95% CI",
      multi_p  = "P-value"
    ) |>
    
    # Number formatting
    gt::fmt_number(columns = c(uni_or, multi_or), decimals = 2) |>
    
    # Indent the variable rows under each row-group heading
    gt::tab_stub_indent(rows = tidyselect::everything(), indent = 1) |>
    
    # Column alignment
    gt::cols_align(align = "left", columns = c(uni_ci, multi_ci)) |>
    gt::cols_align(align = "center", columns = c(uni_or, uni_p, multi_or, multi_p)) |>
    
    # Bold column headers and stubhead label
    gt::tab_style(
      style = gt::cell_text(weight = "bold"),
      locations = list(gt::cells_column_labels(tidyselect::everything()), gt::cells_stubhead())
    ) |>
    
    # Italicize "P-value" headers (matches the source table style)
    gt::tab_style(
      style = gt::cell_text(style = "italic"),
      locations = gt::cells_column_labels(columns = c(uni_p, multi_p))
    ) |>
    
    # Row-group labels: keep them left-aligned and not bold
    gt::tab_style(
      style = gt::cell_text(weight = "normal", align = "left"),
      locations = gt::cells_row_groups()
    ) |>
    
    # Light grey fill behind the column-label row + stubhead, matching
    # the shaded header band in the source table (the "grey fill" reference)
    gt::tab_style(
      style = gt::cell_fill(color = "grey85"),
      locations = list(gt::cells_column_labels(tidyselect::everything()), gt::cells_stubhead())
    ) |>
    
    # The title renders fully bold by gt's default heading CSS, even
    # though only "TABLE 5" was wrapped in markdown bold. Force the rest of
    # the title back to normal weight so only "TABLE 5" stays bold, matching
    # the source table.
    gt::tab_style(
      style = gt::cell_text(weight = "normal"),
      locations = gt::cells_title(groups = "title")
    ) |>
    
    # Table-wide rule styling (thick top/bottom border, thin rule under header,
    # no vertical or intermediate horizontal lines)
    gt::tab_options(
      table.border.top.color = "black",
      table.border.top.width = gt::px(3),
      table.border.bottom.color = "black",
      table.border.bottom.width = gt::px(3),
      column_labels.border.top.style = "hidden",
      column_labels.border.bottom.color = "black",
      column_labels.border.bottom.width = gt::px(2),
      row_group.border.top.style = "hidden",
      row_group.border.bottom.style = "hidden",
      table_body.hlines.color = "transparent",
      table_body.border.bottom.color = "black",
      table_body.border.bottom.width = gt::px(0),
      # gt draws a grey vertical rule between the stub column and the
      # body by default. The source table has no such rule, so hide it.
      stub.border.style = "hidden",
      heading.align = "left",
      heading.border.bottom.style = "hidden",
      data_row.padding = gt::px(4),
      table.font.size = gt::px(14)
    ) |>
    
    # Table-wide source note citing the reference for the PCR melting
    # temperature analysis used as a predictor in this table. DOI is rendered
    # as a clickable link via gt::md().
    gt::tab_source_note(
      source_note = gt::md(
        "Pulsipher AM, Khattar G, Harris E, White V, Stout C, Vikram HR, Patel R, Simner PJ. 2026. Legionella 5S rRNA PCR melting temperature analysis discriminates high-risk species associated with disease severity. *J Clin Microbiol* 64:e00356-26. [https://doi.org/10.1128/jcm.00356-26](https://doi.org/10.1128/jcm.00356-26)"
      )
    )
  
  # ---- Progressive reveal (stage-specific emphasis) --------------------------
  # Stages 2-3 fade (dim) the row-group that is not currently in focus, but
  # keep all rows in place so the table height never changes.
  # Stages 4-7 walk a bold highlight across the stub, then each OR column,
  # then the paired CI/P-value columns, with no carry-over between stages.
  # Stages 1 and 8 are both the plain, fully-styled table above.
  
  fade_color <- "grey70"
  
  fade_group <- function(gt_tbl, group_value) {
    gt_tbl |>
      gt::tab_style(
        style = gt::cell_text(color = fade_color),
        locations = list(
          gt::cells_body(rows = outcome_group == group_value),
          gt::cells_stub(rows = outcome_group == group_value),
          gt::cells_row_groups(groups = group_value)
        )
      )
  }
  
  bold_stub <- function(gt_tbl) {
    gt_tbl |>
      gt::tab_style(
        style = gt::cell_text(weight = "bold"),
        locations = gt::cells_stub(rows = tidyselect::everything())
      )
  }
  
  bold_cols <- function(gt_tbl, cols) {
    gt_tbl |>
      gt::tab_style(
        style = gt::cell_text(weight = "bold"),
        locations = gt::cells_body(columns = tidyselect::all_of(cols), rows = tidyselect::everything())
      )
  }
  
  table5_gt <- switch(
    as.character(stage),
    "1" = table5_gt,
    "2" = table5_gt |> fade_group(grp_icu),
    "3" = table5_gt |> fade_group(grp_mortality),
    "4" = table5_gt |> bold_stub(),
    "5" = table5_gt |> bold_cols("uni_or"),
    "6" = table5_gt |> bold_cols("multi_or"),
    "7" = table5_gt |> bold_cols(c("uni_ci", "uni_p", "multi_ci", "multi_p")),
    "8" = table5_gt
  )
  
  # Print / view the table
  table5_gt
}

f_forest <- function() {
  
  table5 <- tibble::tribble(
    ~outcome_group,                     ~variable,                          ~uni_or, ~uni_ci,      ~uni_p,  ~multi_or, ~multi_ci,    ~multi_p,
    "90-Day Mortality",                 "Age",                               1.03,   "1.00-1.06",  "0.03",  1.04,      "1.00-1.07",  "0.03",
    "90-Day Mortality",                 "Body mass index",                   0.99,   "0.96-1.02",  "0.66",  0.99,      "0.97-1.02",  "0.66",
    "90-Day Mortality",                 "Hypertension",                      1.32,   "0.66-2.67",  "0.43",  1.34,      "0.64-2.80",  "0.43",
    "90-Day Mortality",                 "Immunocompromise",                  1.42,   "0.69-2.92",  "0.34",  1.63,      "0.77-3.45",  "0.20",
    "90-Day Mortality",                 "PCR melting temperature \u2265 66\u00b0C",    0.80,   "0.38-1.67",  "0.55",  0.77,      "0.36-1.66",  "0.51",
    "Intensive Care Unit Admission",    "Age",                               1.00,   "0.98-1.03",  "0.71",  1.00,      "0.98-1.03",  "0.82",
    "Intensive Care Unit Admission",    "Body mass index",                   1.00,   "0.99-1.02",  "0.88",  1.00,      "0.98-1.01",  "0.77",
    "Intensive Care Unit Admission",    "Hypertension",                      2.36,   "1.26-4.42",  "0.007", 2.10,      "1.09-4.03",  "0.03",
    "Intensive Care Unit Admission",    "Immunocompromise",                  0.78,   "0.43-1.42",  "0.42",  0.71,      "0.38-1.34",  "0.29",
    "Intensive Care Unit Admission",    "PCR melting temperature \u2265 66\u00b0C",    3.16,   "1.50-6.65",  "0.002", 2.85,      "1.33-6.11",  "0.007"
  ) |>
    dplyr::mutate(uni_p = as.double(uni_p)) |>
    dplyr::mutate(multi_p = as.double(multi_p)) |>
    dplyr::mutate(uni_sig = ifelse(uni_p <= 0.05, "significant", "not")) |>
    dplyr::mutate(multi_sig = ifelse(multi_p <= 0.05, "significant", "not")) |>
    dplyr::mutate(uni_lb = as.double(stringr::str_replace(uni_ci, "\\-.+", ""))) |>
    dplyr::mutate(uni_ub = as.double(stringr::str_replace(uni_ci, ".+\\-", ""))) |>
    dplyr::mutate(multi_lb = as.double(stringr::str_replace(multi_ci, "\\-.+", ""))) |>
    dplyr::mutate(multi_ub = as.double(stringr::str_replace(multi_ci, ".+\\-", ""))) |>
    dplyr::select(-uni_ci, -multi_ci)
  
  table5_long <- dplyr::bind_rows(
    table5 |>
      dplyr::select(outcome_group, variable, or = uni_or, p = uni_p, sig = uni_sig, lb = uni_lb, ub = uni_ub) |>
      dplyr::mutate(type = "unadjusted"),
    table5 |>
      dplyr::select(outcome_group, variable, or = multi_or, p = multi_p, sig = multi_sig, lb = multi_lb, ub = multi_ub) |>
      dplyr::mutate(type = "adjusted")
  ) |>
    dplyr::mutate(type = factor(type, levels = c("unadjusted", "adjusted"), labels = c("Unadjusted", "Adjusted"))) |>
    dplyr::mutate(variable = forcats::fct_rev(forcats::fct_inorder(variable)))
  
  # ------------------------------------------------------------
  # Shared publication styling
  # ------------------------------------------------------------
  
  # Okabe-Ito palette — colorblind-safe
  sig_pal <- c(not = "#999999", significant = "#0072B2")
  sig_labels <- c(not = "Not significant", significant = "Significant (p \u2264 0.05)")
  
  theme_journal <- function(base_size = 11, base_family = "sans") {
    ggplot2::theme_classic(base_size = base_size, base_family = base_family) +
      ggplot2::theme(
        strip.background   = ggplot2::element_rect(fill = "grey92", colour = NA),
        strip.text         = ggplot2::element_text(face = "bold", size = ggplot2::rel(0.85), margin = ggplot2::margin(4, 4, 4, 4)),
        axis.title         = ggplot2::element_text(face = "bold", size = ggplot2::rel(0.95)),
        axis.text          = ggplot2::element_text(colour = "black", size = ggplot2::rel(0.85)),
        axis.line          = ggplot2::element_line(linewidth = 0.4, colour = "black"),
        axis.ticks         = ggplot2::element_line(linewidth = 0.4, colour = "black"),
        panel.spacing      = grid::unit(0.6, "lines"),
        panel.grid.major.x = ggplot2::element_line(colour = "grey90", linewidth = 0.3),
        panel.grid.major.y = ggplot2::element_blank(),
        panel.grid.minor   = ggplot2::element_blank(),
        legend.position    = "bottom",
        legend.title       = ggplot2::element_blank(),
        legend.text        = ggplot2::element_text(size = ggplot2::rel(0.85)),
        plot.title         = ggplot2::element_text(face = "bold", size = ggplot2::rel(1.1), hjust = 0),
        plot.subtitle      = ggplot2::element_text(colour = "grey30", size = ggplot2::rel(0.9), hjust = 0),
        plot.caption       = ggplot2::element_text(colour = "grey40", size = ggplot2::rel(0.75), hjust = 0, margin = ggplot2::margin(t = 10))
      )
  }
  
  # ------------------------------------------------------------
  # Forest plot — the conventional choice for OR / 95% CI data,
  # since the odds-ratio scale is multiplicative and has no
  # meaningful zero (a log axis keeps OR = 2 and OR = 0.5
  # visually equidistant from OR = 1)
  # ------------------------------------------------------------
  
  forest_plot <- table5_long |>
    ggplot2::ggplot(ggplot2::aes(x = variable, y = or, colour = sig)) +
    ggplot2::geom_hline(yintercept = 1, linetype = "dashed", colour = "grey40", linewidth = 0.4) +
    ggplot2::geom_errorbar(ggplot2::aes(ymin = lb, ymax = ub), width = 0.2, linewidth = 0.5) +
    ggplot2::geom_point(size = 2.8) +
    ggplot2::coord_flip() +
    ggplot2::scale_y_log10(breaks = c(0.25, 0.5, 1, 2, 4, 8)) +
    ggplot2::scale_colour_manual(values = sig_pal, labels = sig_labels) +
    ggplot2::facet_grid(type ~ outcome_group) +
    ggplot2::labs(
      x = NULL,
      y = "Odds ratio (log scale)",
      caption = "Dashed line indicates OR = 1.
      
      Pulsipher AM, Khattar G, Harris E, White V, Stout C, Vikram HR, 
      Patel R, Simner PJ. 2026. Legionella 5S rRNA PCR melting temperature 
      analysis discriminates high-risk species associated with disease severity. 
      J Clin Microbiol 64:e00356-26.https://doi.org/10.1128/jcm.00356-26
      "
    ) +
    theme_journal()
  
  forest_plot
  
}
