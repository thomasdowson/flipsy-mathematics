# ==============================================================================
# FLIPSY Mathematics
# 04_gf2_linear_algebra.R
#
# Linear algebra over the finite field F_2 = {0, 1}.
#
# All arithmetic is modulo 2.
# ==============================================================================


# ------------------------------------------------------------------------------
# Row reduction over F_2
# ------------------------------------------------------------------------------

gf2_rref <- function(A) {
  
  A <- A %% 2L
  
  nr <- nrow(A)
  nc <- ncol(A)
  
  pivot_row <- 1L
  pivot_cols <- integer(0)
  
  for (col in seq_len(nc)) {
    
    # Find a pivot
    candidates <- which(A[pivot_row:nr, col] == 1L)
    
    if (length(candidates) == 0L) {
      next
    }
    
    pivot <- candidates[1] + pivot_row - 1L
    
    # Swap pivot into position
    if (pivot != pivot_row) {
      
      temp <- A[pivot_row, ]
      A[pivot_row, ] <- A[pivot, ]
      A[pivot, ] <- temp
    }
    
    # Eliminate this column from every other row
    other_rows <- which(A[, col] == 1L)
    other_rows <- setdiff(other_rows, pivot_row)
    
    if (length(other_rows) > 0L) {
      
      for (r in other_rows) {
        A[r, ] <- (A[r, ] + A[pivot_row, ]) %% 2L
      }
    }
    
    pivot_cols <- c(pivot_cols, col)
    
    pivot_row <- pivot_row + 1L
    
    if (pivot_row > nr) {
      break
    }
  }
  
  list(
    matrix = A,
    pivot_cols = pivot_cols,
    rank = length(pivot_cols)
  )
}


# ------------------------------------------------------------------------------
# Rank over F_2
# ------------------------------------------------------------------------------

gf2_rank <- function(A) {
  gf2_rref(A)$rank
}


# ------------------------------------------------------------------------------
# Nullity over F_2
# ------------------------------------------------------------------------------

gf2_nullity <- function(A) {
  ncol(A) - gf2_rank(A)
}


# ------------------------------------------------------------------------------
# Is the transformation invertible?
# ------------------------------------------------------------------------------

gf2_is_invertible <- function(A) {
  
  if (nrow(A) != ncol(A)) {
    return(FALSE)
  }
  
  gf2_rank(A) == nrow(A)
}