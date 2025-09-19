///|
enum List[A] {
  Nil
  Cons(A, List[A])
}

///|
fn[T] replicate(v : T, n : Int, a : List[T]) -> List[T] {
  if n == 0 {
    a
  } else {
    replicate(v, n - 1, Cons(v, a))
  }
}

///|
fn unless(i : Int, n : Int, b : List[Int]) -> Int {
  if i < n {
    unless(i + 1, n, replicate(0, i, Nil))
  } else {
    i
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = unless(0, n, Nil)
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
