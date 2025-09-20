///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
suberror EmptyList

///|
fn factorial(n : Int) -> Int {
  if n == 1 {
    1
  } else {
    n * factorial(n - 1)
  }
}

///|
fn[T] tail(l : List[T]) -> List[T] raise EmptyList {
  match l {
    Nil => raise EmptyList::EmptyList
    Cons(_, as_) => as_
  }
}

///|
fn[T] head(l : List[T]) -> T raise EmptyList {
  match l {
    Nil => raise EmptyList::EmptyList
    Cons(a, _) => a
  }
}

///|
fn[T] len(l : List[T]) -> Int {
  match l {
    Nil => 0
    Cons(_, xs) => 1 + len(xs)
  }
}

///|
fn[T] rev_loop(x : List[T], n : Int, y : List[T]) -> List[T] raise EmptyList {
  if n == 0 {
    y
  } else {
    rev_loop(tail(x), n - 1, Cons(head(x), y))
  }
}

///|
fn loop_sum(y : List[Int]) -> Int {
  match y {
    Nil => 0
    Cons(i, iss) => i + loop_sum(iss)
  }
}

///|
fn sumlists(x : List[List[Int]]) -> Int {
  match x {
    Nil => 0
    Cons(i, iss) => loop_sum(i) + sumlists(iss)
  }
}

///|
fn loop_one2n(n : Int, p : List[Int]) -> List[Int] {
  if n == 0 {
    p
  } else {
    loop_one2n(n - 1, Cons(n, p))
  }
}

///|
fn one2n(n : Int) -> List[Int] {
  loop_one2n(n, Nil)
}

///|
fn[T] list_tail(x : List[T], n : Int) -> List[T] raise EmptyList {
  if n == 0 {
    x
  } else {
    list_tail(tail(x), n - 1)
  }
}

///|
fn[T] f(
  n : Int,
  perms : List[List[T]],
  x : List[T],
) -> (List[List[T]], List[T]) raise EmptyList {
  let x = rev_loop(x, n, list_tail(x, n))
  let perms = Cons(x, perms)
  (perms, x)
}

///|
fn[T] loop_p(
  j : Int,
  perms : List[List[T]],
  x : List[T],
  n : Int,
) -> (List[List[T]], List[T]) raise EmptyList {
  if j == 0 {
    p(n - 1, perms, x)
  } else {
    let (perms, x) = p(n - 1, perms, x)
    let (perms, x) = f(n, perms, x)
    loop_p(j - 1, perms, x, n)
  }
}

///|
fn[T] p(
  n : Int,
  perms : List[List[T]],
  x : List[T],
) -> (List[List[T]], List[T]) raise EmptyList {
  if 1 < n {
    loop_p(n - 1, perms, x, n)
  } else {
    (perms, x)
  }
}

///|
fn[T] permutations(x0 : List[T]) -> List[List[T]] raise EmptyList {
  let (final_perms, _) = p(len(x0), Cons(x0, Nil), x0)
  final_perms
}

///|
fn[T] loop_work(
  m : Int,
  perms : List[List[T]],
) -> List[List[T]] raise EmptyList {
  if m == 0 {
    perms
  } else {
    loop_work(m - 1, permutations(head(perms)))
  }
}

///|
fn[T, U] run_benchmark(work : () -> T raise?, result_fn : (T) -> U) -> U raise? {
  result_fn(work())
}

///|
fn perm9(m : Int, n : Int) -> Bool raise EmptyList {
  run_benchmark(fn() { loop_work(m, permutations(one2n(n))) }, fn(result) {
    sumlists(result) == n * (n + 1) * factorial(n) / 2
  })
}

///|
pub fn main_loop(iters : Int, m : Int, n : Int) -> Unit {
  let res = perm9(m, n) catch { _ => false }
  if iters == 1 {
    if res {
      println("1")
    } else {
      println("0")
    }
  } else {
    main_loop(iters - 1, m, n)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let m = try? @strconv.parse_int(argv[2])
  let n = try? @strconv.parse_int(argv[3])
  main_loop(iters.unwrap(), m.unwrap(), n.unwrap())
}
