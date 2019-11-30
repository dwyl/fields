defmodule Fields.MixProject do
  use Mix.Project

  def project do
    [
      app: :fields,
      description: "a collection of useful fields for building Phoenix apps faster!",
      version: "2.0.1",
      elixir: "~> 1.9",
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
      {:argon2_elixir, "~> 1.2"},    # password hashing
      {:ecto, "~> 3.0"},             # ecto types
      {:html_sanitize_ex, "~> 1.3"}, # strip noise from html field

      # stream_data for property based testing
      {:stream_data, "~> 0.4.3", only: :test},
      # tracking test coverage
      {:excoveralls, "~> 0.12.1", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.21.2", only: :dev},
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
