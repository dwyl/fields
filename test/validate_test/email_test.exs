defmodule Fields.ValidateEmailTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Fields.Validate

  def valid_local() do
    '!#$%&\'*+-/=?^_`{|}~'
    |> Enum.concat(?a..?z)
    |> Enum.concat(?A..?Z)
    |> StreamData.string(min_length: 1)
  end

  def valid_domain() do
    StreamData.string(:alphanumeric, min_length: 1, max_length: 63)
  end

  property "valid local part of email" do
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

    # local part of email can not contain consecutive .
    check all left <- valid_local(),
              right <- valid_local() do
      email = left <> ".." <> right <> "@testing.com"
      refute Validate.email(email)
    end
  end

  property "must contain one @" do
    check all email <- string(:ascii) |> filter(&(!String.contains?(&1, "@"))) do
      refute Validate.email(email)
    end

    check all left <- valid_local(),
              right <- valid_local() do
      email = left <> "@" <> right <> "@testing.com"
      refute Validate.email(email)
    end
  end

  property "valid domain" do
    # domain can contain alphanumeric characters
    check all domain <- valid_domain() do
      email = "test@" <> domain
      assert Validate.email(email)
    end

    # domain cannot be longer than 63 characters
    check all domain <- string(:alphanumeric, min_length: 64) do
      email = "test@" <> domain
      refute Validate.email(email)
    end

    # two domains can be separated by a .
    check all first <- valid_domain(),
              second <- valid_domain() do
      email = "test@" <> first <> "." <> second
      assert Validate.email(email)
    end

    # one domain can have a hyphen
    check all first <- string(:alphanumeric, min_length: 1, max_length: 31),
              second <- string(:alphanumeric, min_length: 1, max_length: 31) do
      email = "test@" <> first <> "-" <> second
      assert Validate.email(email)
    end

    # hyphen cannot be at start of domain
    check all domain <- valid_domain() do
      email = "test@" <> "-" <> domain
      refute Validate.email(email)
    end

    # hyphen cannot be at end of domain
    check all domain <- valid_domain() do
      email = "test@" <> domain <> "-"
      refute Validate.email(email)
    end

    # hyphen cannot be at end of first domain
    check all first <- valid_domain(),
              second <- valid_domain() do
      email = "test@" <> first <> "-." <> second
      refute Validate.email(email)
    end

    # hyphen cannot be at end of second domain
    check all first <- valid_domain(),
              second <- valid_domain() do
      email = "test@" <> first <> "." <> second <> "-"
      refute Validate.email(email)
    end
  end

  property "valid email" do
    # single domain
    check all local <- valid_local(),
              domain <- valid_domain() do
      email = local <> "@" <> domain
      assert Validate.email(email)
    end

    # two domains
    check all local <- valid_local(),
              first_domain <- valid_domain(),
              second_domain <- valid_domain() do
      email = local <> "@" <> first_domain <> "." <> second_domain
      assert Validate.email(email)
    end
  end
end
