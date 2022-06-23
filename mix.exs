defmodule Fields.MixProject do
  use Mix.Project

  def project do
    [
      app: :fields,
      description: "A collection of useful fields for building Phoenix apps faster!",
      version: "2.8.2",
      elixir: ">= 1.10.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),

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
      extra_applications: [:logger],
      env: [
        encryption_keys: System.get_env("ENCRYPTION_KEYS"),
        secret_key_base: System.get_env("SECRET_KEY_BASE")
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # password hashing
      {:argon2_elixir, "~> 2.4.0"},
      # ecto types
      {:ecto, "~> 3.8"},
      # strip noise from html field
      {:html_sanitize_ex, "~> 1.4.2"},

      # stream_data for property based testing
      {:stream_data, "~> 0.5.0", only: :test},
      # tracking test coverage
      {:excoveralls, "~> 0.14.2", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.28.3", only: :dev},
      {:inch_ex, ">=2.0.0", only: :docs}
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
