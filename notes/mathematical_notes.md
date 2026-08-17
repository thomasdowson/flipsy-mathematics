# FLIPSY Mathematics — Research Notes

## 1. Problem setup

FLIPSY is played on a wrapped \(5\times5\) grid, mathematically identified
with the finite abelian group

\[
G=\mathbb Z_5^2 \cong \mathbb F_5^2.
\]

A move shape is a subset

\[
S\subseteq G.
\]

If the player activates the move at position \(g\in G\), the translated
set

\[
g+S
\]

is flipped.

Since every cell has two states, the board state is naturally represented
over the field

\[
\mathbb F_2.
\]

Thus a board state is a vector in

\[
\mathbb F_2^{25}.
\]

For a fixed move shape \(S\), the 25 translated moves form the columns of
a binary \(25\times25\) move matrix

\[
A_S.
\]

The rank

\[
r(S)=\operatorname{rank}_{\mathbb F_2}(A_S)
\]

is the dimension of the reachable state space.

Therefore the number of reachable board states is

\[
2^{r(S)},
\]

and the nullity is

\[
25-r(S).
\]

A shape is invertible exactly when

\[
r(S)=25.
\]

---

# 2. Group-algebra formulation

Represent a shape by the polynomial

\[
f_S(x,y)
=
\sum_{(i,j)\in S}x^iy^j
\]

in

\[
R=
\mathbb F_2[x,y]/(x^5-1,\;y^5-1).
\]

The vector space \(R\) has dimension 25 over \(\mathbb F_2\).

Translation of the move shape corresponds to multiplication by monomials,
and the FLIPSY move operator is multiplication by \(f_S\):

\[
m_{f_S}:R\to R,
\qquad
g\mapsto f_Sg.
\]

Hence

\[
r(S)=\operatorname{rank}_{\mathbb F_2}(m_{f_S}).
\]

This converts the puzzle into a problem about multiplication operators in
a finite group algebra.

---

# 3. Fourier/Frobenius decomposition

Because \(5\) is odd, the polynomial \(x^5-1\) is square-free over
\(\mathbb F_2\).

The nontrivial fifth roots of unity lie in

\[
\mathbb F_{16},
\]

because the multiplicative order of \(2\) modulo \(5\) is \(4\).

The 24 nontrivial characters of \(\mathbb Z_5^2\) split into six Frobenius
orbits of size four.

Computationally these six orbits are represented by

\[
\begin{aligned}
C_1 &: (1,0),(2,0),(4,0),(3,0),\\
C_2 &: (0,1),(0,2),(0,4),(0,3),\\
C_3 &: (1,1),(2,2),(4,4),(3,3),\\
C_4 &: (2,1),(4,2),(3,4),(1,3),\\
C_5 &: (3,1),(1,2),(2,4),(4,3),\\
C_6 &: (4,1),(3,2),(1,4),(2,3).
\end{aligned}
\]

This gives the decomposition

\[
R
\cong
\mathbb F_2
\times
\mathbb F_{16}^{\,6}.
\]

Each nontrivial surviving component therefore contributes four dimensions
to the binary rank.

The trivial component is

\[
f_S(1,1)=|S|\pmod2.
\]

Consequently

\[
\boxed{
r(S)
=
(|S|\bmod2)
+
4k
}
\]

where \(k\in\{0,\ldots,6\}\) is the number of surviving nontrivial
Frobenius components.

---

# 4. Rank congruence theorem

It follows immediately that

\[
\boxed{
r(S)\equiv |S|\pmod4.
}
\]

Therefore:

### Odd-cardinality shapes

If \(|S|\) is odd,

\[
\boxed{
r(S)\equiv1\pmod4.
}
\]

Hence the only algebraically possible ranks are

\[
1,5,9,13,17,21,25.
\]

### Even-cardinality shapes

If \(|S|\) is even,

\[
\boxed{
r(S)\equiv0\pmod4.
}
\]

Hence the possible ranks are

\[
0,4,8,12,16,20,24.
\]

This explains the rank congruence observed experimentally.

---

# 5. Computational verification of the congruence

Random experiments across odd shape sizes confirmed that every observed
rank satisfied

\[
r\equiv1\pmod4.
\]

Observed odd ranks included

\[
1,13,17,21,25,
\]

while rank 9 initially appeared to be absent.

This led to a targeted exhaustive search for rank-9 shapes.

---

# 6. Complete enumeration of five-cell shapes

For five-cell move sets containing the origin, the number of shapes is

\[
\binom{24}{4}=10626.
\]

All 10,626 shapes were exhaustively enumerated.

The exact rank distribution was

\[
\begin{array}{c|r}
\text{Rank} & \text{Count}\\
\hline
5  & 6\\
17 & 300\\
21 & 3120\\
25 & 7200
\end{array}
\]

Thus

\[
7200/10626\approx0.67758
\]

of five-cell shapes are invertible.

Only the ranks

\[
5,17,21,25
\]

occur at cardinality five.

In particular, rank 9 does not occur.

---

# 7. Rank-5 shapes

Exactly six five-cell shapes have rank 5.

They are the six affine directions through the origin in

\[
\mathbb F_5^2.
\]

Representatives are

\[
\{(t,0):t\in\mathbb F_5\},
\]

\[
\{(0,t):t\in\mathbb F_5\},
\]

and the four finite-slope lines

\[
\{(t,mt):t\in\mathbb F_5\},
\qquad
m=1,2,3,4.
\]

Thus the six exceptional rank-5 shapes correspond exactly to the six
one-dimensional subspaces of

\[
\mathbb F_5^2.
\]

Their existence is therefore geometric rather than accidental.

---

# 8. Search for rank 9

Rank 9 is algebraically permitted because

\[
9=1+4(2).
\]

Thus a rank-9 odd shape must have exactly two surviving nontrivial
Frobenius components.

A targeted search was therefore performed to determine the minimum
cardinality of a rank-9 move set.

---

# 9. Exhaustive lower-cardinality exclusion

Rank 9 was exhaustively excluded at cardinalities

\[
|S|=1,3,5,7,9.
\]

For shapes containing the origin, the relevant search sizes included

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

No rank-9 shape occurred.

Therefore

\[
r(S)=9
\quad\Longrightarrow\quad
|S|\ge11.
\]

Since even-cardinality shapes have rank divisible by four, no even
cardinality needs to be considered.

---

# 10. Fast GF(2) search engine

The original implementation constructed translated board matrices using
R data frames and general matrix operations.

A faster implementation was developed using direct binary-vector
translations.

Validation included:

- agreement of move matrices for ordinary shapes;
- agreement for wrapped shapes containing negative offsets;
- reproduction of known ranks;
- agreement on 100 independently selected five-cell shapes.

All tests passed.

A benchmark using 1,000 repeated rank calculations gave approximately

\[
15.58\text{ s}
\]

for the original implementation and

\[
0.87\text{ s}
\]

for the fast implementation.

Thus the observed speed-up was approximately

\[
\boxed{17.9\times}.
\]

The original implementation was retained as an independent verification
engine.

---

# 11. Minimum rank-9 shape

The exhaustive size-11 search considered

\[
\binom{24}{10}
=
1,961,256
\]

shapes containing the origin.

A rank-9 shape was found.

One explicit witness is

\[
S_0=
\{
(0,0),(1,0),(2,0),(3,0),
(0,1),(1,1),(2,1),(3,1),
(4,2),(4,3),(4,4)
\}.
\]

Its board representation is

\[
\begin{matrix}
1&1&0&0&0\\
1&1&0&0&0\\
1&1&0&0&0\\
1&1&0&0&0\\
0&0&1&1&1
\end{matrix}.
\]

The fast implementation returned

\[
r(S_0)=9.
\]

The candidate was independently checked using the original move-matrix
implementation, which also returned

\[
\boxed{r(S_0)=9}.
\]

Its nullity is

\[
25-9=16.
\]

Since every smaller odd cardinality had been exhaustively excluded, and
even-cardinality shapes cannot have odd rank, we obtain the computational
extremal result

\[
\boxed{
\min_{S:\,r(S)=9}|S|=11.
}
\]

---

# 12. Complete enumeration of minimum rank-9 shapes

The complete size-11 search was then allowed to continue rather than
stopping at the first witness.

Among the

\[
1,961,256
\]

size-11 shapes containing the origin, exactly

\[
\boxed{660}
\]

have rank 9.

Thus the set of minimum-cardinality rank-9 move sets containing the
origin has size 660.

---

# 13. Classification under game-board symmetries

Shapes were classified under:

- toroidal translations;
- rotations by \(0^\circ,90^\circ,180^\circ,270^\circ\);
- reflections.

The rotations and reflections form the dihedral group

\[
D_4.
\]

Under translation together with \(D_4\), the 660 origin-containing
minimum rank-9 shapes collapse to exactly

\[
\boxed{17}
\]

geometric symmetry classes.

Among the origin-containing representatives, the class counts were:

- 13 classes represented 44 times;
- 4 classes represented 22 times.

Indeed,

\[
13(44)+4(22)=660.
\]

The smaller counts indicate additional stabiliser symmetry for those
classes.

---

# 14. Direct computation in \(\mathbb F_{16}\)

Arithmetic in

\[
\mathbb F_{16}
\]

was implemented directly using the irreducible polynomial

\[
t^4+t+1.
\]

Elements were represented as four-bit integers.

The element

\[
\alpha=2
\]

was computationally verified to have multiplicative order 15.

Therefore

\[
\zeta=\alpha^3
\]

has order five.

In the implementation,

\[
\zeta=8,
\]

with

\[
\operatorname{ord}(\zeta)=5
\]

and

\[
\zeta^5=1.
\]

This provides the fifth roots of unity required for the finite Fourier
analysis.

---

# 15. Fourier coefficients of a shape

For a character indexed by

\[
(a,b)\in\mathbb F_5^2,
\]

define

\[
\lambda_{a,b}(S)
=
\sum_{(r,c)\in S}
\zeta^{ar+bc}.
\]

The four characters in a Frobenius orbit vanish or survive together.

Thus one representative from each of the six nontrivial orbits is
sufficient to determine the rank.

For an odd shape,

\[
r(S)
=
1+
4\#\{\text{surviving nontrivial components}\}.
\]

---

# 16. Fourier verification of the minimum rank-9 witness

For the explicit witness \(S_0\), the computed six-component signature was

\[
(\text{nonzero},
\text{nonzero},
0,0,0,0).
\]

The actual \(\mathbb F_{16}\) coefficient representations were

\[
15,\quad9,\quad0,\quad0,\quad0,\quad0.
\]

Hence exactly two nontrivial components survive.

The Fourier decomposition therefore predicts

\[
1+4(2)=9.
\]

Direct GF(2) Gaussian elimination independently gives

\[
9.
\]

Thus

\[
\boxed{
r_{\text{Fourier}}(S_0)
=
r_{\text{matrix}}(S_0)
=
9.
}
\]

This provides an independent algebraic explanation of the rank.

---

# 17. Fourier supports of minimum rank-9 shapes

A rank-9 odd shape must have exactly two surviving components among the
six nontrivial Frobenius components.

Therefore there are

\[
\binom{6}{2}=15
\]

algebraically possible labelled Fourier-support pairs.

When one arbitrary representative from each of the 17 geometric
\(D_4\)-translation classes was examined, only 12 labelled pairs appeared.

This was initially misleading.

The \(D_4\) action permutes the six Fourier components, so different
orientations of the same geometric shape can have differently labelled
support pairs.

When all 660 minimum rank-9 shapes were examined, the number of distinct
support pairs was

\[
\boxed{15}.
\]

Therefore:

\[
\boxed{
\text{Every algebraically possible two-component Fourier support is
realised by a minimum-cardinality rank-9 shape.}
}
\]

---

# 18. Action of \(D_4\) on Fourier supports

The eight square symmetries induce permutations of the six nontrivial
Fourier components.

The 15 unordered component pairs fall into six \(D_4\)-orbits, with sizes

\[
\boxed{1,4,4,4,1,1}.
\]

Using the current component labelling, these are represented by:

\[
\{12\},
\]

\[
\{13,16,23,26\},
\]

\[
\{14,15,24,25\},
\]

\[
\{34,35,46,56\},
\]

\[
\{36\},
\]

and

\[
\{45\}.
\]

This confirms explicitly that the labelled Fourier support is not
invariant under visual board orientation.

---

# 19. The larger symmetry group \(GL(2,5)\)

The toroidal board has substantially more algebraic symmetry than the
ordinary square picture suggests.

Any invertible linear map

\[
v\mapsto Mv,
\qquad
M\in GL(2,5),
\]

is an automorphism of the additive group

\[
\mathbb F_5^2.
\]

Therefore such transformations preserve the algebraic structure of the
FLIPSY move operator and preserve its rank.

The order of the group is

\[
|GL(2,5)|
=
(5^2-1)(5^2-5)
=
24\cdot20
=
\boxed{480}.
\]

All 480 matrices were generated computationally.

A randomly selected transformation of the explicit rank-9 witness was
checked independently and retained rank 9.

---

# 20. Affine symmetry

Translations can be combined with \(GL(2,5)\).

The resulting affine group is

\[
AGL(2,5)
=
\mathbb F_5^2\rtimes GL(2,5).
\]

Its order is

\[
|AGL(2,5)|
=
25\cdot480
=
\boxed{12000}.
\]

This is the mathematically natural full affine symmetry group of the
FLIPSY torus.

---

# 21. Unique affine class of minimum rank-9 shapes

The 17 geometric \(D_4+\)translation classes were classified under the
larger \(GL(2,5)+\)translation action.

All 17 collapsed to a single class:

\[
\boxed{1}.
\]

Since the 17 geometric classes partition the 660 minimum rank-9 shapes,
it follows that every minimum rank-9 shape found belongs to the same
affine-equivalence class.

Thus the exhaustive computation gives:

\[
\boxed{
\text{There is a unique affine-equivalence class of
minimum-cardinality rank-9 FLIPSY move sets.}
}
\]

Equivalently, every minimum rank-9 move set is affine-equivalent to

\[
S_0=
\{
(0,0),(1,0),(2,0),(3,0),
(0,1),(1,1),(2,1),(3,1),
(4,2),(4,3),(4,4)
\}.
\]

This is substantially stronger than the initial geometric classification
into 17 square-symmetry classes.

---

# 22. Current picture of rank 9

The computational and algebraic results now fit together as follows.

A rank-9 move set must have exactly two surviving nontrivial Fourier
components.

The minimum possible cardinality is

\[
\boxed{11}.
\]

At cardinality 11:

\[
\boxed{660}
\]

origin-containing rank-9 shapes occur.

These form

\[
\boxed{17}
\]

classes under ordinary FLIPSY board symmetry, but only

\[
\boxed{1}
\]

class under the full affine automorphism group of

\[
\mathbb F_5^2.
\]

Moreover, across the complete collection of minimisers, all

\[
\boxed{15}
\]

possible two-component Fourier supports occur.

Thus the apparently diverse minimum rank-9 shapes are manifestations of
one underlying affine-geometric object.

---

# 23. Current main theorem candidates

The work currently suggests the following theorem structure for a paper.

## Theorem A — rank congruence

For every move set

\[
S\subseteq\mathbb F_5^2,
\]

\[
\boxed{
r(S)\equiv |S|\pmod4.
}
\]

This follows from the Frobenius decomposition

\[
\mathbb F_2[\mathbb Z_5^2]
\cong
\mathbb F_2\times\mathbb F_{16}^{\,6}.
\]

---

## Theorem B — rank-5 classification

The five-cell rank-5 move sets are precisely the six one-dimensional
subspaces of

\[
\mathbb F_5^2.
\]

Equivalently, they are the six affine directions through the origin.

---

## Computational Theorem C — minimum rank 9

The minimum cardinality of a rank-9 move set is

\[
\boxed{11}.
\]

That is,

\[
\boxed{
\min_{S:r(S)=9}|S|=11.
}
\]

Cardinalities below 11 were exhaustively excluded and an explicit
cardinality-11 witness was independently verified.

---

## Computational Theorem D — minimum rank-9 classification

Among size-11 move sets containing the origin, exactly

\[
\boxed{660}
\]

have rank 9.

They form exactly

\[
\boxed{17}
\]

classes under translation and \(D_4\).

---

## Computational Theorem E — affine uniqueness

All minimum-cardinality rank-9 move sets belong to a single equivalence
class under

\[
AGL(2,5).
\]

Thus, up to affine automorphism, there is a unique minimum rank-9 shape.

---

# 24. Important distinction: proof versus computation

The project should clearly distinguish algebraic proofs from exhaustive
computational results.

The rank-congruence result follows theoretically from the group-algebra
and Frobenius decomposition.

Other results, including the current minimum-cardinality and affine
classification statements, have presently been established by exhaustive
finite computation.

The computational results are strengthened by:

1. exhaustive enumeration rather than random search;
2. independent slow and fast implementations of the rank calculation;
3. direct Fourier calculations over \(\mathbb F_{16}\);
4. consistency under geometric and affine symmetry transformations.

Nevertheless, a principal research goal is to replace important
computational observations with human-readable proofs wherever possible.

---

# 25. Next theoretical target

The next objective is to understand the canonical 11-point rank-9 set

\[
S_0
\]

intrinsically in the affine plane

\[
AG(2,5).
\]

Its displayed form is

\[
\begin{matrix}
1&1&0&0&0\\
1&1&0&0&0\\
1&1&0&0&0\\
1&1&0&0&0\\
0&0&1&1&1
\end{matrix}.
\]

The goal is to find an affine-geometric characterization of this set,
possibly in terms of:

- intersections with affine lines;
- parallel classes;
- complements of unions of lines;
- incidence counts;
- Fourier-zero conditions;
- or another invariant of \(AG(2,5)\).

If such a characterization can be found, the computational statement

\[
\min |S|=11
\]

may admit a conceptual proof.

Ideally one would prove both:

\[
r(S)=9
\Longrightarrow
|S|\ge11,
\]

and

\[
|S|=11,\ r(S)=9
\Longrightarrow
S\sim_{\mathrm{AGL}(2,5)}S_0.
\]

This would convert the strongest current computational result into a
complete extremal classification theorem.

---

# 26. Broader research direction

The \(5\times5\) FLIPSY system appears to combine several mathematical
structures:

- finite fields;
- group algebras;
- binary linear algebra;
- discrete Fourier analysis;
- finite affine geometry;
- combinatorial extremal problems;
- coding-theoretic weight questions;
- symmetry and orbit classification.

A natural longer-term question is whether the \(5\times5\) results are
instances of general phenomena for

\[
\mathbb Z_p^2
\]

or

\[
\mathbb F_p^2
\]

for odd primes \(p\).

In particular, one may ask how the possible ranks, minimum Hamming
weights, Fourier-support structures and affine equivalence classes depend
on

\[
\operatorname{ord}_p(2).
\]

The \(p=5\) FLIPSY board therefore provides both a concrete puzzle system
and a small finite model in which these algebraic and combinatorial
questions can be studied exhaustively.