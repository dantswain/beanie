defmodule Beanie.RepositoryControllerTest do
  use Beanie.ConnCase

  alias Beanie.Repository
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{name: nil}

  @valid_repository %Repository{name: "name"}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, repository_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing repositories"
  end

  test "shows chosen resource", %{conn: conn} do
    repository = Repo.insert! @valid_repository
    conn = get conn, repository_path(conn, :show, repository)
    assert html_response(conn, 200) =~ "Show repository"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, repository_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    repository = Repo.insert! @valid_repository
    conn = get conn, repository_path(conn, :edit, repository)
    assert html_response(conn, 200) =~ "Edit repository"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    repository = Repo.insert! @valid_repository
    conn = put conn, repository_path(conn, :update, repository), repository: @valid_attrs
    assert redirected_to(conn) == repository_path(conn, :show, repository)
    assert Repo.get_by(Repository, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    repository = Repo.insert! @valid_repository
    conn = put conn, repository_path(conn, :update, repository), repository: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit repository"
  end
end
