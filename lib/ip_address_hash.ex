defmodule Fields.IpAddressHash do
  @moduledoc """
  An Ecto Type for hashed ip addresses.
  Hashed using sha256. See `Fields.Helpers` for hashing details.

  ## Example

      schema "users" do
        field(:ip_address_hash, Fields.IpAddressHash)
      end
  """
  alias Fields.{IpAddressPlaintext, Hash}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: IpAddressPlaintext.cast(value)

  def dump(value), do: Hash.dump(value)

  def load(value) do
    {:ok, value}
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
