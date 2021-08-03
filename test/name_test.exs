defmodule Fields.NameTest do
  use ExUnit.Case
  alias Fields.{Name, Encrypted}

  describe "types" do
    test "Name.type is :string" do
      assert Name.type() == :binary
    end
  end

  describe "cast" do
    test "Name.cast checks length must be greater than 1" do
      assert :error == Name.cast("0")
    end

    test "Name.cast accepts a string" do
      assert {:ok, "Alex"} == Name.cast("Alex")
    end

    test "Name.cast validates if name is too long" do
      assert :error == Name.cast("supercalifragilisticexpialidocious36")
      # test to_string works for numbers
      assert :error == Name.cast(1)
    end
  end

  describe "dump" do
    test "Name.dump returns an encrypted string" do
      {:ok, ciphertext} = Encrypted.dump("Jimmy Eats World")
      assert is_binary(ciphertext)
    end
  end

  describe "load" do
    test "Name.load returns a decrypted string" do
      {:ok, ciphertext} = Name.dump("Angus McAwesome")
      {:ok, decrypted} = Name.load(ciphertext)
      assert "Angus McAwesome" == decrypted
    end
  end

  test "Name.equal?/2 confirms terms are equal" do
    assert Name.equal?("hello", "hello")
  end
end
