///|
fn cps_tak(x : Int, y : Int, z : Int, k : (Int) -> Int) -> Int {
  if x <= y {
    k(z)
  } else {
    cps_tak(x - 1, y, z, v1 => cps_tak(y - 1, z, x, v2 => cps_tak(z - 1, x, y, v3 => k(
      v1 + v2 + v3,
    ))))
  }
}

///|
fn tak(x : Int, y : Int, z : Int) -> Int {
  cps_tak(x, y, z, v => v)
}

///|
fn main_loop(iters : Int, x : Int, y : Int, z : Int) -> Unit {
  let res = tak(x, y, z)
  if iters == 1 {
    println(res)
  } else {
    main_loop(iters - 1, x, y, z)
  }
}

///|
fn main {
  // CLI access may error; it's acceptable per instruction
  let argv : Array[String] = @sys.get_cli_args()
  let iters = try? @strconv.parse_int(argv[1])
  let x = try? @strconv.parse_int(argv[2])
  let y = try? @strconv.parse_int(argv[3])
  let z = try? @strconv.parse_int(argv[4])
  main_loop(iters.unwrap(), x.unwrap(), y.unwrap(), z.unwrap())
}
