defmodule Fields.IpAddressPlaintext do
  @moduledoc """
  An Ecto Type for plaintext ip address.

  ## Example

        schema "people" do
          field(:ip_address, Fields.IpAddressPlaintext)
        end
  """
  alias Fields.Validate
  use Ecto.Type

  def type, do: :string

  def cast(value) do
    value = value |> to_string() |> String.trim()

    case Validate.ip_address(value) do
      true -> {:ok, value}
      false -> :error
    end
  end

  def dump(value) do
    {:ok, to_string(value)}
  end

  def load(value) do
    {:ok, value}
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
