///|
fn attempt(i : Int) -> Int? {
  if i == 0 {
    Some(i)
  } else {
    match attempt(i - 1) {
      Some(j) => Some(j + 1)
      None => None
    }
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = match attempt(n) {
    Some(i) => i
    None => -1
  }
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
