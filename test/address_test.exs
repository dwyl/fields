defmodule Fields.AddressTest do
  use ExUnit.Case
  alias Fields.{Address, AddressEncrypted}

  describe "types" do
    test "Address.type is :string" do
      assert Address.type() == :string
    end

    test "AddressEncrypted.type is :binary" do
      assert AddressEncrypted.type() == :binary
    end
  end

  describe "cast" do
    test "Address.cast accepts a string" do
      assert {:ok, "123 Test St"} == Address.cast("123 Test St")
      assert {:ok, "123 Test St"} == Address.cast("    123 Test St    ")
      assert {:ok, "123 Test St"} == AddressEncrypted.cast("123 Test St")
    end

    test "Address.cast validates Address" do
      assert :error == Address.cast("")
      assert :error == AddressEncrypted.cast("")
    end
  end

  describe "dump" do
    test "AddressEncrypted.dump encrypts a value" do
      {:ok, ciphertext} = AddressEncrypted.dump("123 Test St")

      assert ciphertext != "123 Test St"
      assert String.length(ciphertext) != 0
    end

    test "Address.dump returns a string" do
      assert {:ok, "123 Test St"} == Address.dump("123 Test St")
    end
  end

  describe "AddressEncrypted.load/1" do
    test "AddressEncrypted.load/1 decrypts a value" do
      {:ok, ciphertext} = AddressEncrypted.dump("123 Test St")
      assert {:ok, "123 Test St"} == AddressEncrypted.load(ciphertext)
    end
  end

  test "Address.equal?/2 confirms terms are equal" do
    assert Address.equal?("hello", "hello")
  end
end
