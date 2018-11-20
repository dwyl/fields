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
             <<182, 157, 193, 195, 194, 54, 161, 104, 62, 219, 55, 39, 12, 127, 11, 187, 120, 98,
               218, 185, 11, 61, 167, 121, 228, 8, 215, 53, 110, 89, 4, 128>>
  end

  test ".load does not modify the hash, since the hash cannot be reversed" do
    hash =
      <<16, 231, 67, 229, 9, 181, 13, 87, 69, 76, 227, 205, 43, 124, 16, 75, 46, 161, 206, 219,
        141, 203, 199, 88, 112, 1, 204, 189, 109, 248, 22, 254>>

    assert {:ok, ^hash} = Hash.load(hash)
  end
end
