defmodule Fields.HelpersTest do
  use Fields.TestCase
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
             <<174, 246, 86, 49, 150, 37, 248, 198, 184, 83, 156, 224, 69, 244, 166, 158, 115,
               151, 78, 232, 149, 32, 212, 135, 106, 119, 218, 92, 50, 162, 56, 191>>
  end
end
