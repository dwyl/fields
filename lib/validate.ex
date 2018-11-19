defmodule Fields.Validate do
  @moduledoc """
  Helper functions to validate the data in certain fields
  """

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
end
