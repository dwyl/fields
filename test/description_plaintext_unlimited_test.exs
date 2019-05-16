defmodule Fields.DescriptionPlaintextUnlimitedTest do
  use ExUnit.Case
  alias Fields.DescriptionPlaintextUnlimited, as: Description

  describe "types" do
    test "Desription.type is :string" do
      assert Description.type() == :string
    end
  end

  describe "cast" do
    test "Description.cast accepts a string" do
      assert {:ok, "testing"} == Description.cast("testing")
    end

    test "Description does NOT strip whitespace" do
      assert {:ok, " testing  "} == Description.cast(" testing  ")
    end

    test "description is cast to_string" do
      assert {:ok, "123"} == Description.cast(123)
    end
  end

  describe "dump" do
    test "Description.dump strips html tags" do
      {:ok, stripped} = Description.dump("<script>alert('hello')</script>")

      assert stripped != "<script>alert('hello')</script>"
      assert stripped == "alert('hello')"
    end
  end

  describe "load" do
    test "Description.load returns a string" do
      assert {:ok, "testing"} == Description.load("testing")
    end
  end

  describe "input_type" do
    test "Description.input_type returns :textarea" do
      assert Description.input_type() == :textarea
    end
  end
end
