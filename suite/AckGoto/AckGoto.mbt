///|
suberror Return Int

///|
fn ack(m : Int, n : Int) -> Int raise Return {
  if m == 0 {
    raise Return(n + 1)
  } else if n == 0 {
    ack(m - 1, 1)
  } else {
    ack(m - 1, ack(m, n - 1) catch { Return(v) => v })
  }
}

///|
fn main_loop(iters : Int, m : Int, n : Int) -> Unit {
  let res = ack(m, n) catch { Return(v) => v };
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
