defmodule Fields.AES do
  @moduledoc """
  Encrypt values with AES in Galois/Counter Mode (GCM)
  https://en.wikipedia.org/wiki/Galois/Counter_Mode
  using a random Initialisation Vector for each encryption,
  this makes "bruteforce" decryption much more difficult.
  See `encrypt/1` and `decrypt/1` for more details.
  """
  # Use AES 256 Bit Keys for Encryption.
  @aad "AES256GCM"

  @doc """
  Encrypt Using AES Galois/Counter Mode (GCM)
  https://en.wikipedia.org/wiki/Galois/Counter_Mode
  Uses a random IV for each call, and prepends the IV and Tag to the
  ciphertext.  This means that `encrypt/1` will never return the same ciphertext
  for the same value. This makes "cracking" (bruteforce decryption) much harder!
  ## Parameters
  - `plaintext`: Accepts any data type as all values are converted to a String
    using `to_string` before encryption.
  - `key_id`: the index of the AES encryption key used to encrypt the ciphertext
  ## Examples
      iex> Fields.AES.encrypt("tea", 1) != Fields.AES.encrypt("tea", 1)
      true
      iex> ciphertext = Fields.AES.encrypt(123, 1)
      iex> is_binary(ciphertext)
      true
  """

  @spec encrypt(any, number) :: {String.t(), number}
  def encrypt(plaintext, key_id \\ get_key_id()) do
    # create random Initialisation Vector
    iv = :crypto.strong_rand_bytes(16)
    # get *specific* key (by id) from list of keys.
    key = get_key(key_id)
    {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {@aad, to_string(plaintext), 16})
    key_id_str = String.pad_leading(to_string(key_id), 4, "0") # 1 >> "0001"
    # "return" key_id_str with the iv, cipher tag & ciphertext
    key_id_str <> iv <> tag <> ciphertext # "concat" key_id iv cipher tag & ciphertext
  end

  @doc """
  Decrypt a binary using GCM.
  ## Parameters
  - `ciphertext`: a binary to decrypt, assuming that the first 16 bytes of the
    binary are the IV to use for decryption.
  - `key_id`: the index of the AES encryption key used to encrypt the ciphertext
  ## Example
      iex> Fields.AES.encrypt("test") |> Fields.AES.decrypt(1)
      "test"
  """
  @spec decrypt(String.t(), number) :: {String.t(), number}
  # patern match on binary to split parts:
  def decrypt(ciphertext, key_id) do
    <<key_index::binary-16, iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext
    # get encrytion/decryption key based on key_id
    key = get_key(key_id)
    :crypto.block_decrypt(:aes_gcm, key, iv, {@aad, ciphertext, tag})
  end

  # as above but *asumes* `default` (latest) encryption key is used.
  @spec decrypt(any) :: String.t()
  def decrypt(ciphertext) do
    <<key_id::binary-16, iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext
    decrypt(ciphertext, key_id)
  end

  # @doc """
  # Get the current key index.
  # The key used for the encryption is always the latest key in the list (ie most recent created key)
  # """
  defp get_key_id() do
    keys = Application.get_env(:fields, Fields.AES)[:keys]
    count = Enum.count(keys) - 1
  end

  # @doc """
  # get_key - Get encryption key from list of keys.
  # ## Parameters
  # - `key_id`: the index of AES encryption key used to encrypt the ciphertext
  # ## Example
  #     iex> Fields.AES.get_key
  #     <<13, 217, 61, 143, 87, 215, 35, 162, 183, 151, 179, 205, 37, 148>>
  # """ # doc commented out because https://stackoverflow.com/q/45171024/1148249
  @spec get_key(number) :: String
  defp get_key(key_id) do
    keys = Application.get_env(:fields, Fields.AES)[:keys]
    Enum.at(keys, key_id)
  end

end
