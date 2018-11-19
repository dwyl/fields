defmodule Fields.Postcode do
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    case Validate.postcode(value) do
      true -> {:ok, to_string(value)}
      false -> {:error, postcode: :invalid}
    end
  end

  def dump(value) do
    {:ok, to_string(value)}
  end

  def load(value) do
    {:ok, value}
  end
end
