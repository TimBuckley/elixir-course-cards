defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User


  def init(_init_options) do
    _init_options
  end

  def call(conn, _init_options) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        conn
        |> assign(:user, user)
      true ->
        conn
        |> assign(:user, nil)
    end
  end
end
