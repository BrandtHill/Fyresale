defmodule Fyresale.MixProject do
  use Mix.Project

  def project do
    [
      app: :fyresale,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Fyresale, []},
      registered: [Products]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.5.1"},
      {:floki, "~> 0.21.0"},
      {:bamboo_smtp, "~> 1.7.0"}
    ]
  end
end
