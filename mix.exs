defmodule Toolbox.Mixfile do
  use Mix.Project

  def project do
    [app: :toolbox,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Toolbox, []},
      applications: app_list(Mix.env),
    ]
  end

  defp app_list do
    [
      :phoenix, :phoenix_html, :cowboy, :logger,
      :phoenix_ecto, :postgrex,

      # For HexClient.
      :httpotion,
    ]
  end
  defp app_list(:test) do
    [
      :ex_machina,
    ] ++ app_list
  end
  defp app_list(_),  do: app_list

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.0.3"},
      {:phoenix_ecto, "~> 1.1"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.1"},
      {:cowboy, "~> 1.0"},
      {:poison, "> 0.0.0"},

      # For HexClient.
      {:ibrowse, github: "cmullaparthi/ibrowse", tag: "v4.1.2"},
      {:httpotion, "> 0.0.0"},

      {:phoenix_live_reload, "~> 1.0", only: :dev},

      {:ex_machina, "~> 0.4", only: :test},
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
    ]
  end
end
