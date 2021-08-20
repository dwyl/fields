defmodule Fields.Helpers do
  @moduledoc false
  @doc """
  Hash a string, or a value that implements the String.Chars protocol, using
  Argon2. Argon2 is a strong but slow hashing function, so is recommended
  for passwords.
  """
  @spec hash(atom(), String.Chars.t()) :: String.t()
  def hash(:argon2, value) do
    Argon2.Base.hash_password(to_string(value), Argon2.gen_salt(), [{:argon2_type, 2}])
  end

  @spec hash(atom(), String.Chars.t()) :: String.t()
  def hash(:sha256, value) do
    :crypto.hash(:sha256, to_string(value) <> get_salt(to_string(value)))
  end

  defp get_salt(value) do
    :crypto.hash(:sha256, value <> fetch_secret_key_base())
  end

  defp fetch_secret_key_base do
    Application.fetch_env!(:fields, :secret_key_base)
  end
end
