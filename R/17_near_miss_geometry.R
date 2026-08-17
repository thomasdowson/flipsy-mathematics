# ==============================================================================
# FLIPSY Mathematics
# 17_near_miss_geometry.R
#
# Analyse 9-point subsets of AG(2,5) having exactly three all-odd
# directions.
#
# Goal:
#   Understand the incidence obstruction preventing a fourth
#   all-odd direction.
# ==============================================================================


# ------------------------------------------------------------------------------
# Six directions
# ------------------------------------------------------------------------------

directions <- list(
  c(1, 0),
  c(0, 1),
  c(1, 1),
  c(1, 2),
  c(1, 3),
  c(1, 4)
)


# ------------------------------------------------------------------------------
# Label every board cell by its parallel line in each direction
#
# For direction v = (a,b), a perpendicular linear functional can be
#
#     L(r,c) = b*r - a*c   mod 5.
#
# Cells having the same value of L lie on the same affine line parallel
# to v.
#
# line_labels[cell, direction] is therefore an integer 1,...,5.
# ------------------------------------------------------------------------------

build_line_labels <- function(n = 5) {
  
  cells <- data.frame(
    row = rep(0:(n - 1), each = n),
    col = rep(0:(n - 1), times = n)
  )
  
  labels <- matrix(
    0L,
    nrow = n^2,
    ncol = length(directions)
  )
  
  for (d in seq_along(directions)) {
    
    a <- directions[[d]][1]
    b <- directions[[d]][2]
    
    labels[, d] <- (
      b * cells$row -
        a * cells$col
    ) %% n + 1L
  }
  
  labels
}


line_labels <- build_line_labels()


# ------------------------------------------------------------------------------
# Direction profile from cell indices
#
# cell_ids are integers in 1,...,25.
# ------------------------------------------------------------------------------

fast_direction_profile <- function(
    cell_ids,
    direction_id
) {
  
  counts <- tabulate(
    line_labels[cell_ids, direction_id],
    nbins = 5L
  )
  
  sort(
    counts,
    decreasing = TRUE
  )
}


# ------------------------------------------------------------------------------
# Is this direction all odd?
# ------------------------------------------------------------------------------

fast_is_all_odd <- function(
    cell_ids,
    direction_id
) {
  
  counts <- tabulate(
    line_labels[cell_ids, direction_id],
    nbins = 5L
  )
  
  all(counts %% 2L == 1L)
}


# ------------------------------------------------------------------------------
# Number of all-odd directions
# ------------------------------------------------------------------------------

fast_count_all_odd <- function(cell_ids) {
  
  sum(
    vapply(
      1:6,
      function(d) {
        fast_is_all_odd(
          cell_ids,
          d
        )
      },
      logical(1)
    )
  )
}


# ------------------------------------------------------------------------------
# Number of unordered point-pairs belonging to a direction
# ------------------------------------------------------------------------------

direction_pair_count <- function(
    cell_ids,
    direction_id
) {
  
  counts <- tabulate(
    line_labels[cell_ids, direction_id],
    nbins = 5L
  )
  
  sum(
    counts * (counts - 1L) / 2L
  )
}


# ------------------------------------------------------------------------------
# Complete signature for one set
# ------------------------------------------------------------------------------

near_miss_signature <- function(cell_ids) {
  
  profiles <- vapply(
    1:6,
    function(d) {
      paste(
        fast_direction_profile(
          cell_ids,
          d
        ),
        collapse = "-"
      )
    },
    character(1)
  )
  
  odd <- vapply(
    1:6,
    function(d) {
      fast_is_all_odd(
        cell_ids,
        d
      )
    },
    logical(1)
  )
  
  pair_counts <- vapply(
    1:6,
    function(d) {
      direction_pair_count(
        cell_ids,
        d
      )
    },
    numeric(1)
  )
  
  list(
    profiles = profiles,
    all_odd = odd,
    pair_counts = pair_counts,
    total_pairs = sum(pair_counts)
  )
}


# ------------------------------------------------------------------------------
# Exhaustively classify size-9 sets containing the origin that have
# exactly three all-odd directions.
#
# Rather than storing every shape, store incidence-pattern frequencies.
# ------------------------------------------------------------------------------

classify_size9_near_misses <- function(
    progress_every = 100000
) {
  
  # Origin = cell 1 under our row-major indexing.
  others <- 2:25
  
  combinations <- combn(
    others,
    8
  )
  
  total <- ncol(combinations)
  
  pattern_counts <- new.env(
    hash = TRUE,
    parent = emptyenv()
  )
  
  near_miss_count <- 0L
  max_odd <- 0L
  
  example <- NULL
  
  cat(
    "\nNEAR-MISS SEARCH:",
    total,
    "size-9 shapes\n"
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
        "- near misses:",
        near_miss_count,
        "\n"
      )
    }
    
    ids <- c(
      1L,
      combinations[, j]
    )
    
    odd_flags <- vapply(
      1:6,
      function(d) {
        fast_is_all_odd(
          ids,
          d
        )
      },
      logical(1)
    )
    
    n_odd <- sum(odd_flags)
    
    max_odd <- max(
      max_odd,
      n_odd
    )
    
    if (n_odd != 3L) {
      next
    }
    
    near_miss_count <- near_miss_count + 1L
    
    pair_counts <- vapply(
      1:6,
      function(d) {
        direction_pair_count(
          ids,
          d
        )
      },
      numeric(1)
    )
    
    odd_pair_counts <- sort(
      pair_counts[odd_flags],
      decreasing = TRUE
    )
    
    other_pair_counts <- sort(
      pair_counts[!odd_flags],
      decreasing = TRUE
    )
    
    key <- paste0(
      "odd=",
      paste(
        odd_pair_counts,
        collapse = ","
      ),
      "|other=",
      paste(
        other_pair_counts,
        collapse = ","
      )
    )
    
    if (exists(
      key,
      envir = pattern_counts,
      inherits = FALSE
    )) {
      
      pattern_counts[[key]] <-
        pattern_counts[[key]] + 1L
      
    } else {
      
      pattern_counts[[key]] <- 1L
    }
    
    if (is.null(example)) {
      example <- ids
    }
  }
  
  keys <- ls(
    pattern_counts
  )
  
  counts <- vapply(
    keys,
    function(k) {
      pattern_counts[[k]]
    },
    integer(1)
  )
  
  patterns <- data.frame(
    pattern = keys,
    count = counts
  )
  
  patterns <- patterns[
    order(
      patterns$count,
      decreasing = TRUE
    ),
  ]
  
  rownames(patterns) <- NULL
  
  list(
    total_shapes = total,
    near_miss_count = near_miss_count,
    max_all_odd = max_odd,
    patterns = patterns,
    example = example
  )
}