defmodule Fields.UrlEncrypted do
  @moduledoc """
  An Ecto Type for urls that need to be stored securely.

  ## Example

      schema "short_links" do
        field :url, Fields.UrlEncrypted
      end
  """
  alias Fields.{Validate, Encrypted}

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    value = value |> to_string() |> String.trim()
    case Validate.url(value) do
      true -> {:ok, value}
      false -> :error
    end
  end

  def dump(value) do
    Encrypted.dump(value)
  end

  def load(value) do
    Encrypted.load(value)
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
