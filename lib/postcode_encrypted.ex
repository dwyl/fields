defmodule Fields.PostcodeEncrypted do
  @moduledoc """
  An Ecto Type for encrypted postcodes.
  See `Fields.AES` for details on encryption/decryption.

  ## Example

      schema "users" do
        field(:email, Fields.EmailEncrypted)
        field(:postcode, Fields.PostcodeEncrypted)
      end
  """
  alias Fields.{Postcode, Encrypted}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: Postcode.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
