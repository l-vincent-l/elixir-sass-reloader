defmodule PhoenixLiveCssReload.MixProject do
  use Mix.Project

  def project do
    [
      app: :elixir_sass_reloader,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ElixirSassReloader.Application, []}
    ]
  end

  defp deps do
    [
      {:file_system, "~> 0.2.1 or ~> 0.3"},
      {:exexec, "~> 0.2.0"},
    ]
  end
end
