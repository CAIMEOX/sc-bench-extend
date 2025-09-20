///|
suberror Return Int

///|
fn sum_loop(
  i : Int,
  tot : Int,
  stop : Int,
  f : (Int) -> Int,
) -> Int raise Return {
  if stop < i {
    raise Return(tot)
  } else {
    sum_loop(i + 1, f(i) + tot, stop, f)
  }
}

///|
fn sum(f : (Int) -> Int, start : Int, stop : Int) -> Int raise Return {
  sum_loop(start, 0, stop, f)
}

///|
fn motz(n : Int) -> Int raise Return {
  if n <= 1 {
    raise Return(1)
  } else {
    let limit = n - 2
    let product = fn(i : Int) -> Int {
      (motz(i) catch { Return(i) => i }) *
      (motz(limit - i) catch { Return(i) => i })
    }
    raise Return(
      (motz(n - 1) catch { Return(i) => i }) +
      (sum(product, 0, limit) catch { Return(i) => i }),
    )
  }
}

///|
pub fn main_loop(iters : Int, n : Int) -> Unit {
  let res = motz(n) catch { Return(i) => i }
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
