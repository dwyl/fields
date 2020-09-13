defmodule Fields.Password do
  @moduledoc """
  An Ecto Type for hashed passwords.
  Hashed using Argon2. See `Fields.Helpers` for hashing details.

  ## Example

      schema "users" do
        field(:email, Fields.EmailEncrypted)
        field(:password, Fields.Password)
      end
  """
  use Ecto.Type
  alias Fields.Helpers

  def type, do: :binary

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    {:ok, Helpers.hash(:argon2, value)}
  end

  def load(value) do
    {:ok, value}
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
