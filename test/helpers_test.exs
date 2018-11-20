defmodule Fields.HelpersTest do
  use ExUnit.Case
  alias Fields.Helpers

  test "hash/2 uses Argon2id to Hash a value" do
    password = "password"
    hash = Helpers.hash(:argon2, password)
    assert Argon2.verify_pass(password, hash)
  end

  test "hash/2 works with numbers" do
    password = 123
    hash = Helpers.hash(:argon2, password)
    assert Argon2.verify_pass(to_string(password), hash)
  end

  test "hash/2 uses sha256 to hash a value" do
    hash = Helpers.hash(:sha256, "alex@example.com")

    assert hash ==
             <<225, 207, 237, 158, 254, 87, 155, 207, 32, 13, 44, 208, 213, 24, 120, 1, 18, 140,
               174, 94, 142, 95, 200, 228, 84, 25, 21, 163, 194, 121, 117, 244>>
  end
end
