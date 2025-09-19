///|
fn[A] iterate(i : Int, f : (A) -> A, a : A) -> A {
  if i == 0 {
    a
  } else {
    iterate(i - 1, f, f(a))
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = iterate(n, n => n + 1, 0)
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
