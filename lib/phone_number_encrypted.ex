defmodule Fields.PhoneNumberEncrypted do
  @moduledoc """
  An Ecto Type for encrypted phone numbers.

  ## Example

      schema "users" do
        field(:phone_number, Fields.PhoneNumberEncrypted)
      end
  """
  alias Fields.{PhoneNumber, Encrypted}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: PhoneNumber.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
