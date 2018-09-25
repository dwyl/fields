defmodule Fields.FieldsView do
  use Phoenix.View, root: "lib/templates"
  use Phoenix.HTML
  import Phoenix.HTML.Form
  import Fields.ErrorHelpers

  def input(form, field, opts) do
    type = Phoenix.HTML.Form.input_type(form, field)
    apply(Phoenix.HTML.Form, type, [form, field, opts])
  end
end
