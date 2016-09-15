defmodule Beanie.Repository.Query do
  import Ecto.Query
  alias Beanie.Repo

  alias Beanie.Repository
  alias Beanie.Tag

  def update_list(names) do
    names = MapSet.new(names)
    existing_names = MapSet.new(all_names)
    new_names = MapSet.difference(names, existing_names)
    deleted_names = MapSet.difference(existing_names, names) |> MapSet.to_list

    new_names
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

  def update_tag_list(repository, tags) do
    tag_names = Enum.map(tags, fn(tag) -> tag.name end) |> MapSet.new
    existing_names = MapSet.new(all_tag_names(repository))
    new_names = MapSet.difference(tag_names, existing_names)
    deleted_names = MapSet.difference(existing_names, tag_names) |> MapSet.to_list

    new_names
    |> Enum.map(fn(new_name) ->
      tag = Enum.find(tags, fn(t) -> t.name == new_name end)
      Tag.changeset(%{tag | creation_timestamp: Ecto.DateTime.cast!(tag.creation_timestamp)})
      |> Repo.insert
    end)

    unless Enum.empty?(deleted_names) do
      from(
        t in Tag,
        where: t.name in ^deleted_names
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

  def all_tag_names(repository) do
    Repo.all(
      from t in Tag,
      where: t.repository_id == ^repository.id,
      select: t.name
    )
  end
end

