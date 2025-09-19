///|
suberror EmptyList

///|
fn abs_int(i : Int) -> Int {
  if i < 0 {
    -i
  } else {
    i
  }
}

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[A, B] map(f : (A) -> B, l : List[A]) -> List[B] {
  match l {
    Nil => Nil
    Cons(a, as_) => Cons(f(a), map(f, as_))
  }
}

///|
fn[A] append(l1 : List[A], l2 : List[A]) -> List[A] {
  match l1 {
    Nil => l2
    Cons(a, as_) => Cons(a, append(as_, l2))
  }
}

///|
fn enum_from_to(from : Int, to_ : Int) -> List[Int] {
  if from <= to_ {
    Cons(from, enum_from_to(from + 1, to_))
  } else {
    Nil
  }
}

///|
fn max(ls : List[Int]) -> Int raise EmptyList {
  match ls {
    Nil => raise EmptyList
    Cons(x, Nil) => x
    Cons(x, Cons(y, ys)) =>
      if x < y {
        max(Cons(y, ys))
      } else {
        max(Cons(x, ys))
      }
  }
}

///|
fn quot_rem(a : Int, b : Int) -> (Int, Int) {
  (a / b, a % b)
}

///|
fn g(u : (Int, Int, Int), v : (Int, Int, Int)) -> (Int, Int, Int) {
  let (u1, u2, u3) = u
  let (v1, v2, v3) = v
  if v3 == 0 {
    (u3, u1, u2)
  } else {
    let (q, r) = quot_rem(u3, v3)
    g(v, (u1 - q * v1, u2 - q * v2, r))
  }
}

///|
fn gcd_e(x : Int, y : Int) -> (Int, Int, Int) {
  if x == 0 {
    (y, 0, 1)
  } else {
    g((1, 0, x), (0, 1, y))
  }
}

///|
fn[A, B] to_pair(i : A, l : List[B]) -> List[(A, B)] {
  match l {
    Nil => Nil
    Cons(x, xs) => Cons((i, x), to_pair(i, xs))
  }
}

///|
fn[A, B] cartesian_product(l1 : List[A], l2 : List[B]) -> List[(A, B)] {
  match l1 {
    Nil => Nil
    Cons(a, as_) => append(to_pair(a, l2), cartesian_product(as_, l2))
  }
}

///|
fn test_gcd_nofib(d : Int) -> Int raise EmptyList {
  let ns = enum_from_to(5000, d + 5000)
  let ms = enum_from_to(10000, 10000 + d)
  let triples : List[(Int, Int, (Int, Int, Int))] = map(
    fn(xy : (Int, Int)) { (xy.0, xy.1, gcd_e(xy.0, xy.1)) },
    cartesian_product(ns, ms),
  )
  let rs = map(
    fn(tp) {
      let (_d1, _d2, (gg, u, v)) = tp
      abs_int(gg + u + v)
    },
    triples,
  )
  max(rs)
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = test_gcd_nofib(n) catch { EmptyList => -1 }
  if iters == 1 {
    println(res)
  } else {
    main_loop(iters - 1, n)
  }
}

///|
fn main {
  let argv = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  main_loop(iters.unwrap(), n.unwrap())
}
