# ==============================================================================
# FLIPSY Mathematics
# 14_gl25_symmetry.R
#
# Classification of FLIPSY shapes under the full linear group GL(2,5).
#
# Any invertible 2x2 matrix over F_5 acts on coordinates by
#
#     v -> M v
#
# and preserves the group structure of Z_5^2.
#
# Therefore it preserves the rank structure of FLIPSY move sets.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/02_symmetry_classes.R")


# ------------------------------------------------------------------------------
# Determinant modulo 5
# ------------------------------------------------------------------------------

det_mod5 <- function(M) {
  
  (
    M[1, 1] * M[2, 2] -
      M[1, 2] * M[2, 1]
  ) %% 5
}


# ------------------------------------------------------------------------------
# Generate all matrices in GL(2,5)
# ------------------------------------------------------------------------------

generate_gl25 <- function() {
  
  matrices <- list()
  counter <- 1L
  
  for (a in 0:4) {
    for (b in 0:4) {
      for (c in 0:4) {
        for (d in 0:4) {
          
          M <- matrix(
            c(a, b, c, d),
            nrow = 2,
            byrow = TRUE
          )
          
          if (det_mod5(M) != 0) {
            
            matrices[[counter]] <- M
            counter <- counter + 1L
          }
        }
      }
    }
  }
  
  matrices
}


# ------------------------------------------------------------------------------
# Apply a GL(2,5) matrix to a shape
# ------------------------------------------------------------------------------

transform_shape_gl <- function(shape, M, n = 5) {
  
  coords <- cbind(
    shape$row %% n,
    shape$col %% n
  )
  
  transformed <- t(
    M %*% t(coords)
  ) %% n
  
  result <- data.frame(
    row = transformed[, 1],
    col = transformed[, 2]
  )
  
  normalise_shape(result, n)
}


# ------------------------------------------------------------------------------
# Canonical key under GL(2,5) plus translation
# ------------------------------------------------------------------------------

canonical_gl_key <- function(shape, n = 5) {
  
  gl <- generate_gl25()
  
  best_key <- NULL
  
  for (M in gl) {
    
    transformed <- transform_shape_gl(
      shape,
      M,
      n
    )
    
    for (row_shift in 0:(n - 1)) {
      
      for (col_shift in 0:(n - 1)) {
        
        shifted <- translate_shape(
          transformed,
          row_shift,
          col_shift,
          n
        )
        
        key <- shape_key(
          shifted,
          n
        )
        
        if (
          is.null(best_key) ||
          key < best_key
        ) {
          best_key <- key
        }
      }
    }
  }
  
  best_key
}


# ------------------------------------------------------------------------------
# Classify a list of shapes under GL(2,5) + translation
# ------------------------------------------------------------------------------

classify_shapes_gl <- function(shapes, n = 5) {
  
  keys <- vapply(
    shapes,
    canonical_gl_key,
    character(1),
    n = n
  )
  
  class_ids <- match(
    keys,
    unique(keys)
  )
  
  data.frame(
    shape_index = seq_along(shapes),
    gl_class = class_ids,
    canonical_key = keys
  )
}