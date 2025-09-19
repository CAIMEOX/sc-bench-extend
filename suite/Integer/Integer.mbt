///|
suberror EmptyList

///|
enum Either[A, B] {
  Left(A)
  Right(B)
}

///|
enum List[T] {
  Nil
  Cons(T, List[T])
}

///|
fn[T] head(l : List[T]) -> T raise EmptyList {
  match l {
    Nil => raise EmptyList
    Cons(e, _) => e
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
fn enum_from_then_to(from : Int, th : Int, to_ : Int) -> List[Int] {
  if from <= to_ {
    Cons(from, enum_from_then_to(th, 2 * th - from, to_))
  } else {
    Nil
  }
}

///|
fn apply_op_inner(
  ls : List[Int],
  a : Int,
  op_ : ((Int, Int)) -> Either[Int, Bool],
) -> List[Either[Int, Bool]] {
  match ls {
    Nil => Nil
    Cons(b, t2) => Cons(op_((a, b)), apply_op_inner(t2, a, op_))
  }
}

///|
fn apply_op(
  ls : List[Int],
  astart : Int,
  astep : Int,
  alim : Int,
  op_ : ((Int, Int)) -> Either[Int, Bool],
) -> List[Either[Int, Bool]] {
  match ls {
    Nil => Nil
    Cons(a, t1) =>
      append(
        apply_op_inner(enum_from_then_to(astart, astart + astep, alim), a, op_),
        apply_op(t1, astart, astep, alim, op_),
      )
  }
}

///|
fn integerbench(
  op_ : ((Int, Int)) -> Either[Int, Bool],
  astart : Int,
  astep : Int,
  alim : Int,
) -> List[Either[Int, Bool]] {
  apply_op(
    enum_from_then_to(astart, astart + astep, alim),
    astart,
    astep,
    alim,
    op_,
  )
}

///|
fn runbench(
  jop : ((Int, Int)) -> Either[Int, Bool],
  astart : Int,
  astep : Int,
  alim : Int,
) -> List[Either[Int, Bool]] {
  let _ = integerbench(jop, astart, astep, alim)
  integerbench(jop, astart, astep, alim)
}

///|
fn runalltests(
  astart : Int,
  astep : Int,
  alim : Int,
) -> List[Either[Int, Bool]] {
  let z_add = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Left(a + b)
  }
  let z_sub = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Left(a - b)
  }
  let z_mul = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Left(a * b)
  }
  let z_div = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Left(a / b)
  }
  let z_mod = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Left(a % b)
  }
  let z_equal = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Right(a == b)
  }
  let z_lt = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Right(a < b)
  }
  let z_leq = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Right(a <= b)
  }
  let z_gt = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Right(a > b)
  }
  let z_geq = fn(pair : (Int, Int)) {
    let (a, b) = pair
    Right(a >= b)
  }
  let _ = runbench(z_add, astart, astep, alim)
  let _ = runbench(z_sub, astart, astep, alim)
  let _ = runbench(z_mul, astart, astep, alim)
  let _ = runbench(z_div, astart, astep, alim)
  let _ = runbench(z_mod, astart, astep, alim)
  let _ = runbench(z_equal, astart, astep, alim)
  let _ = runbench(z_lt, astart, astep, alim)
  let _ = runbench(z_leq, astart, astep, alim)
  let _ = runbench(z_gt, astart, astep, alim)
  runbench(z_geq, astart, astep, alim)
}

///|
fn test_integer_nofib(n : Int) -> List[Either[Int, Bool]] {
  runalltests(-2100000000, n, 2100000000)
}

///|
fn print_either(e : Either[Int, Bool]) -> Unit {
  match e {
    Left(i) => println(i)
    Right(b) => if b { println("11") } else { println("00") }
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = test_integer_nofib(n)
  if iters == 1 {
    print_either(head(res)) catch {
      EmptyList => println("Error: Empty list")
    }
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
