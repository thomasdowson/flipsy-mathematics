# ==============================================================================
# FLIPSY Mathematics
# 18_affine_code_bound.R
#
# Linear-code formulation of the rank-9 minimum-weight problem.
#
# Fix four directions and require every affine line in those directions
# to contain an odd number of selected points.
#
# This gives an affine system
#
#     H x = 1
#
# over F_2.
#
# We determine the complete solution space and its minimum Hamming weight.
# ==============================================================================

source("R/04_gf2_linear_algebra.R")
source("R/17_near_miss_geometry.R")


# ------------------------------------------------------------------------------
# Construct parity-check equations for selected directions
# ------------------------------------------------------------------------------

build_odd_direction_system <- function(
    direction_ids,
    n = 5
) {
  
  if (length(unique(direction_ids)) != length(direction_ids)) {
    stop("direction_ids must be distinct.")
  }
  
  H <- matrix(
    0L,
    nrow = length(direction_ids) * n,
    ncol = n^2
  )
  
  row_counter <- 1L
  
  for (d in direction_ids) {
    
    for (line_id in 1:n) {
      
      cells_on_line <- which(
        line_labels[, d] == line_id
      )
      
      H[
        row_counter,
        cells_on_line
      ] <- 1L
      
      row_counter <- row_counter + 1L
    }
  }
  
  b <- rep(
    1L,
    nrow(H)
  )
  
  list(
    H = H,
    b = b
  )
}


# ------------------------------------------------------------------------------
# Solve an affine linear system A x = b over F_2
#
# Returns:
#   - one particular solution;
#   - a basis for the homogeneous nullspace;
#   - affine dimension.
# ------------------------------------------------------------------------------

gf2_affine_solution_space <- function(A, b) {
  
  A <- A %% 2L
  b <- as.integer(b %% 2L)
  
  if (nrow(A) != length(b)) {
    stop("Length of b must equal nrow(A).")
  }
  
  n_variables <- ncol(A)
  
  augmented <- cbind(
    A,
    b
  )
  
  reduced <- gf2_rref(
    augmented
  )
  
  R <- reduced$matrix
  
  # Check for inconsistency:
  #
  # 0 ... 0 | 1
  inconsistent <- apply(
    R,
    1,
    function(row) {
      all(row[1:n_variables] == 0L) &&
        row[n_variables + 1L] == 1L
    }
  )
  
  if (any(inconsistent)) {
    return(
      list(
        consistent = FALSE
      )
    )
  }
  
  # Pivot columns belonging to the actual variables
  pivot_cols <- reduced$pivot_cols[
    reduced$pivot_cols <= n_variables
  ]
  
  free_cols <- setdiff(
    seq_len(n_variables),
    pivot_cols
  )
  
  # Particular solution: set every free variable to zero
  particular <- integer(
    n_variables
  )
  
  for (i in seq_along(pivot_cols)) {
    
    pivot_col <- pivot_cols[i]
    
    particular[pivot_col] <-
      R[i, n_variables + 1L]
  }
  
  # Nullspace basis
  basis <- matrix(
    0L,
    nrow = n_variables,
    ncol = length(free_cols)
  )
  
  if (length(free_cols) > 0L) {
    
    for (j in seq_along(free_cols)) {
      
      free_col <- free_cols[j]
      
      basis[
        free_col,
        j
      ] <- 1L
      
      for (i in seq_along(pivot_cols)) {
        
        pivot_col <- pivot_cols[i]
        
        basis[
          pivot_col,
          j
        ] <- R[i, free_col]
      }
    }
  }
  
  list(
    consistent = TRUE,
    particular = particular,
    basis = basis,
    pivot_cols = pivot_cols,
    free_cols = free_cols,
    affine_dimension = length(free_cols)
  )
}


# ------------------------------------------------------------------------------
# Enumerate every vector in a small affine solution space
# ------------------------------------------------------------------------------

enumerate_affine_space <- function(solution) {
  
  if (!solution$consistent) {
    stop("System is inconsistent.")
  }
  
  d <- solution$affine_dimension
  
  total <- 2^d
  
  solutions <- matrix(
    0L,
    nrow = total,
    ncol = length(solution$particular)
  )
  
  for (mask in 0:(total - 1L)) {
    
    x <- solution$particular
    
    if (d > 0L) {
      
      for (j in seq_len(d)) {
        
        if (
          bitwAnd(
            mask,
            bitwShiftL(1L, j - 1L)
          ) != 0L
        ) {
          
          x <- (
            x +
              solution$basis[, j]
          ) %% 2L
        }
      }
    }
    
    solutions[
      mask + 1L,
    ] <- x
  }
  
  solutions
}


# ------------------------------------------------------------------------------
# Analyse the weight distribution
# ------------------------------------------------------------------------------

affine_weight_distribution <- function(solutions) {
  
  weights <- rowSums(
    solutions
  )
  
  counts <- table(
    weights
  )
  
  data.frame(
    weight = as.integer(
      names(counts)
    ),
    count = as.integer(
      counts
    )
  )
}