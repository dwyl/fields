defmodule Fields.IpAddressEncrypted do
  @moduledoc """
  An Ecto Type for encrypted ip addresses.

  ## Example

      schema "users" do
        field(:ip_address, Fields.IpAddressEncrypted)
      end
  """
  alias Fields.{IpAddressPlaintext, Encrypted}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: IpAddressPlaintext.cast(value)

  def dump(value), do: Encrypted.dump(value)

  def load(value), do: Encrypted.load(value)

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
