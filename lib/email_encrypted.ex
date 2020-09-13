defmodule Fields.EmailEncrypted do
  @moduledoc """
  An Ecto Type for encrypted emails.

  ## Example

      schema "users" do
        field(:email, Fields.EmailEncrypted)
      end
  """
  alias Fields.{EmailPlaintext, Encrypted}
  use Ecto.Type

  def type, do: :binary

  def cast(value), do: EmailPlaintext.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
