# ==============================================================================
# FLIPSY Mathematics
# 09_conjecture_tests.R
#
# Computational tests of mathematical conjectures about FLIPSY.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/03_move_matrix.R")
source("R/04_gf2_linear_algebra.R")


# ------------------------------------------------------------------------------
# Generate all shapes of a given size containing (0, 0)
# ------------------------------------------------------------------------------

generate_shapes_of_size <- function(k, n = 5) {
  
  if (k < 1 || k > n^2) {
    stop("k must lie between 1 and n^2.")
  }
  
  # All cells on Z_n x Z_n
  cells <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  # Remove the required start cell (0, 0)
  others <- cells[
    !(cells$row == 0 & cells$col == 0),
  ]
  
  # k = 1 has only one possible shape
  if (k == 1) {
    return(list(
      make_shape(rbind(c(0, 0)))
    ))
  }
  
  combinations <- combn(
    seq_len(nrow(others)),
    k - 1,
    simplify = FALSE
  )
  
  lapply(combinations, function(idx) {
    
    coords <- rbind(
      c(0, 0),
      as.matrix(others[idx, c("row", "col")])
    )
    
    make_shape(coords)
  })
}


# ------------------------------------------------------------------------------
# Test all shapes of a given size
# ------------------------------------------------------------------------------

test_shapes_of_size <- function(k, n = 5) {
  
  shapes <- generate_shapes_of_size(k, n)
  
  cat(
    "\nTesting",
    length(shapes),
    "shapes of size",
    k,
    "on",
    paste0(n, "x", n),
    "board...\n"
  )
  
  results <- vector("list", length(shapes))
  
  for (i in seq_along(shapes)) {
    
    shape <- shapes[[i]]
    
    A <- move_matrix(shape, n)
    
    rank <- gf2_rank(A)
    
    results[[i]] <- data.frame(
      shape_id = i,
      size = k,
      rank = rank,
      nullity = n^2 - rank,
      invertible = rank == n^2
    )
  }
  
  do.call(rbind, results)
}


# ------------------------------------------------------------------------------
# Find first odd-sized counterexample
# ------------------------------------------------------------------------------

find_odd_counterexample <- function(
    sizes = c(1, 3, 5),
    n = 5
) {
  
  for (k in sizes) {
    
    if (k %% 2 == 0) {
      next
    }
    
    results <- test_shapes_of_size(k, n)
    
    bad <- results[!results$invertible, ]
    
    cat(
      "Invertible:",
      sum(results$invertible),
      "/",
      nrow(results),
      "\n"
    )
    
    if (nrow(bad) > 0) {
      
      first_id <- bad$shape_id[1]
      
      shapes <- generate_shapes_of_size(k, n)
      
      return(list(
        result = bad[1, ],
        shape = shapes[[first_id]],
        all_results = results
      ))
    }
  }
  
  NULL
}