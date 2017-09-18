defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic} = params) do
    insertion = %Topic{}
    |> Topic.changeset(topic)
    |> Repo.insert

    case insertion do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Ya dun goofed")
        |> redirect(to: topic_path(conn, :new))
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id} = params) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic} = params) do
    old_topic = Repo.get(Topic, topic_id)

    updated = Topic.changeset(old_topic, topic)
    |> Repo.update

    case updated do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated!")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} ->
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id} = params) do
    deleted = Repo.get!(Topic, topic_id) |> Repo.delete!

    conn
    |> put_flash(:warning, "Topic Deleted!")
    |> redirect(to: topic_path(conn, :index))
  end

  def show(conn, %{"id" => topic_id} = params) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end
end
