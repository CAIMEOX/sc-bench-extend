///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] len(l : List[T]) -> Int {
  match l {
    Nil => 0
    Cons(_, xs) => 1 + len(xs)
  }
}

///|
fn[T] append(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(hd, tl) => Cons(hd, append(tl, l2))
  }
}

///|
fn safe(x : Int, d : Int, l : List[Int]) -> Bool {
  match l {
    Nil => true
    Cons(q, l_tail) =>
      x != q && x != q + d && x != q - d && safe(x, d + 1, l_tail)
  }
}

///|
fn check(
  l : List[List[Int]],
  acc : List[List[Int]],
  q : Int,
) -> List[List[Int]] {
  match l {
    Nil => acc
    Cons(b, bs) =>
      if safe(q, 1, b) {
        check(bs, Cons(Cons(q, b), acc), q)
      } else {
        check(bs, acc, q)
      }
  }
}

///|
fn enumerate(
  q : Int,
  acc : List[List[Int]],
  bs : List[List[Int]],
) -> List[List[Int]] {
  if q == 0 {
    acc
  } else {
    let res = check(bs, Nil, q)
    enumerate(q - 1, append(res, acc), bs)
  }
}

///|
fn gen(n : Int, nq : Int) -> List[List[Int]] {
  if n == 0 {
    Cons(Nil, Nil)
  } else {
    let bs = gen(n - 1, nq)
    enumerate(nq, Nil, bs)
  }
}

///|
fn nsoln(n : Int) -> Int {
  len(gen(n, n))
}

///|
pub fn main_loop(iters : Int, n : Int) -> Unit {
  let res = nsoln(n)
  if iters == 1 {
    println(res)
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
