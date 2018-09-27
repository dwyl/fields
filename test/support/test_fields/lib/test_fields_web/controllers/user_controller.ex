defmodule TestFieldsWeb.UserController do
  use TestFieldsWeb, :controller

  alias TestFields.User

  use Fields

  def index(conn, _params) do
    # users = Accounts.list_users()
    # render(conn, "index.html", users: users)
    conn
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{}, %{})

    render_fields(conn, :create, User, changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    # case Accounts.create_user(user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User created successfully.")
    #     |> redirect(to: user_path(conn, :show, user))
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "new.html", changeset: changeset)
    # end
    conn
  end

  def show(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # render(conn, "show.html", user: user)
    conn
  end

  def edit(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # changeset = Accounts.change_user(user)

    # conn
    # |> render_fields(:update, User, user: user, changeset: changeset)
    conn
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    # IO.inspect id
    # user = Accounts.get_user!(id)

    # case Accounts.update_user(user, user_params) do
    #   {:ok, user} ->
    #     conn
    #     |> put_flash(:info, "User updated successfully.")
    #     |> redirect(to: user_path(conn, :show, user))
    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     render(conn, "edit.html", user: user, changeset: changeset)
    # end
    conn
  end

  def delete(conn, %{"id" => id}) do
    # user = Accounts.get_user!(id)
    # {:ok, _user} = Accounts.delete_user(user)

    # conn
    # |> put_flash(:info, "User deleted successfully.")
    # |> redirect(to: user_path(conn, :index))
    conn
  end
end
