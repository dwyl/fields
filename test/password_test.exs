defmodule Fields.PasswordTest do
  use ExUnit.Case
  alias Fields.{Password, Helpers}

  test ".type is :binary" do
    assert Password.type() == :binary
  end

  test ".cast converts a value to a string" do
    assert {:ok, "42"} == Password.cast(42)
    assert {:ok, "atom"} == Password.cast(:atom)
  end

  test ".dump returns an Argon2id Hash given a password string" do
    {:ok, result} = Password.dump("password")
    assert is_binary(result)
    assert String.starts_with?(result, "$argon2id$v=19$m=65536,t=6,p=1$")
  end

  test ".dump uses Argon2id to Hash a value" do
    password = "EverythingisAwesome"
    {:ok, hash} = Password.dump(password)
    assert Argon2.verify_pass(password, hash)
  end

  test ".load does not modify the hash, since the hash cannot be reversed" do
    hash = Helpers.hash(:argon2, "password")
    assert {:ok, ^hash} = Password.load(hash)
  end
end
