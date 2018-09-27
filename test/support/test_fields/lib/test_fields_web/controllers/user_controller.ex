defmodule TestFieldsWeb.UserController do
  use TestFieldsWeb, :controller
  use Fields

  alias TestFields.User

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    render_fields(conn, :create, User, changeset: changeset)
  end

  def edit(conn, %{"id" => id}) do
    user = %User{name: "Test User", age: "55", id: id}
    changeset = User.changeset(user, %{})

    conn
    |> render_fields(:update, User, user: user, changeset: changeset)
  end
end
