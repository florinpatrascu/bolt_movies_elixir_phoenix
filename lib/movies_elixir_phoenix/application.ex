defmodule MoviesElixirPhoenix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      worker(Bolt.Sips, [Application.get_env(:bolt_sips, Bolt)]),
      MoviesElixirPhoenixWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: MoviesElixirPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MoviesElixirPhoenixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
