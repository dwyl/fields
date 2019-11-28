defmodule Fields.EncryptedWithKey do
  @moduledoc """
  An Ecto Type for encrypted fields.
  See `Fields.AES` for details on encryption/decryption.

  ## Example

        schema "users" do
          field(:name, Fields.Encrypted)
        end
  """
  alias Fields.AES

  @behaviour Ecto.Type
  def type, do: :map

  def cast(value) do
    key_id = 1 #dummy key id
    {:ok, %{value: value, key_id: key_id}}
  end

  def dump(map) do
    Ecto.Type.dump(:map, map)
    # ciphertext = value |> to_string |> AES.encrypt()
    # {:ok, ciphertext}
  end

  def load(value) do
    {:ok, value}
    # {:ok, AES.decrypt(value)}
  end

end
