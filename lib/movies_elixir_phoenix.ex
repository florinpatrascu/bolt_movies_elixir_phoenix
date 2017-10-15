defmodule MoviesElixirPhoenix do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the endpoint when the application starts
      worker(Bolt.Sips, [Application.get_env(:bolt_sips, Bolt)]),
      supervisor(MoviesElixirPhoenix.Endpoint, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MoviesElixirPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MoviesElixirPhoenix.Endpoint.config_change(changed, removed)
    :ok
  end

end
