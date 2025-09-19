///|
suberror EmptyList

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] null(l : List[T]) -> Bool {
  match l {
    Nil => true
    Cons(_, _) => false
  }
}

///|
fn[T] tail(l : List[T]) -> List[T] raise EmptyList {
  match l {
    Nil => raise EmptyList
    Cons(_, as_) => as_
  }
}

///|
fn[T] length(l : List[T]) -> Int {
  match l {
    Nil => 0
    Cons(_, as_) => 1 + length(as_)
  }
}

///|
fn list_n(n : Int) -> List[Int] {
  if n == 0 {
    Nil
  } else {
    Cons(n, list_n(n - 1))
  }
}

///|
fn shorterp(x : List[Int], y : List[Int]) -> Bool raise EmptyList {
  if null(y) {
    false
  } else if null(x) {
    true
  } else {
    shorterp(tail(x), tail(y))
  }
}

///|
fn mas(
  x : List[Int],
  y : List[Int],
  z : List[Int],
) -> List[Int] raise EmptyList {
  if not(shorterp(y, x)) {
    z
  } else {
    mas(mas(tail(x), y, z), mas(tail(y), z, x), mas(tail(z), x, y))
  }
}

///|
fn main_loop(iters : Int, x : Int, y : Int, z : Int) -> Unit {
  let res = length(mas(list_n(x), list_n(y), list_n(z))) catch {
    _ => abort("")
  }
  if iters == 1 {
    println(res)
  } else {
    main_loop(iters - 1, x, y, z)
  }
}

///|
fn main {
  // CLI access may error; it's acceptable per instruction
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let x = try? @strconv.parse_int(argv[2])
  let y = try? @strconv.parse_int(argv[3])
  let z = try? @strconv.parse_int(argv[4])
  main_loop(iters.unwrap(), x.unwrap(), y.unwrap(), z.unwrap())
}
