# ==============================================================================
# FLIPSY Mathematics
# 11_rank9_search.R
#
# Search for an explicit FLIPSY move shape on Z_5^2 having rank 9.
#
# The rank decomposition for odd-cardinality shapes permits ranks
#
#     1, 5, 9, 13, 17, 21, 25.
#
# Rank 9 has not yet been observed computationally.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/03_move_matrix.R")
source("R/04_gf2_linear_algebra.R")


# ------------------------------------------------------------------------------
# Generate one shape from a combination of non-origin cells
# ------------------------------------------------------------------------------

shape_from_indices <- function(indices, cells) {
  
  coords <- rbind(
    c(0, 0),
    as.matrix(cells[indices, c("row", "col")])
  )
  
  make_shape(coords)
}


# ------------------------------------------------------------------------------
# Search all shapes of fixed cardinality for a target rank
# ------------------------------------------------------------------------------

find_shape_with_rank <- function(
    k,
    target_rank = 9,
    n = 5,
    progress_every = 10000
) {
  
  if (k < 1 || k > n^2) {
    stop("k must lie between 1 and n^2.")
  }
  
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
    r <- gf2_rank(move_matrix(shape, n))
    
    if (r == target_rank) {
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
    "\nSearching",
    total,
    "shapes of size",
    k,
    "for rank",
    target_rank,
    "...\n"
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
    
    shape <- shape_from_indices(
      combinations[, j],
      others
    )
    
    r <- gf2_rank(
      move_matrix(shape, n)
    )
    
    if (r == target_rank) {
      
      cat(
        "\nFound rank",
        target_rank,
        "shape at index",
        j,
        "\n"
      )
      
      return(shape)
    }
  }
  
  cat(
    "No rank",
    target_rank,
    "shape found at size",
    k,
    "\n"
  )
  
  NULL
}