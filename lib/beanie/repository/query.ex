defmodule Beanie.Repository.Query do
  import Ecto.Query
  alias Beanie.Repo

  alias Beanie.Repository
  alias Beanie.Helpers
  alias Beanie.Tag

  def update_list(names) do
    {new_names, deleted_names} = Helpers.relative_complements(names, all_names)

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

    {new_names, deleted_names} =
      Helpers.relative_complements(tag_names, all_tag_names(repository))

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

