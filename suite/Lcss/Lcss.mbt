///|
suberror EmptyList

///|
fn[A, B] snd(a : (A, B)) -> B {
  match a {
    (_, b) => b
  }
}

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] rev_loop(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(i, iss) => rev_loop(iss, Cons(i, l2))
  }
}

///|
fn[T] rev(l : List[T]) -> List[T] {
  rev_loop(l, Nil)
}

///|
fn[T, U] map(f : (T) -> U, l : List[T]) -> List[U] {
  match l {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), map(f, xs))
  }
}

///|
fn[T] head(l : List[T]) -> T raise EmptyList {
  match l {
    Nil => raise EmptyList
    Cons(h, _) => h
  }
}

///|
fn[T] take(n : Int, ls : List[T]) -> List[T] {
  match ls {
    Nil => Nil
    Cons(i, iss) => if n == 0 { Nil } else { Cons(i, take(n - 1, iss)) }
  }
}

///|
fn[T] drop(n : Int, ls : List[T]) -> List[T] {
  if n == 0 {
    ls
  } else {
    match ls {
      Nil => Nil
      Cons(_, iss) => drop(n - 1, iss)
    }
  }
}

///|
fn[T] is_nil(ls : List[T]) -> Bool {
  match ls {
    Nil => true
    _ => false
  }
}

///|
fn[T] is_singleton(ls : List[T]) -> T? {
  match ls {
    Cons(x, Nil) => Some(x)
    _ => None
  }
}

///|
fn[T] len(ls : List[T]) -> Int {
  match ls {
    Nil => 0
    Cons(_, xs) => 1 + len(xs)
  }
}

///|
fn[T, U] zip(xs : List[T], ys : List[U]) -> List[(T, U)] {
  match (xs, ys) {
    (Nil, _) => Nil
    (_, Nil) => Nil
    (Cons(x, xs), Cons(y, ys)) => Cons((x, y), zip(xs, ys))
  }
}

///|
fn in_list(x : Int, ls : List[Int]) -> Bool {
  match ls {
    Nil => false
    Cons(y, ys) => if x == y { true } else { in_list(x, ys) }
  }
}

///|
fn enum_from_then_to(from : Int, th : Int, to_ : Int) -> List[Int] {
  if from <= to_ {
    Cons(from, enum_from_then_to(th, 2 * th - from, to_))
  } else {
    Nil
  }
}

///|
fn add_zero(ls : List[Int]) -> List[(Int, Int)] {
  match ls {
    Nil => Nil
    Cons(h, t) => Cons((h, 0), add_zero(t))
  }
}

///|
fn algb2(
  x : Int,
  k0j1 : Int,
  k1j1 : Int,
  yss : List[(Int, Int)],
) -> List[(Int, Int)] {
  match yss {
    Nil => Nil
    Cons((y, k0j), ys) => {
      let kjcurr = if x == y {
        k0j1 + 1
      } else if k1j1 > k0j {
        k1j1
      } else {
        k0j
      }
      Cons((y, kjcurr), algb2(x, k0j, kjcurr, ys))
    }
  }
}

///|
fn algb1(xss : List[Int], yss : List[(Int, Int)]) -> List[Int] {
  match xss {
    Nil => map(snd, yss)
    Cons(x, xs) => algb1(xs, algb2(x, 0, 0, yss))
  }
}

///|
fn algb(xs : List[Int], ys : List[Int]) -> List[Int] {
  Cons(0, algb1(xs, add_zero(ys)))
}

///|
fn findk(k : Int, km : Int, m : Int, ls : List[(Int, Int)]) -> Int {
  match ls {
    Nil => km
    Cons((x, y), xys) =>
      if m <= x + y {
        findk(k + 1, k, x + y, xys)
      } else {
        findk(k + 1, km, m, xys)
      }
  }
}

///|
fn algc(
  m : Int,
  n : Int,
  xs : List[Int],
  ys : List[Int],
) -> (List[Int]) -> List[Int] {
  if is_nil(ys) {
    fn(x) { x }
  } else {
    match is_singleton(xs) {
      Some(x) => if in_list(x, ys) { fn(t) { Cons(x, t) } } else { fn(x) { x } }
      None => {
        let m2 = m / 2
        let xs1 = take(m2, xs)
        let xs2 = drop(m2, xs)
        let l1 = algb(xs1, ys)
        let l2 = rev(algb(rev(xs2), rev(ys)))
        let k = findk(0, 0, -1, zip(l1, l2))
        fn(x) {
          let f1 = algc(m - m2, n - k, xs2, drop(k, ys))
          let f2 = algc(m2, k, xs1, take(k, ys))
          f2(f1(x))
        }
      }
    }
  }
}

///|
fn lcss(xs : List[Int], ys : List[Int]) -> List[Int] {
  algc(len(xs), len(ys), xs, ys)(Nil)
}

///|
fn lcss_main(a : Int, b : Int, c : Int, d : Int, e : Int, f : Int) -> List[Int] {
  lcss(enum_from_then_to(a, b, c), enum_from_then_to(d, e, f))
}

///|
fn test_lcss_nofib(c : Int, f : Int) -> List[Int] {
  lcss_main(1, 2, c, 100, 101, f)
}

///|
fn main_loop(iters : Int, c : Int, f : Int) -> Unit {
  let res = test_lcss_nofib(c, f)
  if iters == 1 {
    println(head(res)) catch {
      EmptyList => println(0)
    }
  } else {
    main_loop(iters - 1, c, f)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let c = try? @strconv.parse_int(argv[2])
  let f = try? @strconv.parse_int(argv[3])
  main_loop(iters.unwrap(), c.unwrap(), f.unwrap())
}
