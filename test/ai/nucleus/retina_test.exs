defmodule AI.Nucleus.RetinaTest do
  use ExUnit.Case, async: true

  @alias AI.Nucleus.Retina

  test "binding (left -> right)" do
    a = [
      [[1], [2], [3]],
      [[1], [2], [3, 6]]
    ]
    b = [
      [["a"], ["b"], ["c"]],
      [["a"], ["b"], ["c"]]
    ]

    assert AI.Nucleus.Retina.bind(a, b, 1) == [
      [[1], [2], [3, "a"], ["b"], ["c"]],
      [[1], [2], [3, 6, "a"], ["b"], ["c"]]
    ]
  end

  test "binding (left -> right) overlap 2" do
    a = [
      [[1], [2], [3]],
      [[1], [2], [3, 6]]
    ]
    b = [
      [["a"], ["b"], ["c"]],
      [["a"], ["b"], ["c"]]
    ]

    assert AI.Nucleus.Retina.bind(a, b, 2) == [
      [[1], [2, "a"], [3, "b"], ["c"]],
      [[1], [2, "a"], [3, 6, "b"], ["c"]]
    ]
  end

  test "stacking (top -> bottom)" do
    a = [
      [[1], [2], [3]],
      [[1], [2], [3]]
    ]
    b = [
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]

    assert AI.Nucleus.Retina.stack(a, b, 1) == [
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[3], [2], [1]]
    ]
  end

  test "stacking no top ([] -> bottom)" do
    a = []
    b = [
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]

    assert AI.Nucleus.Retina.stack(a, b, 1) == b
  end

  test "complex stacking no top ([] -> bottom)" do
    a = [
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]
    b = [
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]
    assert AI.Nucleus.Retina.stack(a, b, 1) == [
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[3], [2], [1]],
      [[3, 3], [2, 2], [1, 1]],
      [[3], [2], [1]]
    ]
  end

  test "complex stacking no top overlap 2" do
    a = [
      [[30], [20], [10]],
      [[300], [200], [100]]
    ]
    b = [
      [[3], [2], [1]],
      [[13], [12], [11]]
    ]
    assert AI.Nucleus.Retina.stack(a, b, 2) == [
      [[30, 3], [20, 2], [10, 1]],
      [[300, 13], [200, 12], [100, 11]]
    ]
  end

  test "complex binding (left -> right)" do
    a = [
      [[1], [2], [3, 3], [2], [1]],
      [[1], [2], [3, 6, 3], [2], [1]]
    ]
    b = [
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]
    assert AI.Nucleus.Retina.bind(a, b, 1) == [
      [[1], [2], [3, 3], [2], [1, 3], [2], [1] ],
      [[1], [2], [3, 6, 3], [2], [1, 3], [2], [1] ]
    ]
  end
end
