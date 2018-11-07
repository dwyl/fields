defmodule Fields.Encrypted do
  alias Fields.AES

  @behaviour Ecto.Type
  def type, do: :binary

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    ciphertext = value |> to_string |> AES.encrypt()
    {:ok, ciphertext}
  end

  def load(value) do
    {:ok, AES.decrypt(value)}
  end

  def load(value, key_id) do
    {:ok, AES.decrypt(value, key_id)}
  end
end
