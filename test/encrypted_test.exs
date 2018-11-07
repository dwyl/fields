defmodule Fields.EncryptedTest do
  use ExUnit.Case
  alias Fields.Encrypted

  test ".type is :binary" do
    assert Encrypted.type() == :binary
  end

  test ".cast converts a value to a string" do
    assert {:ok, "123"} == Encrypted.cast(123)
  end

  test ".dump encrypts a value" do
    {:ok, ciphertext} = Encrypted.dump("hello")

    assert ciphertext != "hello"
    assert String.length(ciphertext) != 0
  end

  test ".load decrypts a value" do
    {:ok, ciphertext} = Encrypted.dump("hello")
    keys = Application.get_env(:fields, Fields.AES)[:keys]
    key_id = Enum.count(keys) - 1
    assert {:ok, "hello"} == Encrypted.load(ciphertext, key_id)
  end
end
