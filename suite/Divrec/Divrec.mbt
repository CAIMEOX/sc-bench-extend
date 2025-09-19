///|
suberror OddNumber

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn create(n : Int) -> List[Int] {
  if n <= 0 {
    Nil
  } else {
    Cons(n, create(n - 1))
  }
}

///|
fn length(lst : List[Int]) -> Int {
  match lst {
    Nil => 0
    Cons(_, tail) => 1 + length(tail)
  }
}

///|
fn rec_div2(l : List[Int]) -> List[Int] raise OddNumber {
  match l {
    Nil => Nil
    Cons(x, Cons(y, ys)) => Cons(x, rec_div2(ys))
    _ => raise OddNumber
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = length(rec_div2(create(n))) catch { _ => 0 }
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
