# ==============================================================================
# FLIPSY Mathematics
# 10_rank_structure.R
#
# Investigation of rank structure for FLIPSY move sets on the 5x5 torus.
#
# Main conjecture:
#
# For an odd-cardinality move set S on Z_5^2,
#
#       rank(A_S) ≡ 1 (mod 4).
#
# We also investigate which ranks are attainable and the geometric
# structure of shapes producing each rank.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/03_move_matrix.R")
source("R/04_gf2_linear_algebra.R")
source("R/09_conjecture_tests.R")


# ------------------------------------------------------------------------------
# Summarise ranks for a collection of results
# ------------------------------------------------------------------------------

rank_summary <- function(results) {
  
  counts <- table(results$rank)
  
  data.frame(
    rank = as.integer(names(counts)),
    nullity = 25L - as.integer(names(counts)),
    count = as.integer(counts),
    rank_mod_4 = as.integer(names(counts)) %% 4L
  )
}


# ------------------------------------------------------------------------------
# Test rank congruence
# ------------------------------------------------------------------------------

test_rank_congruence <- function(results, modulus = 4L, remainder = 1L) {
  
  bad <- results[
    results$rank %% modulus != remainder,
  ]
  
  list(
    holds = nrow(bad) == 0L,
    counterexamples = bad
  )
}


# ------------------------------------------------------------------------------
# Extract shapes having a specified rank
# ------------------------------------------------------------------------------

get_shapes_by_rank <- function(shapes, results, target_rank) {
  
  ids <- results$shape_id[
    results$rank == target_rank
  ]
  
  shapes[ids]
}


# ------------------------------------------------------------------------------
# Five-cell classification
# ------------------------------------------------------------------------------

results5 <- experiment_2$all_results
shapes5 <- generate_shapes_of_size(5, n = 5)

summary5 <- rank_summary(results5)

congruence5 <- test_rank_congruence(results5)

rank5_shapes <- get_shapes_by_rank(
  shapes5,
  results5,
  target_rank = 5
)

rank17_shapes <- get_shapes_by_rank(
  shapes5,
  results5,
  target_rank = 17
)

rank21_shapes <- get_shapes_by_rank(
  shapes5,
  results5,
  target_rank = 21
)

rank25_shapes <- get_shapes_by_rank(
  shapes5,
  results5,
  target_rank = 25
)

# ------------------------------------------------------------------------------
# Random odd-cardinality shape experiment
# ------------------------------------------------------------------------------

random_shape <- function(k, n = 5) {
  
  if (k < 1 || k > n^2) {
    stop("k must lie between 1 and n^2.")
  }
  
  cells <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  others <- cells[
    !(cells$row == 0 & cells$col == 0),
  ]
  
  if (k == 1) {
    return(make_shape(rbind(c(0, 0))))
  }
  
  selected <- sample(
    seq_len(nrow(others)),
    k - 1
  )
  
  make_shape(
    rbind(
      c(0, 0),
      as.matrix(others[selected, c("row", "col")])
    )
  )
}


sample_rank_structure <- function(
    samples_per_size = 1000,
    n = 5,
    seed = 2026
) {
  
  set.seed(seed)
  
  odd_sizes <- seq(1, n^2, by = 2)
  
  results <- list()
  counter <- 1L
  
  for (k in odd_sizes) {
    
    cat("Sampling size", k, "...\n")
    
    for (i in seq_len(samples_per_size)) {
      
      shape <- random_shape(k, n)
      
      A <- move_matrix(shape, n)
      
      r <- gf2_rank(A)
      
      results[[counter]] <- data.frame(
        size = k,
        sample = i,
        rank = r,
        nullity = n^2 - r,
        rank_mod_4 = r %% 4L
      )
      
      counter <- counter + 1L
    }
  }
  
  do.call(rbind, results)
}