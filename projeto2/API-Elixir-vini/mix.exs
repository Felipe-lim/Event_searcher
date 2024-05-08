defmodule Api.MixProject do
  use Mix.Project

  def project do
    [
      app: :api,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      { :httpoison, "~> 2.2" },
      { :poison,    "~> 5.0" },
      { :hackney,   "~> 1.20.1" }
    ]
  end

  defp escript do
    [
      main_module: Api
    ]
  end
end
