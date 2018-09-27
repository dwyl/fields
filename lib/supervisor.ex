defmodule Fields.Supervisor do
  @moduledoc false
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # Run Fields Test App endpoint, when running tests
    children =
      case Code.ensure_compiled(TestFields) do
        {:error, _} ->
          []

        {:module, TestFields} ->
          [supervisor(TestFieldsWeb.Endpoint, [])]
      end

    opts = [strategy: :one_for_one, name: Fields.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
