defmodule Fields.Encrypted do
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

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
