# ==============================================================================
# FLIPSY Mathematics
# 03_move_matrix.R
#
# Construction of the move matrix A_S for a FLIPSY shape.
#
# Each column represents one possible click.
# Each row represents one board cell.
#
# A[row, col] = 1 if that click flips that cell.
#
# Arithmetic is ultimately performed over F_2.
# ==============================================================================


# ------------------------------------------------------------------------------
# Convert board coordinates to vector index
# ------------------------------------------------------------------------------

cell_index <- function(row, col, n = 5) {
  
  if (row < 0 || row >= n || col < 0 || col >= n) {
    stop("row and col must lie between 0 and n - 1.")
  }
  
  row * n + col + 1
}


# ------------------------------------------------------------------------------
# Flatten an n x n board matrix
# ------------------------------------------------------------------------------

flatten_board <- function(board) {
  
  # R normally flattens matrices column-by-column.
  # FLIPSY uses row-by-row ordering.
  as.integer(t(board))
}


# ------------------------------------------------------------------------------
# Construct the move matrix
# ------------------------------------------------------------------------------

move_matrix <- function(shape, n = 5) {
  
  A <- matrix(
    0L,
    nrow = n^2,
    ncol = n^2
  )
  
  for (row in 0:(n - 1)) {
    
    for (col in 0:(n - 1)) {
      
      move <- shape_matrix(
        shape,
        row = row,
        col = col,
        n = n
      )
      
      j <- cell_index(row, col, n)
      
      A[, j] <- flatten_board(move)
    }
  }
  
  A
}


# ------------------------------------------------------------------------------
# Useful diagnostics
# ------------------------------------------------------------------------------

move_column_sums <- function(A) {
  colSums(A)
}


move_row_sums <- function(A) {
  rowSums(A)
}