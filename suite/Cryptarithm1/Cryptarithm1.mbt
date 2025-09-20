///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn first(l : List[List[List[Int]]]) -> Int {
  match l {
    Cons(Cons(Cons(i, _), _), _) => i
    _ => -1
  }
}

///|
fn[T] append(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(a, as_) => Cons(a, append(as_, l2))
  }
}

///|
fn[T] take(n : Int, l : List[T]) -> List[T] {
  match l {
    Nil => Nil
    Cons(a, as_) => if n <= 0 { Nil } else { Cons(a, take(n - 1, as_)) }
  }
}

///|
fn[T] filter(l : List[T], f : (T) -> Bool) -> List[T] {
  match l {
    Nil => Nil
    Cons(a, as_) => if f(a) { Cons(a, filter(as_, f)) } else { filter(as_, f) }
  }
}

///|
fn[T, U] map(l : List[T], f : (T) -> U) -> List[U] {
  match l {
    Nil => Nil
    Cons(a, as_) => Cons(f(a), map(as_, f))
  }
}

///|
fn expand(a : Int, b : Int, c : Int, d : Int, e : Int, f : Int) -> Int {
  f + 10 * e + 100 * d + 1000 * c + 10000 * b + 100000 * a
}

///|
fn enum_from_to(from : Int, to_ : Int) -> List[Int] {
  if to_ >= from {
    Cons(from, enum_from_to(from + 1, to_))
  } else {
    Nil
  }
}

///|
fn condition(thirywelvn : List[Int]) -> Bool {
  match thirywelvn {
    Cons(
      t,
      Cons(
        h,
        Cons(
          i,
          Cons(r, Cons(y, Cons(w, Cons(e, Cons(l, Cons(v, Cons(n, Nil)))))))
        )
      )
    ) =>
      expand(t, h, i, r, t, y) + 5 * expand(t, w, e, l, v, e) ==
      expand(n, i, n, e, t, y)
    _ => false
  }
}

///|
fn[T] push_k(p1 : List[List[T]], k : T) -> List[List[T]] {
  match p1 {
    Nil => Nil
    Cons(h1, t1) => Cons(Cons(k, h1), push_k(t1, k))
  }
}

///|
fn[T] addj(j : T, ls : List[T]) -> List[List[T]] {
  match ls {
    Nil => Cons(Cons(j, Nil), Nil)
    Cons(k, ks) => Cons(Cons(j, Cons(k, ks)), push_k(addj(j, ks), k))
  }
}

///|
fn[T] addj_ls(p1 : List[List[T]], j : T) -> List[List[T]] {
  match p1 {
    Nil => Nil
    Cons(pjs, t1) => append(addj(j, pjs), addj_ls(t1, j))
  }
}

///|
fn[T] permutations(ls : List[T]) -> List[List[T]] {
  match ls {
    Nil => Cons(Nil, Nil)
    Cons(j, js) => addj_ls(permutations(js), j)
  }
}

///|
fn test_cryptarithm_nofib(n : Int) -> List[List[List[Int]]] {
  map(enum_from_to(1, n), fn(i) {
    let p0 = take(10, enum_from_to(0, 9 + i))
    filter(permutations(p0), condition)
  })
}

///|
pub fn main_loop(iters : Int, n : Int) -> Unit {
  let res = test_cryptarithm_nofib(n)
  if iters == 1 {
    first(res) |> println
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
