defmodule Fields.Address do
  @moduledoc """
  An Ecto Type for plaintext addresses.
  Useful for publicly available addressses.
  See `Fields.AddressEncrypted` for storing addresses
  that are Personally Identifiable Information.

  ## Example
    ```
    schema "retailers" do
      field :address, Fields.Address
    end
    ```
  """
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    value = value |> to_string() |> String.trim()

    case Validate.address(value) do
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
