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

# ------------------------------------------------------------------------------
# Exhaustively search fixed-size shapes for at least m all-odd directions
# ------------------------------------------------------------------------------

find_shape_with_odd_directions <- function(
    k,
    min_odd_directions = 4,
    n = 5,
    progress_every = 100000
) {
  
  cells <- expand.grid(
    row = 0:(n - 1),
    col = 0:(n - 1)
  )
  
  others <- cells[
    !(cells$row == 0 & cells$col == 0),
    c("row", "col")
  ]
  
  combinations <- combn(
    seq_len(nrow(others)),
    k - 1
  )
  
  total <- ncol(combinations)
  
  cat(
    "\nGEOMETRIC SEARCH:",
    total,
    "shapes of size",
    k,
    "for at least",
    min_odd_directions,
    "all-odd directions\n"
  )
  
  for (j in seq_len(total)) {
    
    if (
      progress_every > 0 &&
      j %% progress_every == 0
    ) {
      cat(
        "Checked",
        j,
        "of",
        total,
        "\n"
      )
    }
    
    coords <- rbind(
      c(0, 0),
      as.matrix(
        others[
          combinations[, j],
          c("row", "col")
        ]
      )
    )
    
    shape <- make_shape(coords)
    
    n_odd <- count_odd_directions(shape, n)
    
    if (n_odd >= min_odd_directions) {
      
      cat(
        "\nFound shape with",
        n_odd,
        "all-odd directions at index",
        j,
        "\n"
      )
      
      return(
        list(
          shape = shape,
          odd_directions = n_odd,
          summary = odd_direction_summary(shape, n)
        )
      )
    }
  }
  
  cat(
    "\nNo qualifying shape found at size",
    k,
    "\n"
  )
  
  NULL
}