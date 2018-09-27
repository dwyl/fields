defmodule FieldsTest do
  use TestFieldsWeb.ConnCase
  doctest Fields

  describe "GET /users/new" do
    test "Correct fields exist", %{conn: conn} do
      assert response =
        conn
        |> get(user_path(conn, :new))
        |> html_response(200)

      assert response =~ "age"
      assert response =~ "name"
    end

    test "Correct form action", %{conn: conn} do
      assert response =
        conn
        |> get(user_path(conn, :new))
        |> html_response(200)

      assert response =~ ~s(action="/users")
    end
  end

  describe "GET /users/1/edit" do
    test "Correct fields exist", %{conn: conn} do
      assert response =
        conn
        |> get(user_path(conn, :edit, 1))
        |> html_response(200)

      assert response =~ "age"
      assert response =~ "name"
    end

    test "Existing data prefilled in form", %{conn: conn} do
      assert response =
        conn
        |> get(user_path(conn, :edit, 1))
        |> html_response(200)

      assert response =~ "Test User"
      assert response =~ "55"
    end

    test "Correct form action", %{conn: conn} do
      assert response =
        conn
        |> get(user_path(conn, :edit, 1))
        |> html_response(200)

      assert response =~ ~s(action="/users/1")
    end
  end
end
