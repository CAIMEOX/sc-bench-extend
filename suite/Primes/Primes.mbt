///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] len(self : List[T]) -> Int {
  match self {
    Nil => 0
    Cons(_, xs) => 1 + xs.len()
  }
}

///|
fn interval_list(m : Int, n : Int) -> List[Int] {
  if m >= n {
    Nil
  } else {
    Cons(m, interval_list(m + 1, n))
  }
}

///|
fn remove_multiples(n : Int, xs : List[Int]) -> List[Int] {
  match xs {
    Nil => Nil
    Cons(y, ys) =>
      if y % n == 0 {
        remove_multiples(n, ys)
      } else {
        Cons(y, remove_multiples(n, ys))
      }
  }
}

///|
fn sieve(xs : List[Int]) -> List[Int] {
  match xs {
    Nil => Nil
    Cons(y, ys) => Cons(y, sieve(remove_multiples(y, ys)))
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = sieve(interval_list(2, n))
  if iters == 1 {
    println(res.len())
  } else {
    main_loop(iters - 1, n)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  main_loop(iters.unwrap(), n.unwrap())
}
