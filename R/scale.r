# Continuous scales ----------------------------------------------------------

train_continuous <- function(new, existing = NULL) {
  if (!is.numeric(new)) {
    stop("Discrete value supplied to continuous scale",  call. = FALSE)
  }
  range(existing, new, na.rm = TRUE, finite = TRUE)
}

map_continuous <- function(palette, x, limits, na.value = NA) {
  x <- rescale(x, from = limits)
  pal <- palette(x)
  ifelse(!is.na(x), pal, na.value)
}

#' Continuous scale
#'
#' @param x vector of continuous values to scale
#' @param palette aesthetic palette to use
#' @export
#' @examples
#' with(mtcars, plot(disp, mpg, cex = cscale(hp, size_pal())))
#' with(mtcars, plot(disp, mpg, cex = cscale(hp, area_pal())))
#' with(mtcars, plot(disp, mpg, pch = 20, cex = 5, 
#'   col = cscale(hp, seq_gradient_pal("grey80", "black"))))
cscale <- function(x, palette) {
  limits <- train_continuous(x)
  map_continuous(palette, x, limits)
}

# Discrete scales ------------------------------------------------------------

train_discrete <- function(new, existing = NULL) {
  if (!is.discrete(new)) {
    stop("Continuous value supplied to discrete scale", call. = FALSE) 
  }
  discrete_range(existing, new)
}

discrete_range <- function(..., drop = FALSE) {
  levels <- lapply(list(...), clevels, drop = drop)

  all <- unique(unlist(levels))
  if (is.numeric(all)) {
    all <- all[order(all)]
    all <- as.character(all)
  }
  
  all
}

clevels <- function(x, drop = FALSE) {
  if (is.null(x)) return(character())
  
  if (is.factor(x)) {
    if (drop) x <- factor(x)
    values <- levels(x)
  } else if (is.numeric(x)) {
    values <- unique(x)
  } else {
    values <- as.character(unique(x)) 
  }
  if (any(is.na(x))) values <- c(values, NA)
  values
}

map_discrete <- function(palette, x, limits, na.value = NA) {
  n <- length(limits)
  pal <- palette(n)[match(as.character(x), limits)]
  ifelse(!is.na(x), pal, na.value)
}

#' Discrete scale
#'
#' @param x vector of discrete values to scale
#' @param palette aesthetic palette to use
#' @export
#' @examples
#' with(mtcars, plot(disp, mpg, pch = 20, cex = 3,
#'   col = dscale(factor(cyl), brewer_pal())))
dscale <- function(x, palette) {
  limits <- train_discrete(x)
  map_discrete(palette, x, limits)
}
