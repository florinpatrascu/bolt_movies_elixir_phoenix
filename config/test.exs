use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :movies_elixir_phoenix, MoviesElixirPhoenixWeb.Endpoint,
  http: [port: 4001],
  server: false

config :bolt_sips, Bolt,
  # default port considered to be: 7687
  url: 'localhost',
  pool_size: 5,
  max_overflow: 1,
  retry_linear_backoff: [delay: 150, factor: 2, tries: 3]

# Print only warnings and errors during test
config :logger, level: :warn
