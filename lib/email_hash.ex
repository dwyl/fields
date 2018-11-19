defmodule Fields.EmailHash do
  alias Fields.{EmailPlaintext, Hash}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value), do: EmailPlaintext.cast(value)

  def dump(value), do: Hash.dump(value)

  def load(value) do
    {:ok, value}
  end
end
