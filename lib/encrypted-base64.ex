defmodule Fields.EncryptedBase64 do
  @moduledoc """
  An Ecto Type for encrypted fields.
  See `Fields.AES` for details on encryption/decryption.

  ## Example

        schema "users" do
          field :name, Fields.EncryptedBase64
        end
  """
  use Ecto.Type
  alias Fields.AES
  require Logger

  def type(),
    do: :string

  def cast(value),
    do: {:ok, to_string(value)}

  def dump(value),
    do:
      value
      |> then(fn
        # Input value is nil. Store as-is. It's the developer's job
        # to run validations if they don't want that.
        nil -> value
        # Value is any kind of binary. Encrypt, and base64 encode.
        <<>> <> _ -> value |> to_string |> AES.encrypt() |> Base.encode64(padding: true)
      end)
      |> then(& {:ok, &1})

  def load(value),
    do:
      value
      |> then(fn
        # We got nil from the database... Just use that.
        nil -> value
        # We got any binary. Decode64 and decrypt.
        <<>> <> _ -> value |> Base.decode64!(padding: true) |> AES.decrypt()
      end)
      |> then(& {:ok, &1})

  def embed_as(_),
    do: :dump

  def equal?(term1, term2),
    do: term1 == term2
end
