# ==============================================================================
# FLIPSY Mathematics
# 13_fourier_structure.R
#
# Fourier structure of FLIPSY move shapes on Z_5^2.
#
# Arithmetic in GF(16) is implemented directly using 4-bit integers.
#
# We use the irreducible polynomial
#
#     p(t) = t^4 + t + 1
#
# over GF(2).
#
# A primitive fifth root of unity is obtained from an element of order 15.
# ==============================================================================

source("R/01_shape_representation.R")
source("R/03_move_matrix.R")
source("R/04_gf2_linear_algebra.R")


# ------------------------------------------------------------------------------
# GF(16) addition
#
# Addition in characteristic 2 is bitwise XOR.
# ------------------------------------------------------------------------------

gf16_add <- function(a, b) {
  bitwXor(as.integer(a), as.integer(b))
}


# ------------------------------------------------------------------------------
# GF(16) multiplication
#
# Elements are represented by integers 0,...,15 corresponding to
#
#     a0 + a1*t + a2*t^2 + a3*t^3.
#
# Reduction polynomial:
#
#     t^4 + t + 1.
#
# Binary representation: 10011 = 0x13.
# ------------------------------------------------------------------------------

gf16_mul <- function(a, b) {
  
  a <- as.integer(a)
  b <- as.integer(b)
  
  result <- 0L
  
  while (b > 0L) {
    
    if (bitwAnd(b, 1L) != 0L) {
      result <- bitwXor(result, a)
    }
    
    b <- bitwShiftR(b, 1L)
    
    carry <- bitwAnd(a, 8L)
    
    a <- bitwShiftL(a, 1L)
    
    if (carry != 0L) {
      a <- bitwXor(a, 0x13L)
    }
    
    a <- bitwAnd(a, 15L)
  }
  
  result
}


# ------------------------------------------------------------------------------
# GF(16) exponentiation
# ------------------------------------------------------------------------------

gf16_pow <- function(a, exponent) {
  
  result <- 1L
  base <- as.integer(a)
  exponent <- as.integer(exponent)
  
  while (exponent > 0L) {
    
    if (bitwAnd(exponent, 1L) != 0L) {
      result <- gf16_mul(result, base)
    }
    
    base <- gf16_mul(base, base)
    
    exponent <- bitwShiftR(exponent, 1L)
  }
  
  result
}


# ------------------------------------------------------------------------------
# Multiplicative order
# ------------------------------------------------------------------------------

gf16_order <- function(a) {
  
  if (a == 0L) {
    return(0L)
  }
  
  x <- 1L
  
  for (k in 1:15) {
    
    x <- gf16_mul(x, a)
    
    if (x == 1L) {
      return(k)
    }
  }
  
  NA_integer_
}


# ------------------------------------------------------------------------------
# Find primitive element of GF(16)
# ------------------------------------------------------------------------------

find_primitive_element <- function() {
  
  for (a in 2:15) {
    
    if (gf16_order(a) == 15L) {
      return(a)
    }
  }
  
  stop("No primitive element found.")
}


# ------------------------------------------------------------------------------
# Primitive fifth root of unity
#
# If alpha has order 15, then alpha^3 has order 5.
# ------------------------------------------------------------------------------

primitive_fifth_root <- function() {
  
  alpha <- find_primitive_element()
  
  gf16_pow(alpha, 3L)
}


# ------------------------------------------------------------------------------
# Evaluate the Fourier coefficient of a shape
#
# lambda_(a,b) =
#
#     sum_(r,c in S) zeta^(a*r + b*c)
#
# where arithmetic in the exponent is modulo 5.
# ------------------------------------------------------------------------------

fourier_coefficient <- function(
    shape,
    a,
    b,
    n = 5,
    zeta = primitive_fifth_root()
) {
  
  shape <- data.frame(
    row = shape$row %% n,
    col = shape$col %% n
  )
  
  value <- 0L
  
  for (i in seq_len(nrow(shape))) {
    
    exponent <- (
      a * shape$row[i] +
        b * shape$col[i]
    ) %% n
    
    term <- gf16_pow(
      zeta,
      exponent
    )
    
    value <- gf16_add(
      value,
      term
    )
  }
  
  value
}


# ------------------------------------------------------------------------------
# Frobenius orbit of a nonzero character
#
# (a,b) -> (2a,2b) mod 5.
# ------------------------------------------------------------------------------

frobenius_orbit <- function(a, b, n = 5) {
  
  orbit <- matrix(
    NA_integer_,
    nrow = 4,
    ncol = 2
  )
  
  current_a <- a
  current_b <- b
  
  for (i in 1:4) {
    
    orbit[i, ] <- c(
      current_a,
      current_b
    )
    
    current_a <- (2L * current_a) %% n
    current_b <- (2L * current_b) %% n
  }
  
  colnames(orbit) <- c("a", "b")
  
  orbit
}


# ------------------------------------------------------------------------------
# The six nontrivial Frobenius orbits
# ------------------------------------------------------------------------------

character_orbits <- function(n = 5) {
  
  chars <- expand.grid(
    a = 0:(n - 1),
    b = 0:(n - 1)
  )
  
  chars <- chars[
    !(chars$a == 0 & chars$b == 0),
  ]
  
  seen <- character(0)
  orbits <- list()
  
  for (i in seq_len(nrow(chars))) {
    
    a <- chars$a[i]
    b <- chars$b[i]
    
    key <- paste(a, b, sep = ",")
    
    if (key %in% seen) {
      next
    }
    
    orbit <- frobenius_orbit(
      a,
      b,
      n
    )
    
    orbit_keys <- apply(
      orbit,
      1,
      paste,
      collapse = ","
    )
    
    seen <- c(
      seen,
      orbit_keys
    )
    
    orbits[[length(orbits) + 1L]] <- orbit
  }
  
  orbits
}


# ------------------------------------------------------------------------------
# Fourier signature
#
# One representative from each Frobenius orbit is evaluated.
#
# TRUE  = component survives
# FALSE = component vanishes
# ------------------------------------------------------------------------------

fourier_signature <- function(shape, n = 5) {
  
  orbits <- character_orbits(n)
  
  coefficients <- integer(
    length(orbits)
  )
  
  for (i in seq_along(orbits)) {
    
    representative <- orbits[[i]][1, ]
    
    coefficients[i] <- fourier_coefficient(
      shape,
      representative["a"],
      representative["b"],
      n
    )
  }
  
  data.frame(
    component = seq_along(orbits),
    coefficient = coefficients,
    survives = coefficients != 0L
  )
}


# ------------------------------------------------------------------------------
# Rank predicted from Fourier decomposition
# ------------------------------------------------------------------------------

fourier_predicted_rank <- function(shape, n = 5) {
  
  signature <- fourier_signature(
    shape,
    n
  )
  
  trivial_component <- nrow(shape) %% 2L
  
  trivial_component +
    4L * sum(signature$survives)
}

# ==============================================================================
# D4 ACTION ON FOURIER COMPONENTS
# ==============================================================================


# ------------------------------------------------------------------------------
# Apply a D4 transformation to a character index (a,b)
#
# For the rotations/reflections used here, the coordinate transformations are
# represented by orthogonal signed permutation matrices. The induced action on
# character indices has the same form modulo 5.
# ------------------------------------------------------------------------------

transform_character <- function(a, b, transform_id, n = 5) {
  
  transformed <- switch(
    as.character(transform_id),
    
    # Identity
    "1" = c(a, b),
    
    # 90 degree rotation
    "2" = c(b, -a),
    
    # 180 degree rotation
    "3" = c(-a, -b),
    
    # 270 degree rotation
    "4" = c(-b, a),
    
    # Reflection
    "5" = c(a, -b),
    
    # Reflection + 90 rotation
    "6" = c(b, a),
    
    # Reflection + 180 rotation
    "7" = c(-a, b),
    
    # Reflection + 270 rotation
    "8" = c(-b, -a),
    
    stop("transform_id must be between 1 and 8.")
  )
  
  transformed %% n
}


# ------------------------------------------------------------------------------
# Determine which Frobenius component contains a character
# ------------------------------------------------------------------------------

character_component <- function(a, b, n = 5) {
  
  if (a %% n == 0 && b %% n == 0) {
    return(0L)
  }
  
  orbits <- character_orbits(n)
  
  target <- paste(
    a %% n,
    b %% n,
    sep = ","
  )
  
  for (i in seq_along(orbits)) {
    
    keys <- apply(
      orbits[[i]],
      1,
      paste,
      collapse = ","
    )
    
    if (target %in% keys) {
      return(i)
    }
  }
  
  stop("Character was not found in any Frobenius orbit.")
}


# ------------------------------------------------------------------------------
# Permutation of the six components induced by a D4 transformation
# ------------------------------------------------------------------------------

component_permutation <- function(transform_id, n = 5) {
  
  orbits <- character_orbits(n)
  
  permutation <- integer(length(orbits))
  
  for (i in seq_along(orbits)) {
    
    representative <- orbits[[i]][1, ]
    
    transformed <- transform_character(
      representative["a"],
      representative["b"],
      transform_id,
      n
    )
    
    permutation[i] <- character_component(
      transformed[1],
      transformed[2],
      n
    )
  }
  
  permutation
}


# ------------------------------------------------------------------------------
# Show all eight component permutations
# ------------------------------------------------------------------------------

all_component_permutations <- function(n = 5) {
  
  permutations <- t(
    vapply(
      1:8,
      component_permutation,
      integer(6),
      n = n
    )
  )
  
  colnames(permutations) <- paste0(
    "component_",
    1:6
  )
  
  rownames(permutations) <- paste0(
    "D4_",
    1:8
  )
  
  permutations
}


# ------------------------------------------------------------------------------
# Canonical representation of an unordered pair of components
# ------------------------------------------------------------------------------

pair_key <- function(pair) {
  
  pair <- sort(as.integer(pair))
  
  paste(
    pair,
    collapse = "-"
  )
}


# ------------------------------------------------------------------------------
# Apply a component permutation to a pair
# ------------------------------------------------------------------------------

transform_component_pair <- function(
    pair,
    transform_id,
    n = 5
) {
  
  permutation <- component_permutation(
    transform_id,
    n
  )
  
  sort(
    permutation[pair]
  )
}


# ------------------------------------------------------------------------------
# Complete D4 orbit of a component pair
# ------------------------------------------------------------------------------

component_pair_orbit <- function(pair, n = 5) {
  
  keys <- vapply(
    1:8,
    function(d) {
      
      transformed <- transform_component_pair(
        pair,
        d,
        n
      )
      
      pair_key(transformed)
    },
    character(1)
  )
  
  sort(unique(keys))
}


# ------------------------------------------------------------------------------
# Classify all 15 unordered pairs under D4
# ------------------------------------------------------------------------------

classify_component_pairs <- function(n = 5) {
  
  pairs <- combn(
    1:6,
    2,
    simplify = FALSE
  )
  
  keys <- vapply(
    pairs,
    function(pair) {
      
      orbit <- component_pair_orbit(
        pair,
        n
      )
      
      min(orbit)
    },
    character(1)
  )
  
  data.frame(
    pair = vapply(
      pairs,
      pair_key,
      character(1)
    ),
    d4_class = match(
      keys,
      unique(keys)
    ),
    canonical_pair = keys
  )
}