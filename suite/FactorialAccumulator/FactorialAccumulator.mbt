///|
fn factorial(a : Int, i : Int) -> Int {
  if i == 0 {
    a
  } else {
    factorial(a * i % 1000000007, i - 1)
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = factorial(1, n)
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
