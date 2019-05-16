defmodule Fields.Postcode do
  @moduledoc """
  An Ecto Type for plaintext postcodes.
  Use for publicly available postcodes. For personal data, use `Fields.PostcodeEncrypted` instead.

  ## Example

      schema "retailers" do
        field(:postcode, Fields.Postcode)
      end
  """
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    value = value |> to_string() |> String.trim()
    case Validate.postcode(value) do
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
end
