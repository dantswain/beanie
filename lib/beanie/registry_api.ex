defmodule Beanie.RegistryAPI do
  alias Beanie.RegistryAPI.Registry

  def catalog(registry = %Registry{}) do
    Registry.get(registry, "_catalog")
  end

  def tag_list(registry, repository) do
    Registry.get(registry, [repository, "tags", "list"])
  end
end
