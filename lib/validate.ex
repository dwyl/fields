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
end
