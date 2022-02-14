defmodule Islands.Client.RPC.MixProject do
  use Mix.Project

  def project do
    [
      app: :islands_client_rpc,
      version: "0.1.25",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      name: "Islands Client RPC",
      source_url: source_url(),
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer: [plt_add_apps: [:islands_engine]]
    ]
  end

  defp source_url do
    "https://github.com/RaymondLoranger/islands_client_rpc"
  end

  defp description do
    """
    Remote procedure calls for the Game of Islands.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Raymond Loranger"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      included_applications: [:islands_engine],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:io_ansi_plus, "~> 0.1"},
      {:islands_engine, "~> 0.2"},
      {:islands_player, "~> 0.1"},
      {:islands_tally, "~> 0.1"}
    ]
  end
end
