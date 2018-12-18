defmodule Fields.Url do
  @moduledoc """
  An Ecto Type for urls.
  Use `Fields.UrlEncrypted` for encrypted urls.

  ## Example

      schema "retailers" do
        field(:url, Fields.Url)
      end
  """
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    case Validate.url(value) do
      true -> {:ok, to_string(value)}
      false -> :error
    end
  end

  def dump(value) do
    {:ok, to_string(value)}
  end

  def load(value) do
    {:ok, value}
  end
end
