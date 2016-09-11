defmodule Beanie.RegistryAPI do
  alias Beanie.RegistryAPI.Registry

  def catalog(registry = %Registry{}) do
    Registry.get(registry, "_catalog")
  end
end
