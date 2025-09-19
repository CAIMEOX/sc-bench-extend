///|
fn sudan(n : Int, x : Int, y : Int) -> Int {
  if n == 0 {
    x + y
  } else if y == 0 {
    x
  } else {
    let inner = sudan(n, x, y - 1)
    sudan(n - 1, inner, inner + y)
  }
}

///|
fn main_loop(iters : Int, n : Int, x : Int, y : Int) -> Unit {
  let res = sudan(n, x, y)
  if iters == 1 {
    println(res)
  } else {
    main_loop(iters - 1, n, x, y)
  }
}

///|
fn main {
  let argv = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let n = try? @strconv.parse_int(argv[2])
  let x = try? @strconv.parse_int(argv[3])
  let y = try? @strconv.parse_int(argv[4])
  main_loop(iters.unwrap(), n.unwrap(), x.unwrap(), y.unwrap())
}
