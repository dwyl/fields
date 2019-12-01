defmodule Fields.Validate do
  @moduledoc """
  Helper functions to validate the data in certain fields
  """

  @doc """
  Validate an address.
  Currently just validates that some input has been given.
  """
  def address(address) do
    String.length(address) > 0
  end

  @doc """
  Validate the format of an email address using a regex.
  Uses a slightly modified version of the w3c HTML5 spec email regex (https://www.w3.org/TR/html5/forms.html#valid-e-mail-address),
  with additions to account for not allowing emails to start or end with '.',
  and a check that there are no consecutive '.'s.
  """
  def email(email) do
    {:ok, regex} =
      Regex.compile(
        "^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]*(?<!\\.)@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
      )

    Regex.match?(regex, email) && !String.contains?(email, "..")
  end

  @doc """
  Validates the format of a UK phone number.
  """
  def phone_number(phone) do
    regex =
      ~r/^(((\+44\s?\d{4}|\(?0\d{4}\)?)\s?\d{3}\s?\d{3})|((\+44\s?\d{3}|\(?0\d{3}\)?)\s?\d{3}\s?\d{4})|((\+44\s?\d{2}|\(?0\d{2}\)?)\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/

    Regex.match?(regex, phone)
  end

  @doc """
  Validate the format of an postcode using a regex.
  All existing postcodes in the UK should pass this validation;
  some non-existent ones may too if they follow the standard UK postcode format.
  """
  def postcode(postcode) do
    {:ok, regex} =
      Regex.compile(
        "^([A-Za-z][A-Za-z]?[0-9][A-Za-z0-9]? ?[0-9][A-Za-z]{2}|[Gg][Ii][Rr] ?0[Aa]{2})$"
      )

    Regex.match?(regex, postcode)
  end

  @doc """
  Validate the format of a url using a regex.
  See https://git.io/fpdad for details on how the regex for validation was chosen
  """
  def url(url) do
    {:ok, regex} =
      Regex.compile(
        "^(?:(?:https?|ftp)://)(?:\S+(?::\S*)?@)?(?:(?!10(?:\\.\d{1,3}){3})(?!127(?:\\.\d{1,3}){3})(?!169\\.254(?:\\.\d{1,3}){2})(?!192\\.168(?:\\.\d{1,3}){2})(?!172\\.(?:1[6-9]|2\d|3[0-1])(?:\\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)(?:\\.(?:[a-z\x{00a1}-\x{ffff}0-9]+-?)*[a-z\x{00a1}-\x{ffff}0-9]+)*(?:\\.(?:[a-z\x{00a1}-\x{ffff}]{2,})))(?::\d{2,5})?(?:/[^\s]*)?$"
      )

    Regex.match?(regex, url)
  end
end
