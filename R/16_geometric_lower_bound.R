# ==============================================================================
# FLIPSY Mathematics
# 16_geometric_lower_bound.R
#
# Search for small odd subsets of AG(2,5) having at least four
# Fourier-vanishing directions.
#
# Geometrically, for an odd-cardinality set S, a nontrivial Fourier
# component vanishes exactly when the five parallel-line intersection
# counts in the corresponding direction are all odd.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/15_affine_geometry.R")


# ------------------------------------------------------------------------------
# Does a direction have all-odd line intersection counts?
# ------------------------------------------------------------------------------

is_odd_direction <- function(shape, direction, n = 5) {
  
  profile <- direction_profile(
    shape,
    direction,
    n
  )
  
  all(profile %% 2L == 1L)
}


# ------------------------------------------------------------------------------
# Count Fourier-vanishing directions geometrically
# ------------------------------------------------------------------------------

count_odd_directions <- function(shape, n = 5) {
  
  directions <- affine_directions()
  
  sum(
    vapply(
      directions,
      function(d) {
        is_odd_direction(
          shape,
          d,
          n
        )
      },
      logical(1)
    )
  )
}


# ------------------------------------------------------------------------------
# Detailed direction information
# ------------------------------------------------------------------------------

odd_direction_summary <- function(shape, n = 5) {
  
  profile <- affine_profile(
    shape,
    n
  )
  
  data.frame(
    direction = seq_len(nrow(profile)),
    profile = apply(
      profile,
      1,
      paste,
      collapse = "-"
    ),
    all_odd = apply(
      profile,
      1,
      function(x) all(x %% 2L == 1L)
    )
  )
}


# ------------------------------------------------------------------------------
# Verify geometric criterion against Fourier calculation
# ------------------------------------------------------------------------------

verify_geometric_fourier <- function(shape, n = 5) {
  
  geometric <- count_odd_directions(
    shape,
    n
  )
  
  # For an odd shape:
  # number of vanished nontrivial Fourier components
  fourier <- sum(
    !fourier_signature(
      shape,
      n
    )$survives
  )
  
  c(
    geometric_vanishing = geometric,
    fourier_vanishing = fourier,
    agrees = geometric == fourier
  )
}