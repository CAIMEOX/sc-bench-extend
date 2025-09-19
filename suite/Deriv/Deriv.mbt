///|
suberror BadExpr

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
enum Expr {
  Add(List[Expr])
  Mul(List[Expr])
  Sub(List[Expr])
  Div(List[Expr])
  Num(Int)
  X
}

///|
/// map that allows the mapper to raise BadExpr
fn[A, B] map_list_raise(
  l : List[A],
  f : (A) -> B raise BadExpr,
) -> List[B] raise BadExpr {
  match l {
    Nil => Nil
    Cons(a, as_) => Cons(f(a), map_list_raise(as_, f))
  }
}

///|
/// structural equality for expressions
fn equal(a : Expr, b : Expr) -> Bool {
  match (a, b) {
    (Add(sums1), Add(sums2)) => equal_list(sums1, sums2)
    (Sub(subs1), Sub(subs2)) => equal_list(subs1, subs2)
    (Mul(muls1), Mul(muls2)) => equal_list(muls1, muls2)
    (Div(divs1), Div(divs2)) => equal_list(divs1, divs2)
    (Num(i), Num(j)) => i == j
    (X, X) => true
    _ => false
  }
}

///|
fn equal_list(ls1 : List[Expr], ls2 : List[Expr]) -> Bool {
  match (ls1, ls2) {
    (Nil, Nil) => true
    (Cons(e1, es1), Cons(e2, es2)) => equal(e1, e2) && equal_list(es1, es2)
    _ => false
  }
}

///|
/// derivative function
fn deriv(e : Expr) -> Expr raise BadExpr {
  match e {
    Add(sums) => Add(map_list_raise(sums, x => deriv(x)))
    Sub(subs) => Sub(map_list_raise(subs, x => deriv(x)))
    Mul(muls) =>
      Mul(
        Cons(
          e,
          Cons(
            Add(map_list_raise(muls, x => Div(Cons(deriv(x), Cons(x, Nil))))),
            Nil,
          ),
        ),
      )
    Div(Cons(x, Cons(y, Nil))) =>
      Sub(
        Cons(
          Div(Cons(deriv(x), Cons(y, Nil))),
          Cons(
            Div(Cons(x, Cons(Mul(Cons(y, Cons(y, Cons(deriv(y), Nil)))), Nil))),
            Nil,
          ),
        ),
      )
    Div(_) => raise BadExpr
    Num(_) => Num(0)
    X => Num(1)
  }
}

///|
/// constructors used in the benchmark
fn mk_exp(a : Expr, b : Expr) -> Expr {
  Add(
    Cons(
      Mul(Cons(Num(3), Cons(X, Cons(X, Nil)))),
      Cons(
        Mul(Cons(a, Cons(X, Cons(X, Nil)))),
        Cons(Mul(Cons(b, Cons(X, Nil))), Cons(Num(5), Nil)),
      ),
    ),
  )
}

///|
fn mk_ans(a : Expr, b : Expr) -> Expr {
  Add(
    Cons(
      Mul(
        Cons(
          Mul(Cons(Num(3), Cons(X, Cons(X, Nil)))),
          Cons(
            Add(
              Cons(
                Div(Cons(Num(0), Cons(Num(3), Nil))),
                Cons(
                  Div(Cons(Num(1), Cons(X, Nil))),
                  Cons(Div(Cons(Num(1), Cons(X, Nil))), Nil),
                ),
              ),
            ),
            Nil,
          ),
        ),
      ),
      Cons(
        Mul(
          Cons(
            Mul(Cons(a, Cons(X, Cons(X, Nil)))),
            Cons(
              Add(
                Cons(
                  Div(Cons(Num(0), Cons(a, Nil))),
                  Cons(
                    Div(Cons(Num(1), Cons(X, Nil))),
                    Cons(Div(Cons(Num(1), Cons(X, Nil))), Nil),
                  ),
                ),
              ),
              Nil,
            ),
          ),
        ),
        Cons(
          Mul(
            Cons(
              Mul(Cons(b, Cons(X, Nil))),
              Cons(
                Add(
                  Cons(
                    Div(Cons(Num(0), Cons(b, Nil))),
                    Cons(Div(Cons(Num(1), Cons(X, Nil))), Nil),
                  ),
                ),
                Nil,
              ),
            ),
          ),
          Cons(Num(0), Nil),
        ),
      ),
    ),
  )
}

///|
/// driver
fn main_loop(iters : Int, n : Int, m : Int) -> Unit raise BadExpr {
  let res = deriv(mk_exp(Num(n), Num(m)))
  let expected = mk_ans(Num(n), Num(m))
  if iters == 1 {
    if equal(res, expected) {
      println(1)
    } else {
      println(0)
    }
  } else {
    main_loop(iters - 1, n, m)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  let m = try? @strconv.parse_int(argv[3])
  main_loop(iters.unwrap(), n.unwrap(), m.unwrap()) catch {
    BadExpr => println(0)
  }
}
