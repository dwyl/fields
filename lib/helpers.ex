defmodule Fields.Helpers do
  @doc """
  Hash a string, or a value that implements the String.Chars protocol, using
  Argon2. Argon2 is a strong but slow hashing function, so is recommended
  for passwords.
  """
  @secret_key_base System.get_env("SECRET_KEY_BASE")

  @spec hash(atom(), String.Chars.t()) :: String.t()
  def hash(:argon2, value) do
    Argon2.Base.hash_password(to_string(value), Argon2.gen_salt(), [{:argon2_type, 2}])
  end

  @doc """
  Hash a string, or a value that implements the String.Chars protocol, using
  sha256. sha256 is fast, but not as strong as Argon2,
  so it is not recommended for hashing passwords.
  """
  @spec hash(atom(), String.Chars.t()) :: String.t()
  def hash(:sha256, value) do
    :crypto.hash(:sha256, to_string(value) <> get_salt(to_string(value)))
  end

  defp get_salt(value) do
    :crypto.hash(:sha256, value <> @secret_key_base)
  end
end
