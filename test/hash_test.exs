defmodule Fields.HashTest do
  use ExUnit.Case
  alias Fields.Hash

  test ".type is :binary" do
    assert Hash.type() == :binary
  end

  test ".cast converts a value to a string" do
    assert {:ok, "42"} == Hash.cast(42)
    assert {:ok, "atom"} == Hash.cast(:atom)
  end

  test ".dump converts a value to a sha256 hash" do
    {:ok, hash} = Hash.dump("hello")

    assert hash ==
             <<207, 65, 85, 134, 204, 120, 27, 4, 245, 204, 86, 6, 85, 48, 252, 242, 8, 75, 210,
               30, 49, 50, 86, 91, 17, 108, 189, 90, 54, 16, 21, 172>>
  end

  test ".load does not modify the hash, since the hash cannot be reversed" do
    hash =
      <<16, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
        141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

    assert {:ok, ^hash} = Hash.load(hash)
  end

  describe "equal?" do
    test "Hash.equal?/2 confirms terms are equal" do
      assert Hash.equal?("hello", "hello")
    end
  end
end
