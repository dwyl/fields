defmodule Fields do
  @moduledoc """
  Documentation for Fields.
  """

  @doc """
  Fields provides a function that can be used in a Phoenix Controller
  to generate a form using an Ecto Schema.

  Usage:

  At the top of your controller, call:

      use Fields

  then, when you want to render your form, call render_fields/4
  """
  defmacro __using__(_opts) do
    quote location: :keep do

      @doc """
        Renders a 'new' or 'update' form based on the schema passed to it.

        Example:

            render_fields(conn, :update, User, user: get_user_from_db())
      """
      @spec render_fields(Plug.Conn.t, atom, Ecto.Schema.t,  Keyword.t | map) :: Plug.Conn.t
      def render_fields(conn, action, schema, assigns) when action in [:update, :create] do
        fields = schema.__schema__(:fields) |> Enum.reject(&(&1 in [:id, :inserted_at, :updated_at]))

        {_key, schema_data} =
          case action do
            :create -> {nil, []}
            :update -> Enum.find(assigns, fn {_k, v} -> match?(v, schema) end)
          end

        action_path = path(conn, action, schema_data)

        conn
        |> put_view(Fields.FieldsView)
        |> Phoenix.Controller.render(
          "fields.html",
          assigns
          |> Enum.into(%{})
          |> Map.put(:path, action_path)
          |> Map.put(:fields, fields)
        )
      end

      defp path(conn, action, opts) do
        regex = ~r/(?<web_name>.+)\.(?<schema_name>.+)Controller/
        %{"web_name" => web_name, "schema_name" => schema_name } = Regex.named_captures(regex, to_string(__MODULE__))

        apply(
          String.to_existing_atom(web_name <> ".Router.Helpers"),
          String.to_existing_atom(String.downcase(schema_name) <> "_path"),
          [conn, action, opts]
        )
      end
    end
  end
end
