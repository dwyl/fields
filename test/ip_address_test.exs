defmodule Fields.IpAddressTest do
  use ExUnit.Case
  alias Fields.{IpAddressPlaintext, IpAddressHash, IpAddressEncrypted}

  describe "types" do
    test "IpAddressPlaintext.type is :string" do
      assert IpAddressPlaintext.type() == :string
    end

    test "IpAddressEncrypted.type is :binary" do
      assert IpAddressEncrypted.type() == :binary
    end

    test "IpAddressHash.type is :binary" do
      assert IpAddressHash.type() == :binary
    end
  end

  describe "cast" do
    test "IpAddressPlaintext.cast accepts a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.cast("168.212.226.204")
      assert {:ok, "168.212.226.204"} == IpAddressHash.cast("168.212.226.204")
      assert {:ok, "168.212.226.204"} == IpAddressEncrypted.cast("168.212.226.204")
    end

    test "IpAddressPlaintext.cast validates ip_address" do
      assert :error == IpAddressPlaintext.cast("invalid_ip_address")
      assert :error == IpAddressHash.cast("invalid_ip_address")
      assert :error == IpAddressEncrypted.cast("invalid_ip_address")
    end
  end

  describe "dump" do
    test "IpAddressPlaintext.dump returns a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.dump("168.212.226.204")
    end

    test "IPAddressEncrypted.dump encrypts a value" do
      {:ok, ciphertext} = IpAddressEncrypted.dump("168.212.226.204")

      assert ciphertext != "168.212.226.204"
      assert String.length(ciphertext) != 0
    end

    test "IPAddressHash.dump converts a value to a sha256 hash" do
      {:ok, hash} = IpAddressHash.dump("168.212.226.204")

      assert hash ==
               <<15, 207, 103, 241, 26, 204, 117, 4, 20, 61, 83, 155, 63, 106, 136, 7, 52, 7, 100,
                 15, 120, 65, 79, 144, 237, 84, 51, 144, 2, 147, 171, 80>>
    end
  end

  describe "load" do
    test "IpAddressPlaintext.load returns a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.load("168.212.226.204")
    end

    test "IPAddressEncrypted.load/1 decrypts a value" do
      {:ok, ciphertext} = IpAddressEncrypted.dump("168.212.226.204")
      assert {:ok, "168.212.226.204"} == IpAddressEncrypted.load(ciphertext)
    end

    test "IPAddressHash.load does not modify the hash, since the hash cannot be reversed" do
      hash =
        <<15, 207, 103, 241, 26, 204, 117, 4, 20, 61, 83, 155, 63, 106, 136, 7, 52, 7, 100, 15,
          120, 65, 79, 144, 237, 84, 51, 144, 2, 147, 171, 80>>

      assert {:ok, ^hash} = IpAddressHash.load(hash)
    end
  end

  describe "equal?" do
    test "IpAddressPlainText.equal?/2 confirms terms are equal" do
      assert IpAddressPlaintext.equal?("168.212.226.204", "168.212.226.204")
    end

    test "IpAddressHash.equal?/2 confirms terms are equal" do
      assert IpAddressHash.equal?("168.212.226.204", "168.212.226.204")
    end

    test "IpAddressEncrypted.equal?/2 confirms terms are equal" do
      assert IpAddressEncrypted.equal?("168.212.226.204", "168.212.226.204")
    end
  end
end
