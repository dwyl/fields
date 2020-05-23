defmodule Fields.IpAddressTest do
  use ExUnit.Case
  alias Fields.{IpAddressPlaintext}

  describe "types" do
    test "IpAddressPlaintext.type is :string" do
      assert IpAddressPlaintext.type() == :string
    end
  end

  describe "cast" do
    test "IpAddressPlaintext.cast accepts a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.cast("168.212.226.204")
    end

    test "IpAddressPlaintext.cast validates ip_address" do
      assert :error == IpAddressPlaintext.cast("invalid_ip_address")
    end
  end

  describe "dump" do
    test "IpAddressPlaintext.dump returns a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.dump("168.212.226.204")
    end
  end

  describe "load" do
    test "IpAddressPlaintext.load returns a string" do
      assert {:ok, "168.212.226.204"} == IpAddressPlaintext.load("168.212.226.204")
    end
  end

  describe "equal?" do
    test "IpAddressPlainText.equal?/2 confirms terms are equal" do
      assert IpAddressPlaintext.equal?("168.212.226.204", "168.212.226.204")
    end
  end
end
