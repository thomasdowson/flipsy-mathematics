# ==============================================================================
# FLIPSY Mathematics
# 12_fast_gf2_search.R
#
# Faster rank calculations for exhaustive FLIPSY searches.
#
# Goal:
#   Avoid repeated construction of data.frames and n x n move matrices.
#
# IMPORTANT:
#   This implementation must be validated against the original engine before
#   being used for mathematical results.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/03_move_matrix.R")
source("R/04_gf2_linear_algebra.R")


# ------------------------------------------------------------------------------
# Convert coordinates directly to a binary vector
# ------------------------------------------------------------------------------

shape_to_vector <- function(shape, n = 5) {
  
  v <- integer(n^2)
  
  # Wrap shape offsets onto Z_n x Z_n
  rows <- shape$row %% n
  cols <- shape$col %% n
  
  indices <- rows * n + cols + 1L
  
  # If multiple offsets wrap to the same cell, they cancel over F_2
  counts <- table(indices)
  
  surviving <- as.integer(
    names(counts[counts %% 2L == 1L])
  )
  
  if (length(surviving) > 0L) {
    v[surviving] <- 1L
  }
  
  v
}


# ------------------------------------------------------------------------------
# Translate a binary shape vector
# ------------------------------------------------------------------------------

translate_vector <- function(v, row_shift, col_shift, n = 5) {
  
  result <- integer(n^2)
  
  active <- which(v == 1L) - 1L
  
  rows <- active %/% n
  cols <- active %% n
  
  new_rows <- (rows + row_shift) %% n
  new_cols <- (cols + col_shift) %% n
  
  new_indices <- new_rows * n + new_cols + 1L
  
  result[new_indices] <- 1L
  
  result
}


# ------------------------------------------------------------------------------
# Fast move-matrix construction
# ------------------------------------------------------------------------------

fast_move_matrix <- function(shape, n = 5) {
  
  base <- shape_to_vector(shape, n)
  
  A <- matrix(
    0L,
    nrow = n^2,
    ncol = n^2
  )
  
  j <- 1L
  
  for (row in 0:(n - 1)) {
    
    for (col in 0:(n - 1)) {
      
      A[, j] <- translate_vector(
        base,
        row_shift = row,
        col_shift = col,
        n = n
      )
      
      j <- j + 1L
    }
  }
  
  A
}


# ------------------------------------------------------------------------------
# Fast rank wrapper
# ------------------------------------------------------------------------------

fast_shape_rank <- function(shape, n = 5) {
  
  A <- fast_move_matrix(shape, n)
  
  gf2_rank(A)
}


# ------------------------------------------------------------------------------
# Search all shapes of a fixed cardinality
# ------------------------------------------------------------------------------

fast_find_shape_with_rank <- function(
    k,
    target_rank = 9,
    n = 5,
    progress_every = 50000
) {
  
  cells <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  others <- cells[
    !(cells$row == 0 & cells$col == 0),
    c("row", "col")
  ]
  
  if (k == 1) {
    
    shape <- make_shape(rbind(c(0, 0)))
    
    if (fast_shape_rank(shape, n) == target_rank) {
      return(shape)
    }
    
    return(NULL)
  }
  
  combinations <- combn(
    seq_len(nrow(others)),
    k - 1
  )
  
  total <- ncol(combinations)
  
  cat(
    "\nFAST SEARCH:",
    total,
    "shapes of size",
    k,
    "for rank",
    target_rank,
    "\n"
  )
  
  for (j in seq_len(total)) {
    
    if (
      progress_every > 0 &&
      j %% progress_every == 0
    ) {
      
      cat(
        "Checked",
        j,
        "of",
        total,
        "\n"
      )
    }
    
    coords <- rbind(
      c(0, 0),
      as.matrix(
        others[
          combinations[, j],
          c("row", "col")
        ]
      )
    )
    
    shape <- make_shape(coords)
    
    r <- fast_shape_rank(shape, n)
    
    if (r == target_rank) {
      
      cat(
        "\nFOUND rank",
        target_rank,
        "shape at index",
        j,
        "\n"
      )
      
      return(shape)
    }
  }
  
  cat(
    "\nNo rank",
    target_rank,
    "shape found at size",
    k,
    "\n"
  )
  
  NULL
}

# ------------------------------------------------------------------------------
# Collect all shapes of fixed cardinality having a target rank
# ------------------------------------------------------------------------------

fast_collect_shapes_with_rank <- function(
    k,
    target_rank = 9,
    n = 5,
    progress_every = 100000
) {
  
  cells <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  others <- cells[
    !(cells$row == 0 & cells$col == 0),
    c("row", "col")
  ]
  
  combinations <- combn(
    seq_len(nrow(others)),
    k - 1
  )
  
  total <- ncol(combinations)
  
  hits <- list()
  hit_count <- 0L
  
  cat(
    "\nCOLLECTING:",
    total,
    "shapes of size",
    k,
    "with rank",
    target_rank,
    "\n"
  )
  
  for (j in seq_len(total)) {
    
    if (
      progress_every > 0 &&
      j %% progress_every == 0
    ) {
      
      cat(
        "Checked",
        j,
        "of",
        total,
        "- hits:",
        hit_count,
        "\n"
      )
    }
    
    coords <- rbind(
      c(0, 0),
      as.matrix(
        others[
          combinations[, j],
          c("row", "col")
        ]
      )
    )
    
    shape <- make_shape(coords)
    
    if (fast_shape_rank(shape, n) == target_rank) {
      
      hit_count <- hit_count + 1L
      
      hits[[hit_count]] <- list(
        shape_id = j,
        shape = shape
      )
    }
  }
  
  cat(
    "\nFinished.",
    hit_count,
    "rank",
    target_rank,
    "shapes found.\n"
  )
  
  hits
}