defmodule Fields.UrlTest do
  use ExUnit.Case
  alias Fields.{Url}

  describe "types" do
    test "Url.type is :string" do
      assert Url.type() == :string
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
    test "Url.dump returns a string" do
      assert {:ok, "http://www.test.com"} == Url.dump("http://www.test.com")
    end
  end

  describe "load" do
    test "Url.load returns a string" do
      assert {:ok, "http://www.test.com"} == Url.load("http://www.test.com")
    end
  end

  test "Url.equal?/2 confirms terms are equal" do
    assert Url.equal?("hello", "hello")
  end
end
