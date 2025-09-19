///|
fn ack(m : Int, n : Int) -> Int {
  if m == 0 {
    n + 1
  } else if n == 0 {
    ack(m - 1, 1)
  } else {
    ack(m - 1, ack(m, n - 1))
  }
}

///|
fn main_loop(iters : Int, m : Int, n : Int) -> Unit {
  let res = ack(m, n)
  if iters == 1 {
    println(res)
  } else {
    main_loop(iters - 1, m, n)
  }
}

///|
fn main {
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let m = try? @strconv.parse_int(argv[2])
  let n = try? @strconv.parse_int(argv[3])
  main_loop(iters.unwrap(), m.unwrap(), n.unwrap())
}
