///|
fn abs_int(i : Int) -> Int {
  if i < 0 {
    -i
  } else {
    i
  }
}

///|
fn oad_abs(n : Int) -> Bool {
  if n == 0 {
    false
  } else {
    even_abs(n - 1)
  }
}

///|
fn even_abs(n : Int) -> Bool {
  if n == 0 {
    true
  } else {
    oad_abs(n - 1)
  }
}

///|
fn even(n : Int) -> Bool {
  even_abs(abs_int(n))
}

///|
fn odd(n : Int) -> Bool {
  oad_abs(abs_int(n))
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = even(n) && !odd(n)
  if iters == 1 {
    if res {
      println(1)
    } else {
      println(0)
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
