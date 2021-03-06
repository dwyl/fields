defmodule Fields.Hash do
  @moduledoc """
  An Ecto Type for hashed fields.
  Hashed using sha256. See `Fields.Helpers` for hashing details.

  ## Example

        schema "messages" do
          field(:digest, Fields.Hash)
        end
  """
  use Ecto.Type
  alias Fields.Helpers

  def type, do: :binary

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    {:ok, Helpers.hash(:sha256, value)}
  end

  def load(value) do
    {:ok, value}
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
