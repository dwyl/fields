defmodule Fields.HtmlBody do
  @moduledoc """
  An Ecto Type for bodies of html text.
  Strips out all HTML script tags to avoid XSS but allows other basic HTML
  elements to remain.

  ## Example

      schema "article" do
        field(:body, Fields.HtmlBody)
      end
  """
  @behaviour Ecto.Type

  def type, do: :string

  def cast(value) do
    {:ok, to_string(value)}
  end

  def dump(value) do
    {:ok, HtmlSanitizeEx.basic_html(value)}
  end

  def load(value) do
    {:ok, value}
  end

  def input_type, do: :textarea
end
