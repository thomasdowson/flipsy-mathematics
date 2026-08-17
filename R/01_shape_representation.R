# ==============================================================================
# FLIPSY Mathematics
# 01_shape_representation.R
#
# Representation of FLIPSY move shapes on an n x n toroidal grid.
#
# A shape S is a finite subset of Z_n x Z_n.
# The distinguished coordinate (0, 0) represents the clicked/start cell.
# All coordinates are interpreted modulo n.
# ==============================================================================


# ------------------------------------------------------------------------------
# Modular coordinate arithmetic
# ------------------------------------------------------------------------------

#' Wrap an integer coordinate onto Z_n
#'
#' @param x Integer or integer vector.
#' @param n Board size.
#'
#' @return Integer values in {0, ..., n - 1}.
wrap_coord <- function(x, n) {
  
  if (n < 1 || n != as.integer(n)) {
    stop("n must be a positive integer.")
  }
  
  x %% n
}


# ------------------------------------------------------------------------------
# Shape construction
# ------------------------------------------------------------------------------

#' Create a FLIPSY shape
#'
#' A shape is represented by integer offsets relative to the clicked cell.
#' The clicked cell is always (0, 0).
#'
#' @param coords Two-column matrix/data.frame containing row and column offsets.
#'
#' @return A data.frame with columns row and col.
make_shape <- function(coords) {
  
  if (is.null(coords) || length(coords) == 0) {
    stop("coords cannot be NULL or empty.")
  }
  
  coords <- as.data.frame(coords)
  
  if (ncol(coords) != 2) {
    stop("coords must have exactly two columns.")
  }
  
  names(coords) <- c("row", "col")
  
  if (any(is.na(coords))) {
    stop("Shape coordinates cannot contain NA.")
  }
  
  if (any(coords != floor(as.matrix(coords)))) {
    stop("Shape coordinates must be integers.")
  }
  
  coords$row <- as.integer(coords$row)
  coords$col <- as.integer(coords$col)
  
  # Remove duplicate offsets
  coords <- unique(coords)
  
  # The clicked cell must belong to the shape
  if (!any(coords$row == 0 & coords$col == 0)) {
    stop("Shape must contain the clicked cell (0, 0).")
  }
  
  rownames(coords) <- NULL
  
  coords
}


# ------------------------------------------------------------------------------
# Translate shape to a board position
# ------------------------------------------------------------------------------

#' Apply a FLIPSY shape at a board location
#'
#' @param shape Shape created by make_shape().
#' @param row Row of clicked cell (0-indexed).
#' @param col Column of clicked cell (0-indexed).
#' @param n Board size.
#'
#' @return Coordinates affected by the move.
apply_shape <- function(shape, row, col, n = 5) {
  
  affected <- data.frame(
    row = wrap_coord(shape$row + row, n),
    col = wrap_coord(shape$col + col, n)
  )
  
  # Important when a shape wraps onto itself:
  # flipping the same cell twice cancels over F_2.
  key <- paste(affected$row, affected$col, sep = ",")
  
  counts <- table(key)
  
  surviving <- names(counts[counts %% 2 == 1])
  
  if (length(surviving) == 0) {
    return(data.frame(
      row = integer(0),
      col = integer(0)
    ))
  }
  
  pieces <- strsplit(surviving, ",")
  
  result <- data.frame(
    row = as.integer(vapply(pieces, `[`, character(1), 1)),
    col = as.integer(vapply(pieces, `[`, character(1), 2))
  )
  
  result <- result[order(result$row, result$col), ]
  
  rownames(result) <- NULL
  
  result
}


# ------------------------------------------------------------------------------
# Convert shape to binary board representation
# ------------------------------------------------------------------------------

#' Convert a move into an n x n binary matrix
#'
#' @param shape FLIPSY shape.
#' @param row Clicked row.
#' @param col Clicked column.
#' @param n Board size.
#'
#' @return n x n matrix over F_2.
shape_matrix <- function(shape, row = 0, col = 0, n = 5) {
  
  affected <- apply_shape(shape, row, col, n)
  
  board <- matrix(
    0L,
    nrow = n,
    ncol = n
  )
  
  if (nrow(affected) > 0) {
    
    for (i in seq_len(nrow(affected))) {
      
      board[
        affected$row[i] + 1,
        affected$col[i] + 1
      ] <- 1L
    }
  }
  
  board
}


# ------------------------------------------------------------------------------
# Basic shape properties
# ------------------------------------------------------------------------------

shape_size <- function(shape) {
  nrow(shape)
}


shape_parity <- function(shape) {
  shape_size(shape) %% 2
}


# ------------------------------------------------------------------------------
# Example shapes
# ------------------------------------------------------------------------------

# Single-cell move
shape_single <- make_shape(
  rbind(
    c(0, 0)
  )
)


# Simple 3-cell L
#
# S F
# F .
#
shape_L3 <- make_shape(
  rbind(
    c(0, 0),
    c(0, 1),
    c(1, 0)
  )
)


# Five-cell cross
#
# . F .
# F S F
# . F .
#
shape_cross5 <- make_shape(
  rbind(
    c(0, 0),
    c(-1, 0),
    c(1, 0),
    c(0, -1),
    c(0, 1)
  )
)