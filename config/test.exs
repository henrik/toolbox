use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :toolbox, Toolbox.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :toolbox, Toolbox.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("POSTGRES_USER") || "postgres",
  password: System.get_env("POSTGRES_PASSWORD") || "postgres",
  database: "toolbox_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :toolbox,
  :package_syncer, Toolbox.PackageSync.NoOp
