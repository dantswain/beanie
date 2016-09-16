defmodule Beanie.Helpers do
  @doc """
  Computes the relative complements of two lists - the elements that
  are in the first list and not in the second set, and vice versa,
  returned as the first and second elements of a tuple, respectively.
  """
  @spec relative_complements([term], [term]) :: {[term], [term]}
  def relative_complements(list1, list2)
  when is_list(list1) and is_list(list2) do
    set1 = MapSet.new(list1)
    set2 = MapSet.new(list2)

    {
      set1 |> MapSet.difference(set2) |> MapSet.to_list,
      set2 |> MapSet.difference(set1) |> MapSet.to_list
    }
  end
end
