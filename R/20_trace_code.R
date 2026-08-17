# ==============================================================================
# FLIPSY Mathematics
# 20_trace_code.R
#
# Fourier / trace parameterisation of the homogeneous [25,8,8] code.
#
# Four Fourier directions vanish. The remaining two Frobenius orbits
# contribute four binary dimensions each, suggesting
#
#                   C ~= GF(16) x GF(16).
#
# We construct the resulting 256 binary words and compare them with the
# homogeneous incidence code found in script 18.
# ==============================================================================

source("R/13_fourier_structure.R")
source("R/18_affine_code_bound.R")


# ------------------------------------------------------------------------------
# Absolute trace GF(16) -> GF(2)
#
# Tr(x) = x + x^2 + x^4 + x^8.
#
# The result should be either field element 0 or field element 1.
# ------------------------------------------------------------------------------

gf16_trace <- function(x) {
  
  out <- 0L
  y <- x
  
  for (i in 1:4) {
    
    out <- bitwXor(
      out,
      y
    )
    
    y <- gf16_mul(
      y,
      y
    )
  }
  
  if (!(out %in% c(0L, 1L))) {
    stop("GF(16) trace did not land in GF(2).")
  }
  
  out
}


# ------------------------------------------------------------------------------
# Check trace on every field element
# ------------------------------------------------------------------------------

trace_table <- data.frame(
  x = 0:15,
  trace = vapply(
    0:15,
    gf16_trace,
    integer(1)
  )
)


# ------------------------------------------------------------------------------
# Representatives for the TWO Fourier components allowed to survive.
#
# system4 imposed vanishing in directions 1,2,3,4.
#
# We determine the corresponding surviving Fourier orbits empirically
# rather than assuming that affine direction labels equal character labels.
# ------------------------------------------------------------------------------

find_surviving_components <- function() {
  
  # Take all nonzero homogeneous codewords and inspect Fourier signatures.
  component_sets <- list()
  
  for (i in seq_len(nrow(homogeneous4))) {
    
    x <- homogeneous4[i, ]
    
    if (sum(x) == 0L) {
      next
    }
    
    ids <- which(x == 1L)
    
    shape <- data.frame(
      row = (ids - 1L) %/% 5L,
      col = (ids - 1L) %% 5L
    )
    
    sig <- fourier_signature(shape)
    
    surviving <- which(
      sig$survives
    )
    
    component_sets[[length(component_sets) + 1L]] <-
      surviving
  }
  
  sort(
    unique(
      unlist(component_sets)
    )
  )
}

orbits <- character_orbits()

component_representative <- function(component_id) {
  
  as.integer(
    orbits[[component_id]][1, ]
  )
}

# ------------------------------------------------------------------------------
# Character value zeta^(a*r + b*c)
# ------------------------------------------------------------------------------

character_value <- function(
    a,
    b,
    row,
    col
) {
  
  exponent <- (
    a * row +
      b * col
  ) %% 5L
  
  gf16_pow(
    zeta,
    exponent
  )
}


# ------------------------------------------------------------------------------
# Construct a trace word from two character representatives.
#
# c(r,c) =
#
# Tr(
#    A * zeta^(u dot x)
#    +
#    B * zeta^(v dot x)
# )
# ------------------------------------------------------------------------------

trace_word <- function(
    A,
    B,
    u,
    v
) {
  
  word <- integer(25)
  
  counter <- 1L
  
  for (r in 0:4) {
    
    for (c in 0:4) {
      
      chi_u <- character_value(
        u[1],
        u[2],
        r,
        c
      )
      
      chi_v <- character_value(
        v[1],
        v[2],
        r,
        c
      )
      
      value <- bitwXor(
        gf16_mul(A, chi_u),
        gf16_mul(B, chi_v)
      )
      
      word[counter] <- gf16_trace(
        value
      )
      
      counter <- counter + 1L
    }
  }
  
  word
}


# ------------------------------------------------------------------------------
# Canonical key for a binary word
# ------------------------------------------------------------------------------

word_key <- function(x) {
  
  paste0(
    x,
    collapse = ""
  )
}


# ------------------------------------------------------------------------------
# Generate all 16^2 trace words
# ------------------------------------------------------------------------------

generate_trace_code <- function(u, v) {
  
  words <- matrix(
    0L,
    nrow = 256,
    ncol = 25
  )
  
  parameters <- data.frame(
    A = integer(256),
    B = integer(256)
  )
  
  counter <- 1L
  
  for (A in 0:15) {
    
    for (B in 0:15) {
      
      words[counter, ] <- trace_word(
        A,
        B,
        u,
        v
      )
      
      parameters[counter, ] <- c(
        A,
        B
      )
      
      counter <- counter + 1L
    }
  }
  
  list(
    words = words,
    parameters = parameters
  )
}


# ------------------------------------------------------------------------------
# Compare two binary codes as SETS of words
# ------------------------------------------------------------------------------

same_binary_code <- function(code1, code2) {
  
  keys1 <- sort(
    apply(
      code1,
      1,
      word_key
    )
  )
  
  keys2 <- sort(
    apply(
      code2,
      1,
      word_key
    )
  )
  
  identical(
    keys1,
    keys2
  )
}

# ------------------------------------------------------------------------------
# Five-bit trace sequence associated with A in GF(16)
# ------------------------------------------------------------------------------

trace_sequence <- function(A) {
  
  vapply(
    0:4,
    function(s) {
      
      gf16_trace(
        gf16_mul(
          A,
          gf16_pow(zeta, s)
        )
      )
    },
    integer(1)
  )
}


trace_sequence_table <- do.call(
  rbind,
  lapply(
    0:15,
    function(A) {
      
      seqA <- trace_sequence(A)
      
      data.frame(
        A = A,
        sequence = paste0(
          seqA,
          collapse = ""
        ),
        weight = sum(seqA)
      )
    }
  )
)

trace_sequence_table
table(trace_sequence_table$weight)