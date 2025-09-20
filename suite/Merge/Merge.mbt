///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] head(l : List[T]) -> T {
  match l {
    Nil => abort("EmptyList")
    Cons(x, _) => x
  }
}

///|
fn[T] rev_loop(l : List[T], acc : List[T]) -> List[T] {
  match l {
    Nil => acc
    Cons(p, ps) => rev_loop(ps, Cons(p, acc))
  }
}

///|
fn[T] rev(l : List[T]) -> List[T] {
  rev_loop(l, Nil)
}

///|
fn[T] tabulate_loop(
  n : Int,
  len : Int,
  f : (Int) -> T,
  acc : List[T],
) -> List[T] {
  if n < len {
    tabulate_loop(n + 1, len, f, Cons(f(n), acc))
  } else {
    rev(acc)
  }
}

///|
fn[T] tabulate(n : Int, f : (Int) -> T) -> List[T] {
  if n < 0 {
    Nil
  } else {
    tabulate_loop(0, n, f, Nil)
  }
}

///|
fn merge(l1 : List[Int], l2 : List[Int]) -> List[Int] {
  match (l1, l2) {
    (Nil, _) => l2
    (_, Nil) => l1
    (Cons(x1, xs1), Cons(x2, xs2)) =>
      if x1 <= x2 {
        Cons(x1, merge(xs1, l2))
      } else {
        Cons(x2, merge(l1, xs2))
      }
  }
}

///|
pub fn main_loop(iters : Int, l1 : List[Int], l2 : List[Int]) -> Unit {
  let res = merge(l1, l2)
  if iters == 1 {
    head(res) |> println
  } else {
    main_loop(iters - 1, l1, l2)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  let l1 = tabulate(n.unwrap(), fn(i) { i * 2 })
  let l2 = tabulate(n.unwrap(), fn(i) { i * 2 + 1 })
  main_loop(iters.unwrap(), l1, l2)
}
