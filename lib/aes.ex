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
      iex> Fields.AES.encrypt("tea") != Fields.AES.encrypt("tea")
      true
      iex> ciphertext = Fields.AES.encrypt(123)
      iex> is_binary(ciphertext)
      true
  """

  @spec encrypt(any) :: String.t()
  def encrypt(plaintext) do
    # create random Initialisation Vector
    iv = :crypto.strong_rand_bytes(16)
    # get *specific* key (by id) from list of keys.
    key_id = get_key_id()
    key = get_key(key_id)
    {ciphertext, tag} = :crypto.block_encrypt(:aes_gcm, key, iv, {@aad, to_string(plaintext), 16})
    # 1 >> "0001"
    key_id_str = String.pad_leading(to_string(key_id), 4, "0")
    # "return" key_id_str with the iv, cipher tag & ciphertext
    # "concat" key_id iv cipher tag & ciphertext
    key_id_str <> iv <> tag <> ciphertext
  end

  @doc """
  Decrypt a binary using GCM.
  ## Parameters
  - `ciphertext`: a binary to decrypt, assuming that the first 16 bytes of the
    binary are the IV to use for decryption.
  - `key_id`: the index of the AES encryption key used to encrypt the ciphertext
  ## Example
      iex> Fields.AES.encrypt("test") |> Fields.AES.decrypt()
      "test"
  """

  # as above but *asumes* `default` (latest) encryption key is used.
  @spec decrypt(any) :: String.t()
  def decrypt(ciphertext) do
    <<key_id_str::binary-4, iv::binary-16, tag::binary-16, ciphertext::binary>> = ciphertext
    key_id = String.to_integer(key_id_str)
    key = get_key(key_id)
    :crypto.block_decrypt(:aes_gcm, key, iv, {@aad, ciphertext, tag})
  end

  # @doc """
  # Get the current key index.
  # The key used for the encryption is always the latest key in the list (ie most recent created key)
  # """
  defp get_key_id() do
    keys = Application.get_env(:fields, Fields.AES)[:keys]
    Enum.count(keys) - 1
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
