defmodule Fields.ValidatePhoneNumberTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Fields.Validate

  property "must have 10 significant digits" do
    check all(digits <- string(?0..?9, length: 10)) do
      phone = "0" <> digits
      assert Validate.phone_number(phone)
    end

    check all(digits <- string(?0..?9, max_length: 9)) do
      phone = "0" <> digits
      refute Validate.phone_number(phone)
    end

    check all(digits <- string(?0..?9, min_length: 11)) do
      phone = "0" <> digits
      refute Validate.phone_number(phone)
    end
  end

  property "must start with 0 or +44" do
    check all(digits <- string(?0..?9, length: 10)) do
      phone = "0" <> digits
      assert Validate.phone_number(phone)
    end

    check all(digits <- string(?0..?9, length: 10)) do
      phone = "+44" <> digits
      assert Validate.phone_number(phone)
    end

    check all(
            digits <- string(?0..?9, length: 10),
            code <- ?0..?9 |> string(length: 1) |> filter(fn a -> a != "0" && a != "+44" end)
          ) do
      phone = code <> digits
      refute Validate.phone_number(phone)
    end
  end

  property "must only contain numbers, +, or brackets" do
    check all(phone <- invalid_chars()) do
      refute Validate.phone_number(phone)
    end
  end

  def invalid_chars() do
    StreamData.string(:ascii, length: 10)
    |> StreamData.filter(fn s -> Regex.match?(~r/[^\d+\(\)]/, s) end)
    |> StreamData.map(fn s -> "0" <> s end)
  end
end
