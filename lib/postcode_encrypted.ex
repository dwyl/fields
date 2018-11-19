defmodule Fields.PostcodeEncrypted do
  alias Fields.{Postcode, Encrypted, Validate}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: Postcode.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def load(value, key_id), do: Encrypted.load(value, key_id)
end
