defmodule Fields.PhoneNumber do
  @moduledoc """
  An Ecto Type for plaintext phone numbers.
  Useful for publicly available numbers such as customer support.
  See `Fields.PhoneNumberEncrypted` for storing numbers that are Personally Identifiable Information.

  ## Example

        schema "retailers" do
          field(:phone_number, Fields.PhoneNumber)
        end
  """
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    case Validate.phone_number(value) do
      true -> {:ok, to_string(value)}
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
