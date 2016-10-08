defmodule AI.Nucleus.RetinaTest do
  use ExUnit.Case

  @alias AI.Nucleus.Retina

  test "binding (left -> right)" do
    a = [
      [[1], [2], [3]],
      [[1], [2], [3, 6]]
    ]
    b = [
      [[3], [2], [1]],
      [[3], [2], [1]]
    ]

    assert AI.Nucleus.Retina.bind(a, b) == [
      [[1], [2], [3, 3], [2], [1]],
      [[1], [2], [3, 6, 3], [2], [1]]
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

    assert AI.Nucleus.Retina.stack(a, b) == [
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

    assert AI.Nucleus.Retina.stack(a, b) == b
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
    assert AI.Nucleus.Retina.stack(a, b) == [
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[1], [2], [3]],
      [[1,3], [2,2], [3,1]],
      [[3], [2], [1]],
      [[3, 3], [2, 2], [1, 1]],
      [[3], [2], [1]]
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
    assert AI.Nucleus.Retina.bind(a, b) == [
      [[1], [2], [3, 3], [2], [1, 3], [2], [1] ],
      [[1], [2], [3, 6, 3], [2], [1, 3], [2], [1] ]
    ]
  end
end
