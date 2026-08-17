# ==============================================================================
# FLIPSY Mathematics
# 15_affine_geometry.R
#
# Affine-geometric structure of move sets in AG(2,5).
#
# We study intersections of a shape with the 30 affine lines:
# six directions, five parallel lines per direction.
# ==============================================================================

source("R/01_shape_representation.R")


# ------------------------------------------------------------------------------
# Six projective directions in F_5^2
# ------------------------------------------------------------------------------

affine_directions <- function() {
  
  list(
    c(1, 0),
    c(0, 1),
    c(1, 1),
    c(1, 2),
    c(1, 3),
    c(1, 4)
  )
}


# ------------------------------------------------------------------------------
# Generate one affine line
#
# L = base + t * direction, t in F_5
# ------------------------------------------------------------------------------

affine_line <- function(
    base,
    direction,
    n = 5
) {
  
  t <- 0:(n - 1)
  
  data.frame(
    row = (base[1] + t * direction[1]) %% n,
    col = (base[2] + t * direction[2]) %% n
  )
}


# ------------------------------------------------------------------------------
# Generate the five distinct parallel lines for a direction
# ------------------------------------------------------------------------------

parallel_class <- function(direction, n = 5) {
  
  all_points <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  lines <- list()
  seen <- character(0)
  
  for (i in seq_len(nrow(all_points))) {
    
    base <- c(
      all_points$row[i],
      all_points$col[i]
    )
    
    line <- affine_line(
      base,
      direction,
      n
    )
    
    line <- line[
      order(line$row, line$col),
    ]
    
    key <- paste(
      paste(line$row, line$col, sep = ","),
      collapse = ";"
    )
    
    if (!(key %in% seen)) {
      
      lines[[length(lines) + 1L]] <- line
      seen <- c(seen, key)
    }
  }
  
  lines
}


# ------------------------------------------------------------------------------
# Number of points of a shape lying on a line
# ------------------------------------------------------------------------------

line_intersection_size <- function(shape, line) {
  
  shape_keys <- paste(
    shape$row %% 5,
    shape$col %% 5,
    sep = ","
  )
  
  line_keys <- paste(
    line$row %% 5,
    line$col %% 5,
    sep = ","
  )
  
  sum(line_keys %in% shape_keys)
}


# ------------------------------------------------------------------------------
# Intersection profile for one direction
# ------------------------------------------------------------------------------

direction_profile <- function(
    shape,
    direction,
    n = 5
) {
  
  lines <- parallel_class(
    direction,
    n
  )
  
  counts <- vapply(
    lines,
    function(L) {
      line_intersection_size(
        shape,
        L
      )
    },
    integer(1)
  )
  
  sort(
    counts,
    decreasing = TRUE
  )
}


# ------------------------------------------------------------------------------
# All six direction profiles
# ------------------------------------------------------------------------------

affine_profile <- function(shape, n = 5) {
  
  directions <- affine_directions()
  
  profiles <- lapply(
    directions,
    function(d) {
      direction_profile(
        shape,
        d,
        n
      )
    }
  )
  
  result <- do.call(
    rbind,
    profiles
  )
  
  rownames(result) <- paste0(
    "direction_",
    seq_along(directions)
  )
  
  colnames(result) <- paste0(
    "line_",
    1:5
  )
  
  result
}


# ------------------------------------------------------------------------------
# Canonical affine intersection signature
#
# Since GL(2,5) permutes the six directions, sort the six profiles.
# ------------------------------------------------------------------------------

affine_profile_key <- function(shape, n = 5) {
  
  profile <- affine_profile(
    shape,
    n
  )
  
  row_keys <- apply(
    profile,
    1,
    paste,
    collapse = "-"
  )
  
  paste(
    sort(row_keys),
    collapse = "|"
  )
}