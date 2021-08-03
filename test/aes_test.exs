defmodule Fields.AESTest do
  use ExUnit.Case
  alias Fields.AES

  doctest Fields.AES

  test ".encrypt can encrypt a value" do
    assert AES.encrypt("hello") != "hello"
  end

  test ".encrypt can encrypt a number" do
    assert is_binary(AES.encrypt(123))
  end

  test ".encrypt includes the random IV in the value" do
    <<iv::binary-16, ciphertext::binary>> = AES.encrypt("hello")

    assert String.length(iv) != 0
    assert String.length(ciphertext) != 0
    assert is_binary(ciphertext)
  end

  test ".encrypt does not produce the same ciphertext twice" do
    assert AES.encrypt("hello") != AES.encrypt("hello")
  end

  test "can decrypt a value" do
    plaintext = "hello" |> AES.encrypt() |> AES.decrypt()
    assert plaintext == "hello"
  end

  test "decrypt/1 ciphertext that was encrypted with default key" do
    plaintext = "hello" |> AES.encrypt() |> AES.decrypt()
    assert plaintext == "hello"
  end
end
