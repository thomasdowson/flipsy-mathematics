# FLIPSY Mathematical Research Notes

## Experiment 1 — Odd-cardinality move sets

### Initial conjecture

Every odd-cardinality move set on the 5x5 torus is invertible.

### Results

Size 1:
All shapes invertible.

Size 3:
All 276 shapes containing (0,0) invertible.

Size 5:
10,626 shapes tested.

Rank distribution:

| Rank | Count |
|------|------:|
| 25 | 7200 |
| 21 | 3120 |
| 17 | 300 |
| 5 | 6 |

Therefore the initial conjecture is false.


## Observation 1 — Rank congruence

All observed ranks for odd-cardinality move sets satisfy

rank ≡ 1 (mod 4).

Candidate explanation: factorisation of x^5 - 1 over F_2 and the
decomposition of the toroidal translation algebra.

Status: requires rigorous proof.


## Theorem 1 — Finite-field line shapes

Let G = F_p^2 and let S be a one-dimensional subspace of G.

The translations of S are exactly its p cosets. Their indicator
vectors are disjoint and hence linearly independent.

Therefore the FLIPSY move matrix associated with S has rank p.

For p = 5, exhaustive enumeration found exactly six rank-5
five-cell shapes. These are precisely the six one-dimensional
subspaces of F_5^2.

Status: proved.