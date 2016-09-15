defmodule Beanie.RegistryAPI.Registry do
  defstruct(location: nil, user: nil, password: nil, http_client: HTTPotion)

  require Logger

  alias Beanie.RegistryAPI.Registry

  def at_url(location, user \\ nil, password \\ nil) do
    %Registry{
      location: location,
      user: user,
      password: password
    }
  end

  def url(registry = %Registry{}, pathparts) do
    [
      registry.location,
      "v2",
      pathparts
    ]
    |> List.flatten
    |> Enum.join("/")
  end

  def get(registry = %Registry{}, path) do
    url = url(registry, path)
    Logger.debug("Fetching registry url #{url}")

    response = registry.http_client.get!(
      url(registry, path),
      [basic_auth: {registry.user, registry.password}]
    )
    Logger.debug("Got '#{response.body}' from #{url}")
    Poison.decode!(response.body)
  end
end
