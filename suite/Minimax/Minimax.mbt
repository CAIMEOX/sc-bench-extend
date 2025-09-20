///|
pub enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
suberror BadIndex

///|
suberror EmptyList

///|
pub enum Player {
  X
  O
}

///|
pub struct Rose[T](T, List[Rose[T]])

///|
typealias List[Player?] as Board

///|
fn[T] mk_leaf(p : T) -> Rose[T] {
  Rose(p, Nil)
}

///|
fn[T] top(tree : Rose[T]) -> T {
  let Rose(p, _) = tree
  p
}

///|
fn[T, U] snd(pair : (T, U)) -> U {
  let (_, x) = pair
  x
}

///|
fn player_equal(p1 : Player, p2 : Player) -> Bool {
  match (p1, p2) {
    (X, X) => true
    (O, O) => true
    _ => false
  }
}

///|
fn other(p : Player) -> Player {
  match p {
    X => O
    O => X
  }
}

///|
fn[T] is_some(p : T?) -> Bool {
  p is Some(_)
}

///|
fn[T] head(l : List[T]) -> T raise EmptyList {
  match l {
    Nil => raise EmptyList
    Cons(x, _) => x
  }
}

///|
fn[T] tail(l : List[T]) -> List[T] raise EmptyList {
  match l {
    Nil => raise EmptyList::EmptyList
    Cons(_, xs) => xs
  }
}

///|
fn[T] rev_acc(l : List[T], acc : List[T]) -> List[T] {
  match l {
    Nil => acc
    Cons(x, xs) => rev_acc(xs, Cons(x, acc))
  }
}

///|
fn[T] rev(l : List[T]) -> List[T] {
  rev_acc(l, Nil)
}

///|
fn[T, U] map(f : (T) -> U raise?, l : List[T]) -> List[U] raise? {
  match l {
    Nil => Nil
    Cons(x, xs) => Cons(f(x), map(f, xs))
  }
}

///|
fn[T, U] fold(f : (U, T) -> U, xs : List[T], acc : U) -> U {
  match xs {
    Nil => acc
    Cons(h, t) => fold(f, t, f(acc, h))
  }
}

///|
fn[T] tabulate_loop(n : Int, len : Int, f : () -> T) -> List[T] {
  if n == len {
    Nil
  } else {
    Cons(f(), tabulate_loop(n + 1, len, f))
  }
}

///|
fn[T] tabulate(len : Int, f : () -> T) -> List[T] {
  if len < 0 {
    Nil
  } else {
    tabulate_loop(0, len, f)
  }
}

///|
fn[T] nth(l : List[T], i : Int) -> T raise BadIndex {
  match l {
    Nil => raise BadIndex::BadIndex
    Cons(p, ps) => if i == 0 { p } else { nth(ps, i - 1) }
  }
}

///|
fn[T] find(l : List[T?], i : Int) -> T? {
  match l {
    Nil => None
    Cons(p, ps) => if i == 0 { p } else { find(ps, i - 1) }
  }
}

///|
fn[T] exists(f : (T) -> Bool, l : List[T]) -> Bool {
  match l {
    Nil => false
    Cons(x, xs) => if f(x) { true } else { exists(f, xs) }
  }
}

///|
fn[T] all(f : (T) -> Bool, l : List[T]) -> Bool {
  match l {
    Nil => true
    Cons(x, xs) => if f(x) { all(f, xs) } else { false }
  }
}

///|
let empty_board : Board = tabulate(9, fn() { None })

///|
fn is_full(board : Board) -> Bool {
  all(is_some, board)
}

///|
fn player_occupies(p : Player, board : Board, i : Int) -> Bool {
  match find(board, i) {
    None => false
    Some(p0) => player_equal(p, p0)
  }
}

///|
fn has_trip(board : Board, p : Player, l : List[Int]) -> Bool {
  all(fn(i) { player_occupies(p, board, i) }, l)
}

///|
let rows : List[List[Int]] = Cons(
  Cons(0, Cons(1, Cons(2, Nil))),
  Cons(
    Cons(3, Cons(4, Cons(5, Nil))),
    Cons(Cons(6, Cons(7, Cons(8, Nil))), Nil),
  ),
)

///|
let cols : List[List[Int]] = Cons(
  Cons(0, Cons(3, Cons(6, Nil))),
  Cons(
    Cons(1, Cons(4, Cons(7, Nil))),
    Cons(Cons(2, Cons(5, Cons(8, Nil))), Nil),
  ),
)

///|
let diags : List[List[Int]] = Cons(
  Cons(0, Cons(4, Cons(8, Nil))),
  Cons(Cons(2, Cons(4, Cons(6, Nil))), Nil),
)

///|
fn has_row(board : Board, p : Player) -> Bool {
  exists(fn(l) { has_trip(board, p, l) }, rows)
}

///|
fn has_col(board : Board, p : Player) -> Bool {
  exists(fn(l) { has_trip(board, p, l) }, cols)
}

///|
fn has_diag(board : Board, p : Player) -> Bool {
  exists(fn(l) { has_trip(board, p, l) }, diags)
}

///|
fn is_win_for(board : Board, p : Player) -> Bool {
  has_row(board, p) || has_col(board, p) || has_diag(board, p)
}

///|
fn is_cat(board : Board) -> Bool {
  is_full(board) && not(is_win_for(board, X)) && not(is_win_for(board, O))
}

///|
fn list_extreme(f : (Int, Int) -> Int, l : List[Int]) -> Int {
  match l {
    Nil => 0
    Cons(i, iss) => fold(f, iss, i)
  }
}

///|
fn listmax(l : List[Int]) -> Int {
  list_extreme(fn(a, b) { if a > b { a } else { b } }, l)
}

///|
fn listmin(l : List[Int]) -> Int {
  list_extreme(fn(a, b) { if a < b { a } else { b } }, l)
}

///|
fn is_occupied(board : Board, i : Int) -> Bool raise BadIndex {
  is_some(nth(board, i))
}

///|
fn is_win(board : Board) -> Bool {
  is_win_for(board, X) || is_win_for(board, O)
}

///|
fn game_over(board : Board) -> Bool {
  is_win(board) || is_cat(board)
}

///|
fn score(board : Board) -> Int {
  if is_win_for(board, X) {
    1
  } else if is_win_for(board, O) {
    -1
  } else {
    0
  }
}

///|
fn[T] put_at(x : T, xs : List[T], i : Int) -> List[T] raise {
  if i == 0 {
    Cons(x, tail(xs))
  } else if i > 0 {
    Cons(head(xs), put_at(x, tail(xs), i - 1))
  } else {
    raise BadIndex::BadIndex
  }
}

///|
fn move_to(board : Board, p : Player, i : Int) -> Board raise {
  if is_occupied(board, i) {
    Nil
  } else {
    put_at(Some(p), board, i)
  }
}

///|
fn all_moves_rec(n : Int, board : Board, acc : List[Int]) -> List[Int] {
  match board {
    Nil => rev(acc)
    Cons(p, more) =>
      match p {
        Some(_) => all_moves_rec(n + 1, more, acc)
        None => all_moves_rec(n + 1, more, Cons(n, acc))
      }
  }
}

///|
fn all_moves(board : Board) -> List[Int] {
  all_moves_rec(0, board, Nil)
}

///|
fn successors(board : Board, p : Player) -> List[Board] raise {
  map(fn(i) raise { move_to(board, p, i) }, all_moves(board))
}

///|
fn minimax(p : Player, board : Board) -> Rose[(Board, Int)] raise {
  if game_over(board) {
    mk_leaf((board, score(board)))
  } else {
    let trees = map(fn(b) { minimax(other(p), b) }, successors(board, p))
    let scores = map(fn(t) { snd(top(t)) }, trees)
    match p {
      X => Rose((board, listmax(scores)), trees)
      O => Rose((board, listmin(scores)), trees)
    }
  }
}

///|
pub fn main_loop(iters : Int) -> Unit {
  let res = minimax(X, empty_board) catch { _ => abort("minimax failed") }
  if iters == 1 {
    snd(top(res)) |> println
  } else {
    main_loop(iters - 1)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  main_loop(iters.unwrap())
}
