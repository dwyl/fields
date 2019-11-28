defmodule Fields.EmailTest do
  use ExUnit.Case
  alias Fields.{EmailPlaintext, EmailHash, EmailEncrypted}

  describe "types" do
    test "EmailPlaintext.type is :string" do
      assert EmailPlaintext.type() == :string
    end

    test "EmailEncrypted.type is :binary" do
      assert EmailEncrypted.type() == :binary
    end

    test "EmailHash.type is :binary" do
      assert EmailHash.type() == :binary
    end
  end

  describe "cast" do
    test "Email.cast accepts a string" do
      assert {:ok, "test@test.com"} == EmailPlaintext.cast("test@test.com")
      assert {:ok, "test@test.com"} == EmailEncrypted.cast("test@test.com")
      assert {:ok, "test@test.com"} == EmailHash.cast("test@test.com")
    end

    test "Email.cast validates email" do
      assert :error == EmailPlaintext.cast("invalid_email")
      assert :error == EmailEncrypted.cast("invalid_email")
      assert :error == EmailHash.cast("invalid_email")
    end
  end

  describe "dump" do
    test "EmailEncrypted.dump encrypts a value" do
      {:ok, ciphertext} = EmailEncrypted.dump("test@test.com")

      assert ciphertext != "test@test.com"
      assert String.length(ciphertext) != 0
    end

    test "EmailHash.dump converts a value to a sha256 hash" do
      {:ok, hash} = EmailHash.dump("test@test.com")

      assert hash ==
               <<217, 149, 14, 81, 96, 74, 72, 128, 75, 76, 49, 62, 14, 210, 156, 157, 103, 210,
                 53, 230, 76, 0, 157, 233, 152, 39, 164, 209, 158, 219, 72, 28>>
    end

    test "EmailPlaintext.dump returns a string" do
      assert {:ok, "test@test.com"} == EmailPlaintext.dump("test@test.com")
    end
  end

  describe "load" do
    test "EmailEncrypted.load/1 decrypts a value" do
      {:ok, ciphertext} = EmailEncrypted.dump("test@test.com")
      assert {:ok, "test@test.com"} == EmailEncrypted.load(ciphertext)
    end

    test "EmailEncrypted.load/2 decrypts a value" do
      {:ok, ciphertext} = EmailEncrypted.dump("test@test.com")
      keys = Application.get_env(:fields, Fields.AES)[:keys]
      key_id = Enum.count(keys) - 1
      assert {:ok, "test@test.com"} == EmailEncrypted.load(ciphertext, key_id)
    end

    test "EmailHash.load does not modify the hash, since the hash cannot be reversed" do
      hash =
        <<16, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
          141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

      assert {:ok, ^hash} = EmailHash.load(hash)
    end

    test "EmailPlaintext.load returns a string" do
      assert {:ok, "test@test.com"} == EmailPlaintext.load("test@test.com")
    end
  end
end
