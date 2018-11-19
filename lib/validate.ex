defmodule Fields.Validate do
  def email(email) do
    {:ok, regex} =
      Regex.compile(
        "^[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]*(?<!\\.)@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
      )

    Regex.match?(regex, email)
  end
end
