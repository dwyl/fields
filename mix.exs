defmodule Fields.MixProject do
  use Mix.Project

  def project do
    [
      app: :fields,
      description: "A collection of useful fields for building Phoenix apps faster!",
      version: "2.11.0",
      elixir: ">= 1.10.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      # coverage
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        c: :test,
        coveralls: :test,
        "coveralls.json": :test,
        "coveralls.html": :test,
        t: :test
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
      {:argon2_elixir, "~> 4.0.0"},
      # ecto types
      # require older version of ecto for Phoenix compatibility ...
      #
      {:ecto, "~> 3.3"},
      # Check/get Environment Variables: https://github.com/dwyl/envar
      {:envar, "~> 1.1.0"},
      # strip noise from html field
      {:html_sanitize_ex, "~> 1.4.2"},

      # stream_data for property based testing
      {:stream_data, "~> 1.0.0", only: :test},
      # tracking test coverage
      {:excoveralls, "~> 0.18.0", only: [:test, :dev]},

      # documentation
      {:ex_doc, "~> 0.34.0", only: :dev},
      {:inch_ex, ">=2.0.0", only: :docs}
    ]
  end

  defp package do
    [
      maintainers: ["dwyl"],
      licenses: ["GPL-2.0-or-later"],
      links: %{github: "https://github.com/dwyl/fields"},
      files: ~w(lib LICENSE mix.exs README.md .formatter.exs)
    ]
  end

  # See the documentation for `Mix` for more info on aliases:
  # https://hexdocs.pm/mix/1.12.3/Mix.html#module-aliases
  defp aliases do
    [
      c: ["coveralls.html"],
      t: ["test"]
    ]
  end
end
