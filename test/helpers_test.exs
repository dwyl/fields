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
end
