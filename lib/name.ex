defmodule Fields.Name do
  @moduledoc """
  An Ecto Type for names that need to be stored securely.

  ## Example
    ```
    schema "user" do
      field :name, Fields.Name
      field :email, Fields.EmailEncrypted

      timestamps()
    end
    ```
  """
  alias Fields.{Validate, Encrypted}

  @behaviour Ecto.Type

  def type, do: :binary

  def cast(value) do
    value = value |> to_string() |> String.trim()

    case Validate.name(value) do
      true -> {:ok, value}
      false -> :error
    end
  end

  def dump(value) do
    Encrypted.dump(value)
  end

  def load(value) do
    Encrypted.load(value)
  end

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
