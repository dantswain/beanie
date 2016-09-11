defmodule Beanie.Repository.Query do
  import Ecto.Query
  alias Beanie.Repo

  alias Beanie.Repository

  def update_list(names) do
    names = MapSet.new(names)
    existing_names = MapSet.new(all_names)
    new_names = MapSet.difference(names, existing_names)
    deleted_names = MapSet.difference(existing_names, names) |> MapSet.to_list

    changesets = new_names
    |> Enum.each(fn(name) ->
      Repository.changeset(%Repository{}, %{"name" => name})
      |> Repo.insert
    end)

    unless Enum.empty?(deleted_names) do
      from(
        r in Repository,
        where: r.name in ^deleted_names
      )
      |> Repo.delete_all
    end
  end

  def all_names do
    Repo.all(
      from r in Repository,
      select: r.name
    )
  end
end

