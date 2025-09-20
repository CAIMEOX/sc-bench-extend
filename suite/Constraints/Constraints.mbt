///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
pub struct Assign(Int, Int)

///|
pub struct CSP(Int, Int, ((Assign, Assign)) -> Bool)

///|
pub enum Tree[T] {
  Node(T, List[Tree[T]])
}

///|
pub enum ConflictSet {
  Known(List[Int])
  Unknown
}

///|
fn value(a : Assign) -> Int {
  let Assign(_, value) = a
  value
}

///|
fn level(a : Assign) -> Int {
  let Assign(varr, _) = a
  varr
}

///|
fn[T] label(t : Tree[T]) -> T {
  let Node(a, _) = t
  a
}

///|
fn[T, U] map_list(f : (T) -> U, ls : List[T]) -> List[U] {
  match ls {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), map_list(f, xs))
  }
}

///|
fn[T] all_list(f : (T) -> Bool, ls : List[T]) -> Bool {
  match ls {
    Nil => true
    Cons(x, xs) => f(x) && all_list(f, xs)
  }
}

///|
fn[T] filter_list(f : (T) -> Bool, ls : List[T]) -> List[T] {
  match ls {
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
fn[T] is_empty(ls : List[T]) -> Bool {
  match ls {
    Nil => true
    _ => false
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
fn[T, U, V] zip_with(f : ((T, U)) -> V, x : List[T], y : List[U]) -> List[V] {
  match (x, y) {
    (Nil, _) => Nil
    (_, Nil) => Nil
    (Cons(c, cs), Cons(p, ps)) => Cons(f((c, p)), zip_with(f, cs, ps))
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
fn[T] head(ls : List[T]) -> T {
  match ls {
    Nil => abort("Empty list has no head")
    Cons(x, _) => x
  }
}

///|
fn[T] tail(ls : List[T]) -> List[T] {
  match ls {
    Nil => abort("Empty list has no tail")
    Cons(_, xs) => xs
  }
}

///|
fn[T] at_index(ls : List[T], ind : Int) -> T {
  match ls {
    Nil => abort("Index out of bounds")
    Cons(x, xs) => if ind == 0 { x } else { at_index(xs, ind - 1) }
  }
}

///|
fn[T] rev_loop(ls : List[T], acc : List[T]) -> List[T] {
  match ls {
    Nil => acc
    Cons(p, ps) => rev_loop(ps, Cons(p, acc))
  }
}

///|
fn[T] reverse(ls : List[T]) -> List[T] {
  rev_loop(ls, Nil)
}

///|
fn[T] concat_loop(ls : List[List[T]], acc : List[T]) -> List[T] {
  match ls {
    Nil => rev_loop(acc, Nil)
    Cons(l, ls_tail) => concat_loop(ls_tail, rev_loop(l, acc))
  }
}

///|
fn[T] concat(lss : List[List[T]]) -> List[T] {
  concat_loop(lss, Nil)
}

///|
fn[T] append(l1 : List[T], l2 : List[T]) -> List[T] {
  match l1 {
    Nil => l2
    Cons(a, as_) => Cons(a, append(as_, l2))
  }
}

///|
fn[T, U] foldl(xs : List[T], acc : U, f : (U, T) -> U) -> U {
  match xs {
    Nil => acc
    Cons(h, t) => foldl(t, f(acc, h), f)
  }
}

///|
fn[T : Eq] in_list(i : T, ls : List[T]) -> Bool {
  match ls {
    Nil => false
    Cons(j, js) => if i == j { true } else { in_list(i, js) }
  }
}

///|
fn[T : Eq] not_elem(a : T, ls : List[T]) -> Bool {
  not(in_list(a, ls))
}

///|
fn[T] nub_by(f : ((T, T)) -> Bool, l : List[T]) -> List[T] {
  match l {
    Nil => Nil
    Cons(h, t) => Cons(h, nub_by(f, filter_list(fn(y) { not(f((h, y))) }, t)))
  }
}

///|
fn[T] delete_by(f : ((T, T)) -> Bool, x : T, ys : List[T]) -> List[T] {
  match ys {
    Nil => Nil
    Cons(y, ys_tail) =>
      if f((x, y)) {
        ys_tail
      } else {
        Cons(y, delete_by(f, x, ys_tail))
      }
  }
}

///|
fn[T] union_by(f : ((T, T)) -> Bool, l1 : List[T], l2 : List[T]) -> List[T] {
  append(l1, foldl(nub_by(f, l2), l1, fn(acc, y) { delete_by(f, y, acc) }))
}

///|
fn union(l1 : List[Int], l2 : List[Int]) -> List[Int] {
  union_by(
    fn(p : (Int, Int)) {
      let (x, y) = p
      x == y
    },
    l1,
    l2,
  )
}

///|
fn[T, U] map_tree(f : (T) -> U, t : Tree[T]) -> Tree[U] {
  let Node(l, ls) = t
  Node(f(l), map_list(fn(x) { map_tree(f, x) }, ls))
}

///|
fn[T, U] fold_tree(f : ((T, List[U])) -> U, n : Tree[T]) -> U {
  let Node(l, c) = n
  f((l, map_list(fn(x) { fold_tree(f, x) }, c)))
}

///|
fn[T] filter_tree(p : (T) -> Bool, n : Tree[T]) -> Tree[T] {
  let f = fn(param : (T, List[Tree[T]])) -> Tree[T] {
    let (a, cs) = param
    Node(a, filter_list(fn(x) { p(label(x)) }, cs))
  }
  fold_tree(f, n)
}

///|
fn[T] leaves(n : Tree[T]) -> List[T] {
  match n {
    Node(leaf, Nil) => Cons(leaf, Nil)
    Node(_, cs) => concat(map_list(fn(x) { leaves(x) }, cs))
  }
}

///|
fn[T] prune(f : (T) -> Bool, n : Tree[T]) -> Tree[T] {
  filter_tree(fn(x) { not(f(x)) }, n)
}

///|
fn max_level(ls : List[Assign]) -> Int {
  match ls {
    Nil => 0
    Cons(Assign(v, _), _) => v
  }
}

///|
fn complete(c : CSP, s : List[Assign]) -> Bool {
  let CSP(v, _, _) = c
  max_level(s) == v
}

///|
fn combine(
  ls : List[(List[Assign], ConflictSet)],
  acc : List[Int],
) -> List[Int] {
  match ls {
    Nil => acc
    Cons((s, Known(cs)), css) =>
      if not_elem(max_level(s), cs) {
        cs
      } else {
        combine(css, union(cs, acc))
      }
    Cons((_, Unknown), _) => acc
  }
}

///|
fn[T] init_tree(f : (T) -> List[T], x : T) -> Tree[T] {
  Node(x, map_list(fn(y) { init_tree(f, y) }, f(x)))
}

///|
fn to_assign(ls : List[Int], ss : List[Assign]) -> List[List[Assign]] {
  match ls {
    Nil => Nil
    Cons(j, t1) =>
      Cons(Cons(Assign(max_level(ss) + 1, j), ss), to_assign(t1, ss))
  }
}

///|
fn mk_tree(c : CSP) -> Tree[List[Assign]] {
  let CSP(vars, vals, _) = c
  let next = fn(ss : List[Assign]) {
    if max_level(ss) < vars {
      to_assign(enum_from_to(1, vals), ss)
    } else {
      Nil
    }
  }
  init_tree(next, Nil)
}

///|
fn collect(ls : List[ConflictSet]) -> List[Int] {
  match ls {
    Nil => Nil
    Cons(Known(cs), css) => union(cs, collect(css))
    Cons(Unknown, _) => Nil
  }
}

///|
fn known_solution(c : ConflictSet) -> Bool {
  match c {
    Known(Nil) => true
    Known(Cons(_, _)) => false
    Unknown => false
  }
}

///|
fn known_conflict(c : ConflictSet) -> Bool {
  match c {
    Known(Nil) => false
    Known(Cons(_, _)) => true
    Unknown => false
  }
}

///|
fn filter_known(ls : List[List[ConflictSet]]) -> List[List[ConflictSet]] {
  match ls {
    Nil => Nil
    Cons(vs, t1) =>
      if all_list(known_conflict, vs) {
        Cons(vs, filter_known(t1))
      } else {
        filter_known(t1)
      }
  }
}

///|
fn[A, B] domain_wipeout(
  _csp : A,
  t : Tree[((B, ConflictSet), List[List[ConflictSet]])],
) -> Tree[(B, ConflictSet)] {
  let f8 = fn(param) {
    let ((as_, cs), tbl) = param
    let wiped_domains = filter_known(tbl)
    let cs_ = if is_empty(wiped_domains) {
      cs
    } else {
      Known(collect(head(wiped_domains)))
    }
    (as_, cs_)
  }
  map_tree(f8, t)
}

///|
fn check_complete(csp : CSP, s : List[Assign]) -> ConflictSet {
  if complete(csp, s) {
    Known(Nil)
  } else {
    Unknown
  }
}

///|
fn earliest_inconsistency(c : CSP, aas : List[Assign]) -> (Int, Int)? {
  let CSP(_, _, rel) = c
  match aas {
    Nil => None
    Cons(a, as_) =>
      match filter_list(fn(x) { not(rel((a, x))) }, reverse(as_)) {
        Nil => None
        Cons(b, _) => Some((level(a), level(b)))
      }
  }
}

///|
fn lookup_cache(
  csp : CSP,
  t : Tree[(List[Assign], List[List[ConflictSet]])],
) -> Tree[((List[Assign], ConflictSet), List[List[ConflictSet]])] {
  let f5 = fn(param) {
    let (csp, (ls, tbl)) = param
    match ls {
      Nil => ((Nil, Unknown), tbl)
      Cons(a, as_) => {
        let table_entry = at_index(head(tbl), value(a) - 1)
        let cs = match table_entry {
          Unknown => check_complete(csp, Cons(a, as_))
          Known(_) => table_entry
        }
        ((Cons(a, as_), cs), tbl)
      }
    }
  }
  map_tree(fn(x) { f5((csp, x)) }, t)
}

///|
fn to_pairs(ls : List[Int], varrr : Int) -> List[(Int, Int)] {
  match ls {
    Nil => Nil
    Cons(valll, t2) => Cons((varrr, valll), to_pairs(t2, varrr))
  }
}

///|
fn n_pairs(ls : List[Int], vals : Int) -> List[List[(Int, Int)]] {
  match ls {
    Nil => Nil
    Cons(varrr, t1) =>
      Cons(to_pairs(enum_from_to(1, vals), varrr), n_pairs(t1, vals))
  }
}

///|
fn fill_table(
  s : List[Assign],
  c : CSP,
  tbl : List[List[ConflictSet]],
) -> List[List[ConflictSet]] {
  let CSP(vars, vals, rel) = c
  match s {
    Nil => tbl
    Cons(Assign(var_, val_), _) => {
      let f4 = fn(param : (ConflictSet, (Int, Int))) {
        let (cs, (varr, vall)) = param
        match cs {
          Known(_) => cs
          Unknown =>
            if not(rel((Assign(var_, val_), Assign(varr, vall)))) {
              Known(Cons(var_, Cons(varr, Nil)))
            } else {
              cs
            }
        }
      }
      zip_with(
        fn(p : (List[ConflictSet], List[(Int, Int)])) {
          let (x, y) = p
          zip_with(f4, x, y)
        },
        tbl,
        n_pairs(enum_from_to(var_ + 1, vars), vals),
      )
    }
  }
}

///|
fn cache_checks(
  csp : CSP,
  tbl : List[List[ConflictSet]],
  n : Tree[List[Assign]],
) -> Tree[(List[Assign], List[List[ConflictSet]])] {
  let Node(s, cs) = n
  Node(
    (s, tbl),
    map_list(fn(x) { cache_checks(csp, fill_table(s, csp, tail(tbl)), x) }, cs),
  )
}

///|
fn n_unknown(ls : List[Int], n : Int) -> List[List[ConflictSet]] {
  match ls {
    Nil => Nil
    Cons(_, t1) => Cons(to_unknown(enum_from_to(1, n)), n_unknown(t1, n))
  }
}

///|
fn to_unknown(ls : List[Int]) -> List[ConflictSet] {
  match ls {
    Nil => Nil
    Cons(_, t2) => Cons(Unknown, to_unknown(t2))
  }
}

///|
fn empty_table(c : CSP) -> List[List[ConflictSet]] {
  let CSP(vars, vals, _) = c
  Cons(Nil, n_unknown(enum_from_to(1, vars), vals))
}

///|
typealias (CSP, Tree[List[Assign]]) -> Tree[(List[Assign], ConflictSet)] as Labeler

///|
fn search(labeler : Labeler, csp : CSP) -> List[List[Assign]] {
  map_list(
    fn(p) {
      let (x, _) = p
      x
    },
    filter_list(
      fn(p) {
        let (_, x) = p
        known_solution(x)
      },
      leaves(
        prune(
          fn(p) {
            let (_, x) = p
            known_conflict(x)
          },
          labeler(csp, mk_tree(csp)),
        ),
      ),
    ),
  )
}

///|
fn safe(a1 : Assign, a2 : Assign) -> Bool {
  let Assign(i, m) = a1
  let Assign(j, n) = a2
  m != n && (i - j).abs() != (m - n).abs()
}

///|
fn queens(n : Int) -> CSP {
  CSP(n, n, fn(p) {
    let (x, y) = p
    safe(x, y)
  })
}

///|
fn bt(csp : CSP, t : Tree[List[Assign]]) -> Tree[(List[Assign], ConflictSet)] {
  let f3 = fn(s) {
    match earliest_inconsistency(csp, s) {
      Some((a, b)) => (s, Known(Cons(a, Cons(b, Nil))))
      None => (s, check_complete(csp, s))
    }
  }
  map_tree(f3, t)
}

///|
fn bm(csp : CSP, t : Tree[List[Assign]]) -> Tree[(List[Assign], ConflictSet)] {
  map_tree(
    fn(p) {
      let (x, _) = p
      x
    },
    lookup_cache(csp, cache_checks(csp, empty_table(csp), t)),
  )
}

///|
fn bj(
  csp : CSP,
  t : Tree[(List[Assign], ConflictSet)],
) -> Tree[(List[Assign], ConflictSet)] {
  let f6 = fn(param) {
    let ((a, conf), chs) = param
    match conf {
      Known(cs) => Node((a, Known(cs)), chs)
      Unknown => Node((a, Known(combine(map_list(label, chs), Nil))), chs)
    }
  }
  fold_tree(f6, t)
}

///|
fn bjbt(csp : CSP, t : Tree[List[Assign]]) -> Tree[(List[Assign], ConflictSet)] {
  bj(csp, bt(csp, t))
}

///|
fn bj_(
  csp : CSP,
  t : Tree[(List[Assign], ConflictSet)],
) -> Tree[(List[Assign], ConflictSet)] {
  let f6 = fn(param) {
    let ((a, conf), chs) = param
    match conf {
      Known(cs) => Node((a, Known(cs)), chs)
      Unknown => {
        let cs_ = Known(combine(map_list(label, chs), Nil))
        if known_conflict(cs_) {
          Node((a, cs_), Nil)
        } else {
          Node((a, cs_), chs)
        }
      }
    }
  }
  fold_tree(f6, t)
}

///|
fn bjbt_(
  csp : CSP,
  t : Tree[List[Assign]],
) -> Tree[(List[Assign], ConflictSet)] {
  bj_(csp, bt(csp, t))
}

///|
fn fc(csp : CSP, t : Tree[List[Assign]]) -> Tree[(List[Assign], ConflictSet)] {
  domain_wipeout(csp, lookup_cache(csp, cache_checks(csp, empty_table(csp), t)))
}

///|
fn try_(n : Int, algorithm : Labeler) -> Int {
  len(search(algorithm, queens(n)))
}

///|
fn test_constraints_nofib(n : Int) -> List[Int] {
  map_list(
    fn(x) { try_(n, x) },
    Cons(bt, Cons(bm, Cons(bjbt, Cons(bjbt_, Cons(fc, Nil))))),
  )
}

///|
pub fn main_loop(iters : Int, n : Int) -> Unit {
  let res = test_constraints_nofib(n)
  if iters == 1 {
    head(res) |> println
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
