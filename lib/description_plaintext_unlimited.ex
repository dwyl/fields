defmodule Fields.DescriptionPlaintextUnlimited do
  @moduledoc """
  An Ecto Type for plaintext description fields with no length restrictions.
  Strips out all HTML tags to avoid XSS.

  ## Example

      schema "article" do
        field(:description, Fields.DescriptionPlaintextUnlimited)
      end
  """
  use Ecto.Type

  def type, do: :string

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    {:ok, HtmlSanitizeEx.strip_tags(value)}
  end

  def load(value) do
    {:ok, value}
  end

  def input_type, do: :textarea

  def embed_as(_), do: :self

  def equal?(term1, term2), do: term1 == term2
end
