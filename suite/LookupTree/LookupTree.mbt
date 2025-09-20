///|
enum Tree[A] {
  Leaf(A)
  Node(Tree[A], Tree[A])
}

///|
fn create(i : Int, n : Int) -> Tree[Int] {
  if i < n {
    let t = create(i + 1, n)
    Node(t, t)
  } else {
    Leaf(n)
  }
}

///|
fn[A] lookup(t : Tree[A]) -> A {
  match t {
    Leaf(a) => a
    Node(l, _r) => lookup(l)
  }
}

///|
fn main_loop(iters : Int, n : Int) -> Unit {
  let res = lookup(create(0, n))
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
