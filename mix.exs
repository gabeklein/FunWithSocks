defmodule FunWithSocks.Mixfile do
  use Mix.Project

  def project do
    [app: :fun_with_socks,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: ["lib", "web"],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [
      applications: [:cowboy, :socks],
      mod: {FunWithSocks, []}
    ]
  end

  defp deps do
    [
      {:cowboy,       "~> 1.0.3",    override: true },
      {:socks, path: "socks"}
    ]
  end
end
