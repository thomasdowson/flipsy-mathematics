# ==============================================================================
# FLIPSY Mathematics
# 19_code_parameterisation.R
#
# Find an explicit 8-variable parameterisation of the homogeneous
# [25,8,8] code associated with four affine directions.
# ==============================================================================

source("R/18_affine_code_bound.R")


# ------------------------------------------------------------------------------
# Basic structural information
# ------------------------------------------------------------------------------

free_cells <- space4$free_cols
pivot_cells <- space4$pivot_cols

cell_coordinates <- function(ids) {
  
  data.frame(
    cell = ids,
    row = (ids - 1L) %/% 5L,
    col = (ids - 1L) %% 5L
  )
}


free_coordinates <- cell_coordinates(
  free_cells
)

pivot_coordinates <- cell_coordinates(
  pivot_cells
)

free_coordinates

# ------------------------------------------------------------------------------
# Display one length-25 binary vector as a 5x5 board
# ------------------------------------------------------------------------------

vector_board <- function(x) {
  
  matrix(
    x,
    nrow = 5,
    ncol = 5,
    byrow = TRUE
  )
}


# ------------------------------------------------------------------------------
# Display the eight nullspace generators
# ------------------------------------------------------------------------------

for (j in seq_len(ncol(space4$basis))) {
  
  cat(
    "\n====================\n",
    "Basis generator", j,
    "\n====================\n"
  )
  
  print(
    vector_board(
      space4$basis[, j]
    )
  )
}