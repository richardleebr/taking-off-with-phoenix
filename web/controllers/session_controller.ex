defmodule Workshop.SessionController do
  use Workshop.Web, :controller

  alias Workshop.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"session" => %{"email" => email, "password" => password}}) do
    user = Repo.get_by(User, email: email)
    IO.puts password
    IO.puts user.hashed_password
    if user && Comeonin.Bcrypt.checkpw(password, user.hashed_password) do
      conn
      |> put_flash(:info, "logged in")
      |> put_session(:current_user_id, user.id)
      |> redirect(to: page_path(conn, :index))
    else
      Comeonin.Bcrypt.dummy_checkpw()

      conn
      |> put_flash(:error, "incorrect email or password")
      |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: page_path(conn, :index))
  end
end