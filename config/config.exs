# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :beanie,
  ecto_repos: [Beanie.Repo],
  docker_registry: [:at_url, ["https://localhost:5000", "testuser", "testpasswd"]]

# Configures the endpoint
config :beanie, Beanie.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5Vxq6un10VcyUXfofaxsVuyqsBVusJPDTg4hfU3I3vJS3Qcyfh9QAYGns9OAc0+A",
  render_errors: [view: Beanie.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Beanie.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
