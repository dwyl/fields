defmodule Fields.HtmlBodyTest do
  use Fields.TestCase
  alias Fields.HtmlBody, as: Body

  describe "types" do
    test "Body.type is :string" do
      assert Body.type() == :string
    end
  end

  describe "cast" do
    test "Body.cast accepts a string" do
      assert {:ok, "testing"} == Body.cast("testing")
    end
  end

  describe "dump" do
    test "Body.dump strips html script tags only" do
      {:ok, stripped} = Body.dump("<h1>Hello <script>World!</script></h1>")

      assert stripped != "<h1>Hello <script>World!</script></h1>"
      assert stripped == "<h1>Hello World!</h1>"
    end
  end

  describe "load" do
    test "Body.load returns a string" do
      assert {:ok, "testing"} == Body.load("testing")
    end
  end

  describe "input_type" do
    test "Body.input_type returns :textarea" do
      assert Body.input_type() == :textarea
    end
  end

  describe "equal?" do
    test "Body.equal?/2 confirms terms are equal" do
      assert Body.equal?("hello", "hello")
    end
  end
end
