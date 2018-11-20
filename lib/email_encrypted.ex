defmodule Fields.EmailEncrypted do
  @moduledoc """
  An Ecto Type for encrypted emails.

  ## Example

      schema "users" do
        field(:email, Fields.EmailEncrypted)
      end
  """
  alias Fields.{EmailPlaintext, Encrypted, Validate}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: EmailPlaintext.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def load(value, key_id), do: Encrypted.load(value, key_id)
end