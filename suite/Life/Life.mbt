///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
pub struct Gen(List[(Int, Int)])

///|
fn pair_eq(p1 : (Int, Int), p2 : (Int, Int)) -> Bool {
  let (fst1, snd1) = p1
  let (fst2, snd2) = p2
  fst1 == fst2 && snd1 == snd2
}

///|
fn[T, U] fold_list(xs : List[T], acc : U, f : (U, T) -> U) -> U {
  match xs {
    Nil => acc
    Cons(h, t) => fold_list(t, f(acc, h), f)
  }
}

///|
fn[T] revonto(x : List[T], y : List[T]) -> List[T] {
  fold_list(x, y, fn(t : List[T], h : T) -> List[T] { Cons(h, t) })
}

///|
fn[T, U] collect_accum(
  sofar : List[U],
  xs : List[T],
  f : (T) -> List[U],
) -> List[U] {
  match xs {
    Nil => sofar
    Cons(p, xs_tail) => collect_accum(revonto(sofar, f(p)), xs_tail, f)
  }
}

///|
fn[T, U] collect(l : List[T], f : (T) -> List[U]) -> List[U] {
  collect_accum(Nil, l, f)
}

///|
fn[T] append_list(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(x, xs) => Cons(x, append_list(xs, l2))
  }
}

///|
fn[T, U] map_list(f : (T) -> U, l : List[T]) -> List[U] {
  match l {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), map_list(f, xs))
  }
}

///|
fn[T] exists_list(f : (T) -> Bool, l : List[T]) -> Bool {
  match l {
    Nil => false
    Cons(x, xs) => if f(x) { true } else { exists_list(f, xs) }
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
fn mem(l : List[(Int, Int)], p : (Int, Int)) -> Bool {
  exists_list(fn(p1) { pair_eq(p, p1) }, l)
}

///|
fn[T] filter_list(f : (T) -> Bool, l : List[T]) -> List[T] {
  match l {
    Nil => Nil
    Cons(x, xs) =>
      if f(x) {
        Cons(x, filter_list(f, xs))
      } else {
        filter_list(f, xs)
      }
  }
}

///|
fn diff(x : List[(Int, Int)], y : List[(Int, Int)]) -> List[(Int, Int)] {
  filter_list(fn(p) { not(mem(y, p)) }, x)
}

///|
fn alive(g : Gen) -> List[(Int, Int)] {
  let Gen(livecoords) = g
  livecoords
}

///|
// Returns the 8 neighbors of a given coordinate.
fn neighbors(p : (Int, Int)) -> List[(Int, Int)] {
  let (fst, snd) = p
  Cons(
    (fst - 1, snd - 1),
    Cons(
      (fst - 1, snd),
      Cons(
        (fst - 1, snd + 1),
        Cons(
          (fst, snd - 1),
          Cons(
            (fst, snd + 1),
            Cons(
              (fst + 1, snd - 1),
              Cons((fst + 1, snd), Cons((fst + 1, snd + 1), Nil)),
            ),
          ),
        ),
      ),
    ),
  )
}

///|
fn twoorthree(n : Int) -> Bool {
  n == 2 || n == 3
}

///|
fn collect_neighbors(
  xover : List[(Int, Int)],
  x3 : List[(Int, Int)],
  x2 : List[(Int, Int)],
  x1 : List[(Int, Int)],
  xs : List[(Int, Int)],
) -> List[(Int, Int)] {
  match xs {
    Nil => diff(x3, xover)
    Cons(a, x) =>
      if mem(xover, a) {
        collect_neighbors(xover, x3, x2, x1, x)
      } else if mem(x3, a) {
        collect_neighbors(Cons(a, xover), x3, x2, x1, x)
      } else if mem(x2, a) {
        collect_neighbors(xover, Cons(a, x3), x2, x1, x)
      } else if mem(x1, a) {
        collect_neighbors(xover, x3, Cons(a, x2), x1, x)
      } else {
        collect_neighbors(xover, x3, x2, Cons(a, x1), x)
      }
  }
}

///|
fn occurs3(l : List[(Int, Int)]) -> List[(Int, Int)] {
  collect_neighbors(Nil, Nil, Nil, Nil, l)
}

///|
fn nextgen(g : Gen) -> Gen {
  let living = alive(g)
  let isalive = fn(p) { mem(living, p) }
  let liveneighbors = fn(p) { len(filter_list(isalive, neighbors(p))) }
  let survivors = filter_list(fn(p) { twoorthree(liveneighbors(p)) }, living)
  let newbrnlist = collect(living, fn(p) {
    filter_list(fn(n) { not(isalive(n)) }, neighbors(p))
  })
  let newborn = occurs3(newbrnlist)
  Gen(append_list(survivors, newborn))
}

///|
fn nthgen(g : Gen, i : Int) -> Gen {
  if i == 0 {
    g
  } else {
    nthgen(nextgen(g), i - 1)
  }
}

///|
let gun : Gen = {
  let r9 = Cons((9, 29), Cons((9, 30), Cons((9, 31), Cons((9, 32), Nil))))
  let r8 = Cons(
    (8, 20),
    Cons(
      (8, 28),
      Cons(
        (8, 29),
        Cons((8, 30), Cons((8, 31), Cons((8, 40), Cons((8, 41), r9)))),
      ),
    ),
  )
  let r7 = Cons(
    (7, 19),
    Cons(
      (7, 21),
      Cons((7, 28), Cons((7, 31), Cons((7, 40), Cons((7, 41), r8)))),
    ),
  )
  let r6 = Cons(
    (6, 7),
    Cons(
      (6, 8),
      Cons(
        (6, 18),
        Cons(
          (6, 22),
          Cons(
            (6, 23),
            Cons(
              (6, 28),
              Cons((6, 29), Cons((6, 30), Cons((6, 31), Cons((6, 36), r7)))),
            ),
          ),
        ),
      ),
    ),
  )
  let r5 = Cons(
    (5, 7),
    Cons(
      (5, 8),
      Cons(
        (5, 18),
        Cons(
          (5, 22),
          Cons(
            (5, 23),
            Cons(
              (5, 29),
              Cons((5, 30), Cons((5, 31), Cons((5, 32), Cons((5, 36), r6)))),
            ),
          ),
        ),
      ),
    ),
  )
  let r4 = Cons((4, 18), Cons((4, 22), Cons((4, 23), Cons((4, 32), r5))))
  let r3 = Cons((3, 19), Cons((3, 21), r4))
  let r2 = Cons((2, 20), r3)
  Gen(r2)
}

///|
fn at_pos(coordlist : List[(Int, Int)], p2 : (Int, Int)) -> List[(Int, Int)] {
  let (fst2, snd2) = p2
  let mov = fn(p1 : (Int, Int)) -> (Int, Int) {
    let (fst1, snd1) = p1
    (fst1 + fst2, snd1 + snd2)
  }
  map_list(mov, coordlist)
}

///|
let center_line : Int = 5

///|
let bail : List[(Int, Int)] = Cons(
  (0, 0),
  Cons((0, 1), Cons((1, 0), Cons((1, 1), Nil))),
)

///|
let shuttle : List[(Int, Int)] = {
  let r4 = Cons((4, 1), Cons((4, 0), Cons((4, 5), Cons((4, 6), Nil))))
  let r3 = Cons((3, 2), Cons((3, 3), Cons((3, 4), r4)))
  let r2 = Cons((2, 1), Cons((2, 5), r3))
  let r1 = Cons((1, 2), Cons((1, 4), r2))
  Cons((0, 3), r1)
}

///|
let non_steady : Gen = Gen(
  append_list(
    append_list(at_pos(bail, (1, center_line)), at_pos(bail, (21, center_line))),
    at_pos(shuttle, (6, center_line - 2)),
  ),
)

///|
pub fn go_gun(steps : Int) -> Gen {
  nthgen(gun, steps)
}

///|
pub fn go_shuttle(steps : Int) -> Gen {
  nthgen(non_steady, steps)
}

///|
pub fn go_loop(iters : Int, steps : Int, go : (Int) -> Gen) -> Int {
  let res = go(steps)
  if iters == 1 {
    len(alive(res))
  } else {
    go_loop(iters - 1, steps, go)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let steps = try? @strconv.parse_int(argv[2])
  let gun_res = go_loop(iters.unwrap(), steps.unwrap(), go_gun)
  let shuttle_res = go_loop(iters.unwrap(), steps.unwrap(), go_shuttle)
  println(gun_res)
  println(shuttle_res)
}
