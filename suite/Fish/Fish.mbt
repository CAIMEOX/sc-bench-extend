///|
suberror EmptyList

///|
#valtype
struct Vec(Int, Int)

///|
#valtype
struct Vec4(Int, Int, Int, Int)

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn vec_add(a : Vec, b : Vec) -> Vec {
  Vec(a.0 + b.0, a.1 + b.1)
}

///|
fn vec_sub(a : Vec, b : Vec) -> Vec {
  Vec(a.0 - b.0, a.1 - b.1)
}

///|
fn scale_vec(a : Vec, s : Int, b : Int) -> Vec {
  Vec(a.0 * s / b, a.1 * s / b)
}

///|
fn min(i1 : Int, i2 : Int) -> Int {
  if i1 < i2 {
    i1
  } else {
    i2
  }
}

///|
fn nil_(_a : Vec, _b : Vec, _c : Vec) -> List[Vec4] {
  Nil
}

///|
fn tup2(a : Vec, b : Vec) -> Vec4 {
  Vec4(a.0, a.1, b.0, b.1)
}

///|
fn[T] append(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(a, as_) => Cons(a, append(as_, l2))
  }
}

///|
fn[T, U] map(f : (T) -> U, ls : List[T]) -> List[U] {
  match ls {
    Nil => Nil
    Cons(v, vs) => Cons(f(v), map(f, vs))
  }
}

///|
fn[T] len(l : List[T]) -> Int {
  match l {
    Nil => 0
    Cons(_, vs) => 1 + len(vs)
  }
}

///|
fn[T] head(l : List[T]) -> T raise EmptyList {
  match l {
    Nil => raise EmptyList
    Cons(v, _) => v
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
fn p_tile() -> List[Vec4] {
  let p5 = Cons(
    Vec4(10, 4, 13, 5),
    Cons(
      Vec4(13, 5, 16, 4),
      Cons(Vec4(11, 0, 14, 2), Cons(Vec4(14, 2, 16, 2), Nil)),
    ),
  )
  let p4 = append(
    Cons(
      Vec4(8, 12, 16, 10),
      Cons(
        Vec4(8, 8, 12, 9),
        Cons(
          Vec4(12, 9, 16, 8),
          Cons(Vec4(9, 6, 12, 7), Cons(Vec4(12, 7, 16, 6), Nil)),
        ),
      ),
    ),
    p5,
  )
  let p3 = append(
    Cons(
      Vec4(10, 16, 12, 14),
      Cons(
        Vec4(12, 14, 16, 13),
        Cons(
          Vec4(12, 16, 13, 15),
          Cons(Vec4(13, 15, 16, 14), Cons(Vec4(14, 16, 16, 15), Nil)),
        ),
      ),
    ),
    p4,
  )
  let p2 = append(
    Cons(
      Vec4(4, 13, 0, 16),
      Cons(
        Vec4(0, 16, 6, 15),
        Cons(
          Vec4(6, 15, 8, 16),
          Cons(Vec4(8, 16, 12, 12), Cons(Vec4(12, 12, 16, 12), Nil)),
        ),
      ),
    ),
    p3,
  )
  let p1 = append(
    Cons(
      Vec4(4, 10, 7, 6),
      Cons(
        Vec4(7, 6, 4, 5),
        Cons(
          Vec4(11, 0, 10, 4),
          Cons(
            Vec4(10, 4, 9, 6),
            Cons(Vec4(9, 6, 8, 8), Cons(Vec4(8, 8, 4, 13), Nil)),
          ),
        ),
      ),
    ),
    p2,
  )
  append(
    Cons(
      Vec4(0, 3, 3, 4),
      Cons(
        Vec4(3, 4, 0, 8),
        Cons(
          Vec4(0, 8, 0, 3),
          Cons(Vec4(6, 0, 4, 4), Cons(Vec4(4, 5, 4, 10), Nil)),
        ),
      ),
    ),
    p1,
  )
}

///|
fn q_tile() -> List[Vec4] {
  let q7 = Cons(Vec4(0, 0, 0, 8), Cons(Vec4(0, 12, 0, 16), Nil))
  let q6 = append(
    Cons(
      Vec4(13, 0, 16, 6),
      Cons(
        Vec4(14, 0, 16, 4),
        Cons(
          Vec4(15, 0, 16, 2),
          Cons(Vec4(0, 0, 8, 0), Cons(Vec4(12, 0, 16, 0), Nil)),
        ),
      ),
    ),
    q7,
  )
  let q5 = append(
    Cons(
      Vec4(10, 0, 14, 11),
      Cons(
        Vec4(12, 0, 13, 4),
        Cons(
          Vec4(13, 4, 16, 8),
          Cons(Vec4(16, 8, 15, 10), Cons(Vec4(15, 10, 16, 16), Nil)),
        ),
      ),
    ),
    q6,
  )
  let q4 = append(
    Cons(
      Vec4(4, 5, 4, 7),
      Cons(
        Vec4(4, 0, 6, 5),
        Cons(
          Vec4(6, 5, 6, 7),
          Cons(Vec4(6, 0, 8, 5), Cons(Vec4(8, 5, 8, 8), Nil)),
        ),
      ),
    ),
    q5,
  )
  let q3 = append(
    Cons(
      Vec4(11, 15, 9, 13),
      Cons(
        Vec4(10, 10, 8, 12),
        Cons(
          Vec4(8, 12, 12, 12),
          Cons(Vec4(12, 12, 10, 10), Cons(Vec4(2, 0, 4, 5), Nil)),
        ),
      ),
    ),
    q4,
  )
  let q2 = append(
    Cons(
      Vec4(4, 16, 5, 14),
      Cons(
        Vec4(6, 16, 7, 15),
        Cons(
          Vec4(0, 10, 7, 11),
          Cons(Vec4(9, 13, 8, 15), Cons(Vec4(8, 15, 11, 15), Nil)),
        ),
      ),
    ),
    q3,
  )
  let q1 = append(
    Cons(
      Vec4(0, 12, 3, 13),
      Cons(
        Vec4(3, 13, 5, 14),
        Cons(
          Vec4(5, 14, 7, 15),
          Cons(Vec4(7, 15, 8, 16), Cons(Vec4(2, 16, 3, 13), Nil)),
        ),
      ),
    ),
    q2,
  )
  append(
    Cons(
      Vec4(0, 8, 4, 7),
      Cons(
        Vec4(4, 7, 6, 7),
        Cons(
          Vec4(6, 7, 8, 8),
          Cons(Vec4(8, 8, 12, 10), Cons(Vec4(12, 10, 16, 16), Nil)),
        ),
      ),
    ),
    q1,
  )
}

///|
fn r_tile() -> List[Vec4] {
  let r4 = Cons(
    Vec4(11, 16, 12, 12),
    Cons(
      Vec4(12, 12, 16, 8),
      Cons(
        Vec4(13, 13, 16, 10),
        Cons(Vec4(14, 14, 16, 12), Cons(Vec4(15, 15, 16, 14), Nil)),
      ),
    ),
  )
  let r3 = append(
    Cons(
      Vec4(2, 2, 8, 0),
      Cons(
        Vec4(3, 3, 8, 2),
        Cons(
          Vec4(8, 2, 12, 0),
          Cons(Vec4(5, 5, 12, 3), Cons(Vec4(12, 3, 16, 0), Nil)),
        ),
      ),
    ),
    r4,
  )
  let r2 = append(
    Cons(
      Vec4(5, 10, 2, 12),
      Cons(
        Vec4(2, 12, 0, 16),
        Cons(
          Vec4(16, 8, 12, 12),
          Cons(Vec4(12, 12, 11, 16), Cons(Vec4(1, 1, 4, 0), Nil)),
        ),
      ),
    ),
    r3,
  )
  let r1 = append(
    Cons(
      Vec4(16, 6, 11, 10),
      Cons(
        Vec4(11, 10, 6, 16),
        Cons(
          Vec4(16, 4, 14, 6),
          Cons(Vec4(14, 6, 8, 8), Cons(Vec4(8, 8, 5, 10), Nil)),
        ),
      ),
    ),
    r2,
  )
  append(
    Cons(
      Vec4(0, 0, 8, 8),
      Cons(
        Vec4(12, 12, 16, 16),
        Cons(
          Vec4(0, 4, 5, 10),
          Cons(Vec4(0, 8, 2, 12), Cons(Vec4(0, 12, 1, 14), Nil)),
        ),
      ),
    ),
    r1,
  )
}

///|
fn s_tile() -> List[Vec4] {
  let s5 = Cons(
    Vec4(15, 5, 13, 7),
    Cons(Vec4(13, 7, 15, 8), Cons(Vec4(15, 8, 15, 5), Nil)),
  )
  let s4 = append(
    Cons(
      Vec4(15, 9, 16, 8),
      Cons(
        Vec4(10, 16, 11, 10),
        Cons(
          Vec4(12, 4, 10, 6),
          Cons(Vec4(10, 6, 12, 7), Cons(Vec4(12, 7, 12, 4), Nil)),
        ),
      ),
    ),
    s5,
  )
  let s3 = append(
    Cons(
      Vec4(7, 8, 7, 13),
      Cons(
        Vec4(7, 13, 8, 16),
        Cons(
          Vec4(12, 16, 13, 13),
          Cons(Vec4(13, 13, 14, 11), Cons(Vec4(14, 11, 15, 9), Nil)),
        ),
      ),
    ),
    s4,
  )
  let s2 = append(
    Cons(
      Vec4(14, 11, 16, 12),
      Cons(
        Vec4(15, 9, 16, 10),
        Cons(
          Vec4(16, 0, 10, 4),
          Cons(Vec4(10, 4, 8, 6), Cons(Vec4(8, 6, 7, 8), Nil)),
        ),
      ),
    ),
    s3,
  )
  let s1 = append(
    Cons(
      Vec4(0, 8, 8, 6),
      Cons(
        Vec4(0, 10, 7, 8),
        Cons(
          Vec4(0, 12, 7, 10),
          Cons(Vec4(0, 14, 7, 13), Cons(Vec4(13, 13, 16, 14), Nil)),
        ),
      ),
    ),
    s2,
  )
  append(
    Cons(
      Vec4(0, 0, 4, 2),
      Cons(
        Vec4(4, 2, 8, 2),
        Cons(
          Vec4(8, 2, 16, 0),
          Cons(Vec4(0, 4, 2, 1), Cons(Vec4(0, 6, 7, 4), Nil)),
        ),
      ),
    ),
    s1,
  )
}

///|
fn grid(
  m : Int,
  n : Int,
  segments : List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  match segments {
    Nil => Nil
    Cons(Vec4(x0, y0, x1, y1), t) =>
      Cons(
        tup2(
          vec_add(vec_add(a, scale_vec(b, x0, m)), scale_vec(c, y0, n)),
          vec_add(vec_add(a, scale_vec(b, x1, m)), scale_vec(c, y1, n)),
        ),
        grid(m, n, t, a, b, c),
      )
  }
}

///|
fn tile_to_grid(tile : List[Vec4], a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  grid(16, 16, tile, a, b, c)
}

///|
fn p(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  tile_to_grid(p_tile(), a, b, c)
}

///|
fn q(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  tile_to_grid(q_tile(), a, b, c)
}

///|
fn r(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  tile_to_grid(r_tile(), a, b, c)
}

///|
fn s(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  tile_to_grid(s_tile(), a, b, c)
}

///|
fn rot(
  tile_fn : (Vec, Vec, Vec) -> List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  tile_fn(vec_add(a, b), c, vec_sub(Vec(0, 0), b))
}

///|
fn beside(
  m : Int,
  n : Int,
  p_fn : (Vec, Vec, Vec) -> List[Vec4],
  q_fn : (Vec, Vec, Vec) -> List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  append(
    p_fn(a, scale_vec(b, m, m + n), c),
    q_fn(vec_add(a, scale_vec(b, m, m + n)), scale_vec(b, n, n + m), c),
  )
}

///|
fn above(
  m : Int,
  n : Int,
  p_fn : (Vec, Vec, Vec) -> List[Vec4],
  q_fn : (Vec, Vec, Vec) -> List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  append(
    p_fn(vec_add(a, scale_vec(c, n, n + m)), b, scale_vec(c, m, n + m)),
    q_fn(a, b, scale_vec(c, n, m + n)),
  )
}

///|
fn quartet(
  a_fn : (Vec, Vec, Vec) -> List[Vec4],
  b_fn : (Vec, Vec, Vec) -> List[Vec4],
  c_fn : (Vec, Vec, Vec) -> List[Vec4],
  d_fn : (Vec, Vec, Vec) -> List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  above(
    1,
    1,
    fn(p5, p6, p7) { beside(1, 1, a_fn, b_fn, p5, p6, p7) },
    fn(p5, p6, p7) { beside(1, 1, c_fn, d_fn, p5, p6, p7) },
    a,
    b,
    c,
  )
}

///|
fn t(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(p, q, r, s, a, b, c)
}

///|
fn cycle_(
  p1 : (Vec, Vec, Vec) -> List[Vec4],
  a : Vec,
  b : Vec,
  c : Vec,
) -> List[Vec4] {
  quartet(
    p1,
    fn(a, b, c) { rot(fn(a, b, c) { rot(p1, a, b, c) }, a, b, c) },
    fn(a, b, c) { rot(p1, a, b, c) },
    fn(a, b, c) { rot(fn(a, b, c) { rot(p1, a, b, c) }, a, b, c) },
    a,
    b,
    c,
  )
}

///|
fn u(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  cycle_(fn(a, b, c) { rot(q, a, b, c) }, a, b, c)
}

///|
fn side1(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(nil_, nil_, fn(a, b, c) { rot(t, a, b, c) }, t, a, b, c)
}

///|
fn side2(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(side1, side1, fn(a, b, c) { rot(t, a, b, c) }, t, a, b, c)
}

///|
fn corner1(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(nil_, nil_, nil_, u, a, b, c)
}

///|
fn corner2(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(corner1, side1, fn(a, b, c) { rot(side1, a, b, c) }, u, a, b, c)
}

///|
fn pseudocorner(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  quartet(
    corner2,
    side2,
    fn(a, b, c) { rot(side2, a, b, c) },
    fn(a, b, c) { rot(t, a, b, c) },
    a,
    b,
    c,
  )
}

///|
fn pseudolimit(a : Vec, b : Vec, c : Vec) -> List[Vec4] {
  cycle_(pseudocorner, a, b, c)
}

///|
fn test_fish_nofib(n : Int) -> List[List[Vec4]] {
  map(
    fn(i) {
      let n_val = min(0, i)
      pseudolimit(Vec(0, 0), Vec(640 + n_val, 0), Vec(0, 640 + n_val))
    },
    enum_from_to(1, n),
  )
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let n = try? @strconv.parse_int(argv[1])
  let res = test_fish_nofib(n.unwrap())
  println(len(head(res) catch { EmptyList => Nil }))
}
