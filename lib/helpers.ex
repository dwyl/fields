defmodule Fields.Helpers do
  @doc """
  Hash a string, or a value that implements the String.Chars protocol, using
  Argon2. Argon2 is a strong but slow hashing function, so is recommended
  for passwords.
  """
  @spec hash(atom(), String.Chars.t()) :: String.t()
  def hash(:argon2, value) do
    Argon2.Base.hash_password(to_string(value), Argon2.gen_salt(), [{:argon2_type, 2}])
  end
end
