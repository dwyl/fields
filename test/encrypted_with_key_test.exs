defmodule Fields.EncryptedWithKeyTest do
  use ExUnit.Case
  alias Fields.EncryptedWithKey

  test ".type is :map" do
    assert EncryptedWithKey.type() == :map
  end

  test ".cast converts a value to a map" do
    assert {:ok, %{value: 123, key_id: 1}} == EncryptedWithKey.cast(123)
  end

end
