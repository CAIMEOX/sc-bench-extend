///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn range(i : Int, n : Int) -> List[Int] {
  if i >= n {
    Nil
  } else {
    Cons(i, range(i + 1, n))
  }
}

///|
fn sum(xs : List[Int]) -> Int {
  match xs {
    Nil => 0
    Cons(y, ys) => y + sum(ys)
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = sum(range(0, n))
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
