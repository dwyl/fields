defmodule Fields.ValidateTest do
  use ExUnit.Case
  alias Fields.Validate
  use ExUnitProperties

  def valid_local() do
    valid_chars =
      '!#$%&\'*+-/=?^_`{|}~'
      |> Enum.concat(?a..?z)
      |> Enum.concat(?A..?Z)

    StreamData.string(valid_chars, min_length: 1)
  end

  property "local part of email" do
    # local part of email can contain alphanumeric characters
    check all local <- string(:alphanumeric, min_length: 1) do
      email = local <> "@testing.com"
      assert Validate.email(email)
    end

    # local part of email can contain these special characters
    check all local <- string('!#$%&\'*+-/=?^_`{|}~', min_length: 1) do
      email = local <> "@testing.com"
      assert Validate.email(email)
    end

    # local part of email can contain a combination of alphanumeric and special characters
    check all local <- valid_local() do
      email = local <> "@testing.com"
      assert Validate.email(email)
    end

    # local part of email can contain .
    check all left <- valid_local(),
              right <- valid_local() do
      email = left <> "." <> right <> "@testing.com"
      assert Validate.email(email)
    end

    # local part of email can not start with .
    check all local <- valid_local() do
      email = "." <> local <> "@testing.com"
      refute Validate.email(email)
    end

    # local part of email can not end with .
    check all local <- valid_local() do
      email = local <> "." <> "@testing.com"
      refute Validate.email(email)
    end
  end

  property "must contain @" do
    check all email <- string(:ascii) |> filter(&(!String.contains?(&1, "@"))) do
      refute Validate.email(email)
    end
  end
end
