defmodule CldrRoutes.MixProject do
  use Mix.Project

  @version "0.3.0-dev"

  def project do
    [
      app: :ex_cldr_routes,
      version: @version,
      elixir: "~> 1.10",
      description: "CLDR-based localized route generation and path helpers for Phoenix",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      deps: deps(),
      compilers: [:gettext] ++ Mix.compilers(),

      # Docs
      name: "Cldr Routes",
      source_url: "https://github.com/elixir-cldr/cldr_routes",
      homepage_url: "https://hex.pm/packages/ex_cldr_routes",
      docs: [
        source_ref: "v#{@version}",
        main: "readme",
        logo: "logo.png",
        extras: [
          "README.md",
          "LICENSE.md",
          "CHANGELOG.md"
        ]
      ],
      dialyzer: [
        ignore_warnings: ".dialyzer_ignore_warnings",
        plt_add_apps: ~w(jason mix)a
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:ex_cldr, "~> 2.27"},
      {:phoenix, "~> 1.6"},
      {:phoenix_live_view, "~> 0.17", optional: true},
      {:jason, "~> 1.0"},
      {:gettext, "~> 0.19"},
      {:ex_doc, "~> 0.18", only: [:release, :dev]},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false, optional: true}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      maintainers: ["Kip Cole"],
      links: links(),
      files: [
        "lib",
        "mix.exs",
        "README.md",
        "LICENSE.md",
        "CHANGELOG.md"
      ]
    ]
  end

  def aliases do
    []
  end

  def links do
    %{
      "GitHub" => "https://github.com/elixir-cldr/cldr_routes",
      "Readme" => "https://github.com/elixir-cldr/cldr_routes/blob/v#{@version}/README.md",
      "Changelog" => "https://github.com/elixir-cldr/cldr_routes/blob/v#{@version}/CHANGELOG.md"
    }
  end

  defp elixirc_paths(:test), do: ["lib", "src", "mix", "test", "test/support"]
  defp elixirc_paths(:dev), do: ["lib", "mix", "bench"]
  defp elixirc_paths(:release), do: ["lib"]
  defp elixirc_paths(_), do: ["lib"]
end
