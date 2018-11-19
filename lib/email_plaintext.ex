defmodule Fields.EmailPlaintext do
  alias Fields.Validate

  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    case Validate.email(value) do
      true -> {:ok, to_string(value)}
      false -> {:error, email: :invalid}
    end
  end

  def dump(value) do
    {:ok, to_string(value)}
  end

  def load(value) do
    {:ok, value}
  end
end
