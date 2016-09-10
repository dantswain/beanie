defmodule Beanie.RegistryAPI do
  defmodule Registry do
    defstruct(location: nil, user: nil, password: nil, http_client: HTTPotion)

    def at_url(location, user \\ nil, password \\ nil) do
      %Registry{
        location: location,
        user: user,
        password: password
      }
    end

    def url(registry = %Registry{}, path) do
      [
        registry.location,
        "v2",
        path
      ]
      |> Enum.join("/")
    end

    def get(registry = %Registry{}, path) do
      response = registry.http_client.get!(
        url(registry, path),
        [basic_auth: {registry.user, registry.password}]
      )
      Poison.decode!(response.body)
    end
  end

  def catalog(registry = %Registry{}) do
    Registry.get(registry, "_catalog")
  end
end
