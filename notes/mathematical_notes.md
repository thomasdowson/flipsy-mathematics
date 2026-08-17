# FLIPSY Mathematical Research Notes

## 1. Mathematical setting

FLIPSY is played on the toroidal grid

\[
G = \mathbb{Z}_5^2.
\]

A move shape is a subset

\[
S \subseteq G.
\]

The shape is translated to whichever cell is clicked, with all
coordinates interpreted modulo 5.

Board states and move patterns are binary, so the natural field is

\[
\mathbb{F}_2 = \{0,1\}.
\]

For a move shape \(S\), let

\[
A_S \in \mathbb{F}_2^{25\times25}
\]

be its move matrix.

Each column of \(A_S\) represents one possible translated move.

The rank of \(A_S\) determines the number of reachable board changes:

\[
|\operatorname{im}(A_S)| = 2^{\operatorname{rank}(A_S)}.
\]

The nullity is

\[
\dim\ker(A_S)=25-\operatorname{rank}(A_S).
\]

If \(A_S\) has full rank 25, every board change is reachable and
every target has a unique move pattern.


---

## 2. Polynomial representation

Represent the move shape by

\[
f_S(x,y)
=
\sum_{(i,j)\in S}x^iy^j.
\]

The relevant algebra is

\[
R =
\frac{\mathbb{F}_2[x,y]}
{(x^5-1,\;y^5-1)}.
\]

Translation of a move corresponds to multiplication by a monomial.

The complete FLIPSY move operation is therefore represented by the
linear map

\[
T_f:R\rightarrow R,
\qquad
h\mapsto f_Sh.
\]

The move matrix \(A_S\) is a matrix representation of \(T_f\).

Therefore

\[
\operatorname{rank}(A_S)
=
\operatorname{rank}(T_f).
\]


---

# Computational experiments

## 3. Experiment 1 — Odd-cardinality move sets

### Initial conjecture

Every odd-cardinality move set on the \(5\times5\) torus is invertible.

### Size 1

All size-1 shapes are invertible.

Rank:

\[
25.
\]

### Size 3

Every size-3 shape containing \((0,0)\) was exhaustively tested.

Number tested:

\[
\binom{24}{2}=276.
\]

All 276 have rank

\[
25.
\]

Therefore every three-cell move set containing the origin is
invertible.

### Size 5

Every size-5 shape containing \((0,0)\) was exhaustively tested.

Number tested:

\[
\binom{24}{4}=10626.
\]

Observed rank distribution:

| Rank | Nullity | Count | Proportion |
|---:|---:|---:|---:|
| 5 | 20 | 6 | 0.000565 |
| 17 | 8 | 300 | 0.028233 |
| 21 | 4 | 3120 | 0.293619 |
| 25 | 0 | 7200 | 0.677583 |

Thus the initial conjecture is false.

Odd cardinality does not imply invertibility.


---

## 4. Experiment 2 — Random odd-cardinality shapes

1,000 random shapes were generated for each odd cardinality

\[
1,3,5,\ldots,25.
\]

Total samples:

\[
13000.
\]

Observed ranks:

\[
1,\ 13,\ 17,\ 21,\ 25.
\]

Together with the exhaustive size-5 experiment, the ranks observed
so far are

\[
1,\ 5,\ 13,\ 17,\ 21,\ 25.
\]

Every observed odd-cardinality shape satisfied

\[
\operatorname{rank}(A_S)\equiv1\pmod4.
\]

Rank 9 was not encountered by random sampling.

A particularly striking observation was that every sampled
23-cell shape had rank

\[
21.
\]

---
### Exhaustive minimum-cardinality search

Rank 9 was exhaustively excluded at cardinalities

\[
|S|=1,3,5,7,9.
\]

The numbers of shapes tested at the nontrivial stages were

\[
\binom{24}{2}=276,
\]

\[
\binom{24}{4}=10626,
\]

\[
\binom{24}{6}=134596,
\]

and

\[
\binom{24}{8}=735471.
\]

No rank-9 example was found.

Therefore

\[
\boxed{
\operatorname{rank}(A_S)=9
\Longrightarrow
|S|\ge11
}
\]

for odd-cardinality move sets on \(\mathbb Z_5^2\).

Status: computationally proved by exhaustive enumeration,
subject to the independently validated implementation.

The next unresolved cardinality is

\[
|S|=11.
\]
---
## Rank-9 minimum cardinality

An exhaustive search found no rank-9 move sets of cardinality

\[
1,3,5,7,9.
\]

A rank-9 move set was found at cardinality 11:

\[
S=
\{
(0,0),(1,0),(2,0),(3,0),
(0,1),(1,1),(2,1),(3,1),
(4,2),(4,3),(4,4)
\}.
\]

Its board representation is

```text
F F . . .
F F . . .
F F . . .
F F . . .
. . F F F
---

# Proved results

## 5. Theorem 1 — Line shapes have rank 5

The exhaustive size-5 enumeration found exactly six shapes of rank 5.

They are precisely the six one-dimensional subspaces of

\[
\mathbb{F}_5^2.
\]

A one-dimensional subspace has the form

\[
L_v=\{0,v,2v,3v,4v\},
\]

where \(v\neq0\).

There are

\[
\frac{5^2-1}{5-1}=6
\]

such subspaces.

For a line \(L\), translation by any element of \(L\) leaves the
line unchanged:

\[
L+\ell=L
\qquad
(\ell\in L).
\]

The 25 translations of \(L\) therefore collapse to its five cosets.

These five cosets are disjoint, so their indicator vectors are
linearly independent.

Hence

\[
\boxed{\operatorname{rank}(A_L)=5.}
\]

### Generalisation

Let

\[
G=\mathbb{F}_p^2
\]

for prime \(p\), and let \(L\) be a one-dimensional subspace.

The translations of \(L\) are its \(p\) cosets.

Their indicator vectors are disjoint and linearly independent.

Therefore

\[
\boxed{\operatorname{rank}(A_L)=p.}
\]


---

## 6. Theorem 2 — Rank congruence for odd shapes

### Statement

For every odd-cardinality move shape

\[
S\subseteq\mathbb{Z}_5^2,
\]

the move-matrix rank satisfies

\[
\boxed{
\operatorname{rank}(A_S)\equiv1\pmod4.
}
\]

### Proof structure

Let \(\zeta\) be a primitive fifth root of unity in

\[
\mathbb{F}_{16}.
\]

Characters of

\[
G=\mathbb{Z}_5^2
\]

are indexed by

\[
(a,b)\in\mathbb{F}_5^2
\]

and have the form

\[
\chi_{a,b}(i,j)=\zeta^{ai+bj}.
\]

The Frobenius automorphism

\[
z\mapsto z^2
\]

acts on character indices by

\[
(a,b)\mapsto(2a,2b)\pmod5.
\]

Because the multiplicative order of 2 modulo 5 is 4, every nonzero
character lies in a Frobenius orbit of size 4.

There are 24 nonzero characters, giving

\[
24/4=6
\]

nontrivial Frobenius orbits.

Together with the trivial character, this yields the decomposition

\[
\boxed{
R\cong
\mathbb{F}_2\times\mathbb{F}_{16}^{\,6}.
}
\]

The dimensions are

\[
1+6(4)=25.
\]

For each character define

\[
\lambda_{a,b}
=
\sum_{(i,j)\in S}\zeta^{ai+bj}.
\]

On each nontrivial four-dimensional component, multiplication by
\(f_S\) contributes either rank 0 or rank 4 according as the
corresponding \(\lambda_{a,b}\) is zero or nonzero.

For the trivial character,

\[
\lambda_{0,0}
=
|S|\pmod2.
\]

If \(|S|\) is odd,

\[
\lambda_{0,0}=1.
\]

Therefore the trivial component contributes rank 1, while every
other contribution is a multiple of 4.

Hence

\[
\operatorname{rank}(A_S)=1+4k
\]

for some

\[
k\in\{0,1,\ldots,6\}.
\]

Thus

\[
\boxed{
\operatorname{rank}(A_S)\equiv1\pmod4.
}
\]


---

## 7. Corollary — Algebraically possible odd-shape ranks

The decomposition implies that the possible rank values permitted
by the component structure are

\[
\boxed{
1,\ 5,\ 9,\ 13,\ 17,\ 21,\ 25.
}
\]

Observed computationally so far:

\[
1,\ 5,\ 13,\ 17,\ 21,\ 25.
\]

Rank 9 has not yet been found computationally.

The algebraic decomposition suggests that rank 9 should be
constructible by choosing an element of \(R\) that is nonzero on
the trivial component and exactly two of the six nontrivial
components.

This will be investigated computationally.


---

## 8. Theorem 3 — Every 23-cell shape has rank 21

Let \(S\) contain 23 of the 25 cells.

Then \(S\) is the full board with two distinct cells \(u\) and \(v\)
removed.

Over \(\mathbb{F}_2\),

\[
f_S = J + x^u + x^v,
\]

where \(J\) denotes the polynomial corresponding to the entire
board.

For every nontrivial character \(\chi\),

\[
\chi(J)=0.
\]

Therefore

\[
\lambda_\chi
=
\chi(u)+\chi(v).
\]

This vanishes precisely when

\[
\chi(u)=\chi(v),
\]

equivalently when

\[
\chi(u-v)=1.
\]

Since \(u-v\neq0\), exactly one nontrivial Frobenius orbit of
characters vanishes.

Thus one four-dimensional component contributes rank 0 and the
remaining five contribute rank 4.

Because 23 is odd, the trivial component contributes rank 1.

Hence

\[
\boxed{
\operatorname{rank}(A_S)
=
1+5(4)
=
21.
}
\]

Therefore every 23-cell move shape on the \(5\times5\) torus has
rank 21.


---

# Current research questions

## 9. Rank-9 problem

The rank decomposition permits

\[
\operatorname{rank}(A_S)=9.
\]

No rank-9 shape has yet been encountered computationally.

Next objective:

> Construct an explicit binary move shape
> \(S\subseteq\mathbb{Z}_5^2\) having rank 9.

The planned script is:

`R/11_rank9_search.R`

The aim is to use the algebraic structure rather than blind random
sampling.


## 10. Rank classification

Determine which ranks are attainable for each cardinality

\[
|S|=0,1,\ldots,25.
\]

In particular:

- determine the smallest cardinality admitting rank 9;
- classify shapes attaining each exceptional rank;
- investigate the 300 rank-17 five-cell shapes;
- investigate the 3120 rank-21 five-cell shapes.


## 11. Symmetry classification

Classify move shapes under appropriate symmetries, including:

- translation;
- rotation;
- reflection;
- potentially the larger linear action of
  \(GL(2,5)\).

This may greatly reduce the number of genuinely distinct
rank-deficient shapes.


## 12. Puzzle difficulty

After the rank structure is understood, investigate minimum solution
length.

For a reachable board \(b\), define

\[
d(b)
=
\min_{A_Sx=b}\operatorname{wt}(x),
\]

where \(\operatorname{wt}(x)\) is Hamming weight.

For a move shape \(S\), define its diameter

\[
D(S)
=
\max_{b\in\operatorname{im}(A_S)}d(b).
\]

Future questions include:

- Which compact FLIPSY shapes maximise \(D(S)\)?
- What is the distribution of minimum solution lengths?
- How does rank relate to puzzle difficulty?
- Which shapes produce the rarest maximally difficult puzzles?


---

# Research workflow

The intended workflow is

\[
\text{computation}
\rightarrow
\text{pattern}
\rightarrow
\text{conjecture}
\rightarrow
\text{proof}
\rightarrow
\text{computational verification}.
\]

Computational observations and proved mathematical results should be
kept explicitly separate throughout the project.