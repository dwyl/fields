defmodule Fields.MixProject do
  use Mix.Project

  def project do
    [
      app: :fields,
      description: "A collection of useful fields for building Phoenix apps faster!",
      version: "2.7.1",
      elixir: "~> 1.10.4",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),

      # coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test
      ]
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
      # password hashing
      {:argon2_elixir, "~> 2.3.0"},
      # ecto types
      {:ecto, "~> 3.4.6"},
      # strip noise from html field
      {:html_sanitize_ex, "~> 1.4.1"},

      # stream_data for property based testing
      {:stream_data, "~> 0.5.0", only: :test},
      # tracking test coverage
      {:excoveralls, "~> 0.13.1", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.22.5", only: :dev},
      {:inch_ex, only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["dwyl"],
      licenses: ["GNU GPL v2.0"],
      links: %{github: "https://github.com/dwyl/fields"},
      files: ~w(lib LICENSE mix.exs README.md .formatter.exs)
    ]
  end
end
