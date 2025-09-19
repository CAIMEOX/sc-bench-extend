///|
fn tfib(n : Int, a : Int, b : Int) -> Int {
  if n == 0 {
    a
  } else {
    tfib(n - 1, a + b, a)
  }
}

///|
fn fib(n : Int) -> Int {
  tfib(n, 0, 1)
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = fib(n)
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
