///|
/// Boyer benchmark (minimal MoonBit version)
enum Id {
  A
  B
  C
  D
  X
  Y
  Z
  U
  W
  ADD1
  AND
  APPEND
  CONS
  DIFFERENCE
  EQUAL
  F
  FALSE
  FOUR
  IF
  IMPLIES
  LENGTH
  LESSP
  MEMBER
  NIL
  NOT
  ONE
  OR
  PLUS
  QUOTIENT
  REMAINDER
  REVERSE
  TIMES
  TRUE
  TWO
  ZERO
  ZEROP
} derive(Eq)

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
enum Term {
  Var(Id)
  Func(Id, List[Term], () -> List[(Term, Term)])
  ERROR
}

///|
impl Eq for Term with equal(self, other) {
  match (self, other) {
    (Var(id1), Var(id2)) => id1 == id2
    (Func(id1, args1, _), Func(id2, args2, _)) => id1 == id2 && args1 == args2
    _ => false
  }
}

///|
impl Eq for List[Term] with equal(self, other) {
  match (self, other) {
    (Nil, Nil) => true
    (Nil, _) | (_, Nil) => false
    (Cons(h1, t1), Cons(h2, t2)) => h1 == h2 && t1 == t2
  }
}

///|
fn term_in_list(t : Term, lst : List[Term]) -> Bool {
  match lst {
    Nil => false
    Cons(t_, ts) => t == t_ || term_in_list(t, ts)
  }
}

///|
fn all_term(ls : List[Term], p : (Term) -> Bool) -> Bool {
  match ls {
    Nil => true
    Cons(t, ts) => p(t) && all_term(ts, p)
  }
}

///|
fn[T, U] map_list(lst : List[T], f : (T) -> U) -> List[U] {
  match lst {
    Nil => Nil
    Cons(h, t) => Cons(f(h), map_list(t, f))
  }
}

///|
fn replicate_term(n : Int, t : Term) -> List[Term] {
  if n == 0 {
    Nil
  } else {
    Cons(t, replicate_term(n - 1, t))
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = test_boyer_nofib(n)
  if iters == 1 {
    if res {
      println(1)
    } else {
      println(0)
    }
  } else {
    main_loop(iters - 1, n)
  }
}

///|
fn main {
  // CLI access may error; it's acceptable per instruction
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  main_loop(iters.unwrap(), n.unwrap())
}

///| ------------------------------------------------------------

///| Boyer benchmark core translated from OCaml

///|
/// lookup a variable id in a substitution list
fn find(vid : Id, ls : List[(Id, Term)]) -> (Bool, Term) {
  match ls {
    Nil => (false, ERROR)
    Cons((vid2, val2), bs) =>
      if vid == vid2 {
        (true, val2)
      } else {
        find(vid, bs)
      }
  }
}

///|
/// Boyer term constructors and constants
fn boyer_add1(a : Term) -> Term {
  Func(ADD1, Cons(a, Nil), () => Nil)
}

///|
let boyer_zero : Term = Func(ZERO, Nil, () => Nil)

///|
fn boyer_zerop(a : Term) -> Term {
  Func(ZEROP, Cons(a, Nil), () => Cons(
    (boyer_zerop(boyer_x), boyer_equal(boyer_x, boyer_zero)),
    Nil,
  ))
}

///|
fn boyer_one_() -> Term {
  Func(ONE, Nil, () => Cons((boyer_one_(), boyer_add1(boyer_zero)), Nil))
}

///|
fn boyer_two_() -> Term {
  Func(TWO, Nil, () => Cons((boyer_two_(), boyer_add1(boyer_one_())), Nil))
}

///|
fn boyer_four_() -> Term {
  Func(FOUR, Nil, () => Cons(
    (boyer_four_(), boyer_add1(boyer_add1(boyer_two_()))),
    Nil,
  ))
}

///|
let boyer_one : Term = boyer_one_()

///|
let boyer_two : Term = boyer_two_()

///|
let boyer_four : Term = boyer_four_()

///|
fn boyer_if_(a : Term, b : Term, c : Term) -> Term {
  Func(IF, Cons(a, Cons(b, Cons(c, Nil))), () => Cons(
    (
      boyer_if_(boyer_if_(boyer_x, boyer_y, boyer_z), boyer_u, boyer_w),
      boyer_if_(
        boyer_x,
        boyer_if_(boyer_y, boyer_u, boyer_w),
        boyer_if_(boyer_z, boyer_u, boyer_w),
      ),
    ),
    Nil,
  ))
}

///|
fn boyer_not_(a : Term) -> Term {
  Func(NOT, Cons(a, Nil), () => Cons(
    (boyer_not_(boyer_x), boyer_if_(boyer_x, boyer_false, boyer_true)),
    Nil,
  ))
}

///|
fn boyer_and_(a : Term, b : Term) -> Term {
  Func(AND, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_and_(boyer_x, boyer_y),
      boyer_if_(
        boyer_x,
        boyer_if_(boyer_y, boyer_true, boyer_false),
        boyer_false,
      ),
    ),
    Nil,
  ))
}

///|
fn boyer_equal(a : Term, b : Term) -> Term {
  Func(EQUAL, Cons(a, Cons(b, Nil)), (
  // 1
  ) => Cons(
    (
      boyer_equal(boyer_plus(boyer_x, boyer_y), boyer_zero),
      boyer_and_(boyer_zerop(boyer_x), boyer_zerop(boyer_y)),
    ),
    // 2
    Cons(
      (
        boyer_equal(boyer_plus(boyer_x, boyer_y), boyer_plus(boyer_x, boyer_z)),
        boyer_equal(boyer_y, boyer_z),
      ),
      // 3
      Cons(
        (
          boyer_equal(boyer_zero, boyer_difference(boyer_x, boyer_y)),
          boyer_not_(boyer_lessp(boyer_y, boyer_x)),
        ),
        // 4
        Cons(
          (
            boyer_equal(boyer_x, boyer_difference(boyer_x, boyer_y)),
            boyer_not_(boyer_lessp(boyer_y, boyer_x)),
          ),
          // 5
          Cons(
            (
              boyer_equal(boyer_times(boyer_x, boyer_y), boyer_zero),
              boyer_or_(boyer_zerop(boyer_x), boyer_zerop(boyer_y)),
            ),
            // 6
            Cons(
              (
                boyer_equal(
                  boyer_append_(boyer_x, boyer_y),
                  boyer_append_(boyer_x, boyer_z),
                ),
                boyer_equal(boyer_y, boyer_z),
              ),
              // 7
              Cons(
                (
                  boyer_equal(boyer_y, boyer_times(boyer_x, boyer_y)),
                  boyer_or_(
                    boyer_equal(boyer_y, boyer_zero),
                    boyer_equal(boyer_x, boyer_one),
                  ),
                ),
                // 8
                Cons(
                  (
                    boyer_equal(boyer_x, boyer_times(boyer_x, boyer_y)),
                    boyer_or_(
                      boyer_equal(boyer_x, boyer_zero),
                      boyer_equal(boyer_y, boyer_one),
                    ),
                  ),
                  // 9
                  Cons(
                    (
                      boyer_equal(boyer_times(boyer_x, boyer_y), boyer_one),
                      boyer_and_(
                        boyer_equal(boyer_x, boyer_one),
                        boyer_equal(boyer_y, boyer_one),
                      ),
                    ),
                    // 10
                    Cons(
                      (
                        boyer_equal(
                          boyer_difference(boyer_x, boyer_y),
                          boyer_difference(boyer_z, boyer_y),
                        ),
                        boyer_if_(
                          boyer_lessp(boyer_x, boyer_y),
                          boyer_not_(boyer_lessp(boyer_y, boyer_z)),
                          boyer_equal(boyer_x, boyer_z),
                        ),
                      ),
                      // 11
                      Cons(
                        (
                          boyer_equal(boyer_lessp(boyer_x, boyer_y), boyer_z),
                          boyer_if_(
                            boyer_lessp(boyer_x, boyer_y),
                            boyer_equal(boyer_true, boyer_z),
                            boyer_equal(boyer_false, boyer_z),
                          ),
                        ),
                        Nil,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  ))
}

///|
fn boyer_append_(a : Term, b : Term) -> Term {
  Func(APPEND, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_append_(boyer_append_(boyer_x, boyer_y), boyer_z),
      boyer_append_(boyer_x, boyer_append_(boyer_y, boyer_z)),
    ),
    Nil,
  ))
}

// Variables

///|
let boyer_x : Term = Var(X)

///|
let boyer_y : Term = Var(Y)

///|
let boyer_z : Term = Var(Z)

///|
let boyer_u : Term = Var(U)

///|
let boyer_w : Term = Var(W)

///|
let boyer_a : Term = Var(A)

///|
let boyer_b : Term = Var(B)

///|
let boyer_c : Term = Var(C)

///|
let boyer_d : Term = Var(D)

///|
let boyer_false : Term = Func(FALSE, Nil, () => Nil)

///|
let boyer_true : Term = Func(TRUE, Nil, () => Nil)

///|
fn boyer_or_(a : Term, b : Term) -> Term {
  Func(OR, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_or_(boyer_x, boyer_y),
      boyer_if_(
        boyer_x,
        boyer_true,
        boyer_if_(boyer_y, boyer_true, boyer_false),
      ),
    ),
    Nil,
  ))
}

///|
fn boyer_lessp(a : Term, b : Term) -> Term {
  Func(LESSP, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_lessp(boyer_remainder(boyer_x, boyer_y), boyer_y),
      boyer_not_(boyer_zerop(boyer_y)),
    ),
    Nil,
  ))
}

///|
fn boyer_cons(a : Term, b : Term) -> Term {
  Func(CONS, Cons(a, Cons(b, Nil)), () => Nil)
}

///|
fn boyer_remainder(a : Term, b : Term) -> Term {
  Func(REMAINDER, Cons(a, Cons(b, Nil)), () => Cons(
    (boyer_remainder(boyer_x, boyer_one), boyer_zero),
    Cons(
      (boyer_remainder(boyer_x, boyer_x), boyer_zero),
      Cons(
        (boyer_remainder(boyer_times(boyer_x, boyer_y), boyer_x), boyer_zero),
        Cons(
          (boyer_remainder(boyer_times(boyer_x, boyer_y), boyer_y), boyer_zero),
          Nil,
        ),
      ),
    ),
  ))
}

///|
fn boyer_quotient(a : Term, b : Term) -> Term {
  Func(QUOTIENT, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_quotient(
        boyer_plus(boyer_x, boyer_plus(boyer_x, boyer_y)),
        boyer_two,
      ),
      boyer_plus(boyer_x, boyer_quotient(boyer_y, boyer_two)),
    ),
    Nil,
  ))
}

///|
fn boyer_times(a : Term, b : Term) -> Term {
  Func(TIMES, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_times(boyer_x, boyer_plus(boyer_y, boyer_z)),
      boyer_plus(boyer_times(boyer_x, boyer_y), boyer_times(boyer_x, boyer_z)),
    ),
    Cons(
      (
        boyer_times(boyer_times(boyer_x, boyer_y), boyer_z),
        boyer_times(boyer_x, boyer_times(boyer_y, boyer_z)),
      ),
      Cons(
        (
          boyer_times(boyer_x, boyer_difference(boyer_y, boyer_z)),
          boyer_difference(
            boyer_times(boyer_y, boyer_x),
            boyer_times(boyer_z, boyer_x),
          ),
        ),
        Cons(
          (
            boyer_times(boyer_x, boyer_add1(boyer_y)),
            boyer_plus(boyer_x, boyer_times(boyer_x, boyer_y)),
          ),
          Nil,
        ),
      ),
    ),
  ))
}

///|
fn boyer_difference(a : Term, b : Term) -> Term {
  Func(DIFFERENCE, Cons(a, Cons(b, Nil)), () => Cons(
    (boyer_difference(boyer_x, boyer_x), boyer_zero),
    Cons(
      (boyer_difference(boyer_plus(boyer_x, boyer_y), boyer_x), boyer_y),
      Cons(
        (boyer_difference(boyer_plus(boyer_y, boyer_x), boyer_x), boyer_y),
        Cons(
          (
            boyer_difference(
              boyer_plus(boyer_x, boyer_y),
              boyer_plus(boyer_x, boyer_z),
            ),
            boyer_difference(boyer_y, boyer_z),
          ),
          Cons(
            (
              boyer_difference(
                boyer_plus(boyer_y, boyer_plus(boyer_x, boyer_z)),
                boyer_x,
              ),
              boyer_plus(boyer_y, boyer_z),
            ),
            Cons(
              (
                boyer_difference(
                  boyer_add1(boyer_plus(boyer_y, boyer_z)),
                  boyer_z,
                ),
                boyer_add1(boyer_y),
              ),
              Cons(
                (
                  boyer_difference(boyer_add1(boyer_add1(boyer_x)), boyer_two),
                  boyer_x,
                ),
                Nil,
              ),
            ),
          ),
        ),
      ),
    ),
  ))
}

///|
fn boyer_implies(a : Term, b : Term) -> Term {
  Func(IMPLIES, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_implies(boyer_x, boyer_y),
      boyer_if_(
        boyer_x,
        boyer_if_(boyer_y, boyer_true, boyer_false),
        boyer_true,
      ),
    ),
    Nil,
  ))
}

///|
fn boyer_length_(a : Term) -> Term {
  Func(LENGTH, Cons(a, Nil), () => Cons(
    (boyer_length_(boyer_reverse_(boyer_x)), boyer_length_(boyer_x)),
    Cons(
      (
        boyer_length_(
          boyer_cons(
            boyer_x,
            boyer_cons(
              boyer_y,
              boyer_cons(boyer_z, boyer_cons(boyer_u, boyer_w)),
            ),
          ),
        ),
        boyer_plus(boyer_four, boyer_length_(boyer_w)),
      ),
      Nil,
    ),
  ))
}

///|
fn boyer_reverse_(a : Term) -> Term {
  Func(REVERSE, Cons(a, Nil), () => Cons(
    (
      boyer_reverse_(boyer_append_(boyer_x, boyer_y)),
      boyer_append_(boyer_reverse_(boyer_y), boyer_reverse_(boyer_x)),
    ),
    Nil,
  ))
}

///|
let boyer_nil : Term = Func(NIL, Nil, () => Nil)

///|
fn boyer_member(a : Term, b : Term) -> Term {
  Func(MEMBER, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_member(boyer_x, boyer_append_(boyer_y, boyer_z)),
      boyer_or_(boyer_member(boyer_x, boyer_y), boyer_member(boyer_x, boyer_z)),
    ),
    Cons(
      (
        boyer_member(boyer_x, boyer_reverse_(boyer_y)),
        boyer_member(boyer_x, boyer_y),
      ),
      Nil,
    ),
  ))
}

///|
fn boyer_plus(a : Term, b : Term) -> Term {
  Func(PLUS, Cons(a, Cons(b, Nil)), () => Cons(
    (
      boyer_plus(boyer_plus(boyer_x, boyer_y), boyer_z),
      boyer_plus(boyer_x, boyer_plus(boyer_y, boyer_z)),
    ),
    Cons(
      (
        boyer_plus(
          boyer_remainder(boyer_x, boyer_y),
          boyer_times(boyer_y, boyer_quotient(boyer_x, boyer_y)),
        ),
        boyer_x,
      ),
      Cons(
        (
          boyer_plus(boyer_x, boyer_add1(boyer_y)),
          boyer_add1(boyer_plus(boyer_x, boyer_y)),
        ),
        Nil,
      ),
    ),
  ))
}

///|
fn boyer_f(a : Term) -> Term {
  Func(F, Cons(a, Nil), () => Nil)
}

///|
/// One-way unification
fn one_way_unify(term1 : Term, term2 : Term) -> (Bool, List[(Id, Term)]) {
  one_way_unify1(term1, term2, Nil)
}

///|
fn one_way_unify1(
  term1 : Term,
  term2 : Term,
  subst : List[(Id, Term)],
) -> (Bool, List[(Id, Term)]) {
  match term2 {
    Var(vid2) => {
      let (found, v2) = find(vid2, subst)
      if found {
        (term1 == v2, subst)
      } else {
        (true, Cons((vid2, term1), subst))
      }
    }
    Func(f2, as2, _) =>
      match term1 {
        Var(_) => (false, Nil)
        Func(f1, as1, _) =>
          if f1 == f2 {
            one_way_unify1_lst(as1, as2, subst)
          } else {
            (false, Nil)
          }
        ERROR => (false, Nil)
      }
    ERROR => (false, Nil)
  }
}

///|
fn one_way_unify1_lst(
  tts1 : List[Term],
  tts2 : List[Term],
  subst : List[(Id, Term)],
) -> (Bool, List[(Id, Term)]) {
  match (tts1, tts2) {
    (Nil, Nil) => (true, subst)
    (Nil, _) => (false, Nil)
    (_, Nil) => (false, Nil)
    (Cons(t1, ts1), Cons(t2, ts2)) => {
      let (hd_ok, subst_) = one_way_unify1(t1, t2, subst)
      let (tl_ok, subst__) = one_way_unify1_lst(ts1, ts2, subst_)
      (hd_ok && tl_ok, subst__)
    }
  }
}

///|
/// Apply substitution to a term
fn apply_subst(subst : List[(Id, Term)], t : Term) -> Term {
  match t {
    Var(vid) => {
      let (found, value) = find(vid, subst)
      if found {
        value
      } else {
        Var(vid)
      }
    }
    Func(f, args, ls) => Func(f, map_list(args, x => apply_subst(subst, x)), ls)
    ERROR => ERROR
  }
}

///|
/// Rewriting with lemmas
fn rewrite(t : Term) -> Term {
  match t {
    Var(v) => Var(v)
    Func(f, args, lemmas) =>
      rewrite_with_lemmas(
        Func(f, map_list(args, x => rewrite(x)), lemmas),
        lemmas(),
      )
    ERROR => ERROR
  }
}

///|
fn rewrite_with_lemmas(term : Term, lss : List[(Term, Term)]) -> Term {
  match lss {
    Nil => term
    Cons((lhs, rhs), ls) => {
      let (unified, subst) = one_way_unify(term, lhs)
      if unified {
        rewrite(apply_subst(subst, rhs))
      } else {
        rewrite_with_lemmas(term, ls)
      }
    }
  }
}

///|
/// Tautology checker
fn truep(x : Term, l : List[Term]) -> Bool {
  match x {
    Var(_) => term_in_list(x, l)
    Func(t, _, _) => t == TRUE || term_in_list(x, l)
    ERROR => term_in_list(x, l)
  }
}

///|
fn falsep(x : Term, l : List[Term]) -> Bool {
  match x {
    Var(_) => term_in_list(x, l)
    Func(t, _, _) => t == FALSE || term_in_list(x, l)
    ERROR => term_in_list(x, l)
  }
}

///|
fn tautologyp(x : Term, true_lst : List[Term], false_lst : List[Term]) -> Bool {
  if truep(x, true_lst) {
    true
  } else if falsep(x, false_lst) {
    false
  } else {
    match x {
      Func(IF, Cons(cond, Cons(t, Cons(e, Nil))), _) =>
        if truep(cond, true_lst) {
          tautologyp(t, true_lst, false_lst)
        } else if falsep(cond, false_lst) {
          tautologyp(e, true_lst, false_lst)
        } else {
          tautologyp(t, Cons(cond, true_lst), false_lst) &&
          tautologyp(e, true_lst, Cons(cond, false_lst))
        }
      _ => false
    }
  }
}

///|
fn tautp(x : Term) -> Bool {
  tautologyp(rewrite(x), Nil, Nil)
}

///|
/// Substitution used in the test
let boyer_subst0 : List[(Id, Term)] = Cons(
  (
    X,
    boyer_f(
      boyer_plus(boyer_plus(boyer_a, boyer_b), boyer_plus(boyer_c, boyer_zero)),
    ),
  ),
  Cons(
    (
      Y,
      boyer_f(
        boyer_times(boyer_times(boyer_a, boyer_b), boyer_plus(boyer_c, boyer_d)),
      ),
    ),
    Cons(
      (
        Z,
        boyer_f(
          boyer_reverse_(
            boyer_append_(boyer_append_(boyer_a, boyer_b), boyer_nil),
          ),
        ),
      ),
      Cons(
        (
          U,
          boyer_equal(
            boyer_plus(boyer_a, boyer_b),
            boyer_difference(boyer_x, boyer_y),
          ),
        ),
        Cons(
          (
            W,
            boyer_lessp(
              boyer_remainder(boyer_a, boyer_b),
              boyer_member(boyer_a, boyer_length_(boyer_b)),
            ),
          ),
          Nil,
        ),
      ),
    ),
  ),
)

///|
/// Theorem and tests
fn boyer_theorem(xxxx : Term) -> Term {
  boyer_implies(
    boyer_and_(
      boyer_implies(xxxx, boyer_y),
      boyer_and_(
        boyer_implies(boyer_y, boyer_z),
        boyer_and_(
          boyer_implies(boyer_z, boyer_u),
          boyer_implies(boyer_u, boyer_w),
        ),
      ),
    ),
    boyer_implies(boyer_x, boyer_w),
  )
}

///|
fn test0(xxxx : Term) -> Bool {
  tautp(apply_subst(boyer_subst0, boyer_theorem(xxxx)))
}

///|
fn test_boyer_nofib(n : Int) -> Bool {
  all_term(replicate_term(n, Var(X)), test0)
}
