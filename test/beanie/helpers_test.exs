defmodule Beanie.HelpersTest do
  use ExUnit.Case

  alias Beanie.Helpers
  
  test "relative complements" do
    list1 = [1, 2, 3]
    list2 = [2, 4, 5]

    in1_not2 = [1, 3]
    in2_not1 = [4, 5]

    assert {in1_not2, in2_not1} == Helpers.relative_complements(list1, list2)
  end
end
