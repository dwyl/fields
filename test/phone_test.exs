defmodule Fields.PhoneNumberTest do
  use Fields.TestCase
  alias Fields.{PhoneNumber, PhoneNumberEncrypted}

  describe "types" do
    test "PhoneNumber.type is :string" do
      assert PhoneNumber.type() == :string
    end

    test "PhoneNumberEncrypted.type is :binary" do
      assert PhoneNumberEncrypted.type() == :binary
    end
  end

  describe "cast" do
    test "PhoneNumber.cast accepts a string" do
      assert {:ok, "01234567890"} == PhoneNumber.cast("01234567890")
      assert {:ok, "01234567890"} == PhoneNumber.cast("01234567890")
      assert {:ok, "+441234567890"} == PhoneNumberEncrypted.cast("+441234567890")
      assert {:ok, "+441234567890"} == PhoneNumberEncrypted.cast("+441234567890")
    end

    test "PhoneNumber.cast validates PhoneNumber" do
      assert :error == PhoneNumber.cast("012345")
      assert :error == PhoneNumberEncrypted.cast("012345")
      assert :error == PhoneNumber.cast("bad_number")
      assert :error == PhoneNumberEncrypted.cast("bad_number")
    end
  end

  describe "dump" do
    test "PhoneNumberEncrypted.dump encrypts a value" do
      {:ok, ciphertext} = PhoneNumberEncrypted.dump("01234567890")

      assert ciphertext != "01234567890"
      assert String.length(ciphertext) != 0
    end

    test "PhoneNumber.dump returns a string" do
      assert {:ok, "01234567890"} == PhoneNumber.dump("01234567890")
    end
  end

  describe "load" do
    test "PhoneNumberEncrypted.load/1 decrypts a value" do
      {:ok, ciphertext} = PhoneNumberEncrypted.dump("01234567890")
      assert {:ok, "01234567890"} == PhoneNumberEncrypted.load(ciphertext)
    end

    test "PhoneNumber.load returns a string" do
      assert {:ok, "01234567890"} == PhoneNumber.load("01234567890")
    end
  end

  describe "equal?" do
    test "PhoneNumber.equal?/2 confirms terms are equal" do
      assert PhoneNumber.equal?("hello", "hello")
    end

    test "PhoneNumberEncrypted.equal?/2 confirms terms are equal" do
      assert PhoneNumberEncrypted.equal?("hello", "hello")
    end
  end
end
