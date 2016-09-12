defmodule Beanie.RegistryAPI do
  alias Beanie.RegistryAPI.Registry

  def catalog(registry = %Registry{}) do
    Registry.get(registry, "_catalog")
  end

  def tag_list(registry, repository) do
    Registry.get(registry, [repository, "tags", "list"])
  end

  def manifest(registry, repository, tag) do
    Registry.get(registry, [repository, "manifests", tag])
  end

  def created_at_from_manifest(manifest) do
    manifest["history"]
    |> Enum.map(fn(h) ->
      h["v1Compatibility"]
      |> Poison.decode!
      |> Map.get("created")
      |> NaiveDateTime.from_iso8601!
      |> NaiveDateTime.to_erl
    end
    )
    |> Enum.sort
    |> List.last
    |> NaiveDateTime.from_erl!
  end
end
