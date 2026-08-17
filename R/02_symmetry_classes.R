# ==============================================================================
# FLIPSY Mathematics
# 02_symmetry_classes.R
#
# Symmetry classification of FLIPSY move shapes on Z_n^2.
#
# Shapes are considered equivalent under:
#
#   - toroidal translation;
#   - rotations by 0, 90, 180, 270 degrees;
#   - reflections.
#
# Together the rotations/reflections form the dihedral group D4.
# ==============================================================================

source("R/01_shape_representation.R")


# ------------------------------------------------------------------------------
# Normalise coordinates onto Z_n^2
# ------------------------------------------------------------------------------

normalise_shape <- function(shape, n = 5) {
  
  result <- data.frame(
    row = shape$row %% n,
    col = shape$col %% n
  )
  
  result <- unique(result)
  
  result <- result[
    order(result$row, result$col),
  ]
  
  rownames(result) <- NULL
  
  result
}


# ------------------------------------------------------------------------------
# Translate a shape
# ------------------------------------------------------------------------------

translate_shape <- function(shape, row_shift, col_shift, n = 5) {
  
  normalise_shape(
    data.frame(
      row = shape$row + row_shift,
      col = shape$col + col_shift
    ),
    n
  )
}


# ------------------------------------------------------------------------------
# Apply one of the eight D4 symmetries
# ------------------------------------------------------------------------------

transform_shape <- function(shape, transform_id, n = 5) {
  
  r <- shape$row
  c <- shape$col
  
  transformed <- switch(
    as.character(transform_id),
    
    # Identity
    "1" = data.frame(
      row = r,
      col = c
    ),
    
    # 90 degree rotation
    "2" = data.frame(
      row = c,
      col = -r
    ),
    
    # 180 degree rotation
    "3" = data.frame(
      row = -r,
      col = -c
    ),
    
    # 270 degree rotation
    "4" = data.frame(
      row = -c,
      col = r
    ),
    
    # Reflection
    "5" = data.frame(
      row = r,
      col = -c
    ),
    
    # Reflection + 90 rotation
    "6" = data.frame(
      row = c,
      col = r
    ),
    
    # Reflection + 180 rotation
    "7" = data.frame(
      row = -r,
      col = c
    ),
    
    # Reflection + 270 rotation
    "8" = data.frame(
      row = -c,
      col = -r
    ),
    
    stop("transform_id must be between 1 and 8.")
  )
  
  normalise_shape(transformed, n)
}


# ------------------------------------------------------------------------------
# Convert a shape to a canonical binary string
# ------------------------------------------------------------------------------

shape_key <- function(shape, n = 5) {
  
  board <- matrix(
    0L,
    nrow = n,
    ncol = n
  )
  
  shape <- normalise_shape(shape, n)
  
  indices <- cbind(
    shape$row + 1L,
    shape$col + 1L
  )
  
  board[indices] <- 1L
  
  paste0(
    as.integer(t(board)),
    collapse = ""
  )
}


# ------------------------------------------------------------------------------
# Generate every translation + D4 equivalent
# ------------------------------------------------------------------------------

all_equivalent_keys <- function(shape, n = 5) {
  
  keys <- character(0)
  
  for (d in 1:8) {
    
    transformed <- transform_shape(
      shape,
      transform_id = d,
      n = n
    )
    
    for (row_shift in 0:(n - 1)) {
      
      for (col_shift in 0:(n - 1)) {
        
        translated <- translate_shape(
          transformed,
          row_shift,
          col_shift,
          n
        )
        
        keys <- c(
          keys,
          shape_key(translated, n)
        )
      }
    }
  }
  
  unique(keys)
}


# ------------------------------------------------------------------------------
# Canonical representative
# ------------------------------------------------------------------------------

canonical_shape_key <- function(shape, n = 5) {
  
  keys <- all_equivalent_keys(shape, n)
  
  min(keys)
}


# ------------------------------------------------------------------------------
# Classify a list of shapes
# ------------------------------------------------------------------------------

classify_shapes_by_symmetry <- function(shapes, n = 5) {
  
  keys <- vapply(
    shapes,
    canonical_shape_key,
    character(1),
    n = n
  )
  
  class_ids <- match(
    keys,
    unique(keys)
  )
  
  data.frame(
    shape_index = seq_along(shapes),
    symmetry_class = class_ids,
    canonical_key = keys
  )
}

# ------------------------------------------------------------------------------
# Extract one representative from each symmetry class
# ------------------------------------------------------------------------------

symmetry_class_representatives <- function(
    shapes,
    classification
) {
  
  class_ids <- sort(
    unique(classification$symmetry_class)
  )
  
  lapply(class_ids, function(class_id) {
    
    idx <- which(
      classification$symmetry_class == class_id
    )[1]
    
    shapes[[idx]]
  })
}