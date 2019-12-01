defmodule Fields.UrlEncryptedTest do
  use ExUnit.Case
  alias Fields.UrlEncrypted, as: Url
  alias Fields.Encrypted

  describe "types" do
    test "Url.type is :string" do
      assert Url.type() == :binary
    end
  end

  describe "cast" do
    test "Url.cast accepts a string" do
      assert {:ok, "http://www.test.com"} == Url.cast("http://www.test.com")
    end

    test "Url.cast requires a protocol scheme" do
      assert {:ok, "https://www.test.com"} == Url.cast("https://www.test.com")
      assert {:ok, "http://www.test.com"} == Url.cast("http://www.test.com")
      assert {:ok, "ftp://www.test.com"} == Url.cast("ftp://www.test.com")
      assert :error == Url.cast("://www.test.com")
      assert :error == Url.cast("www.test.com")
    end

    test "Url.cast validates url" do
      assert {:ok, "https://www.test.com"} == Url.cast("https://www.test.com ")
      assert :error == Url.cast("http:/www.invalid_url.com") # single forwardslash
      assert :error == Url.cast(1) # test to_string works for numbers
    end
  end

  describe "dump" do
    test "Url.dump returns an encrypted string" do
      {:ok, ciphertext } = Encrypted.dump("http://www.test.com")
      # IO.inspect ciphertext
      assert is_binary ciphertext
    end
  end

  describe "load" do
    test "Url.load returns a decrypted string" do
      {:ok, ciphertext} = Url.dump("http://www.test.com")
      {:ok, decrypted} = Url.load(ciphertext)
      assert "http://www.test.com" == decrypted
    end
  end

  test "UrlEncrypted.equal?/2 confirms terms are equal" do
    assert Url.equal?("hello", "hello")
  end
end
