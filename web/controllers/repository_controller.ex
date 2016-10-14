defmodule Beanie.RepositoryController do
  use Beanie.Web, :controller

  alias Beanie.Repository

  def index(conn, params) do
    case repository_list(params["update"]) do
      {:ok, repositories, :updated} ->
        conn
        |> put_flash(:info, "Repository list updated")
        |> render("index.html", repositories: repositories)
      {:ok, repositories} ->
        conn
        |> render("index.html", repositories: repositories)
      {:error, repositories} ->
        conn
        |> put_flash(:error, "Error fetching repositories")
        |> render("index.html", repositories: repositories)
    end
  end

  def show(conn, params = %{"id" => id}) do
    repository = fetch_repository(id, params["update"])
    render(conn, "show.html", repository: repository)
  end

  def edit(conn, %{"id" => id}) do
    repository = Repo.get!(Repository, id)
    changeset = Repository.changeset(repository)
    render(conn, "edit.html", repository: repository, changeset: changeset)
  end

  def update(conn, %{"id" => id, "repository" => repository_params}) do
    repository = Repo.get!(Repository, id)
    changeset = Repository.changeset(repository, repository_params)

    case Repo.update(changeset) do
      {:ok, repository} ->
        conn
        |> put_flash(:info, "Repository updated successfully.")
        |> redirect(to: repository_path(conn, :show, repository))
      {:error, changeset} ->
        render(conn, "edit.html", repository: repository, changeset: changeset)
    end
  end

  defp repository_list("true") do
    case Beanie.RegistryAPI.catalog(Beanie.registry) do
      {:error, _} -> {:error, []}
      {:ok, from_docker} ->
        Beanie.Repository.Query.update_list(from_docker)
        # TODO refresh repository listing, then fetch from db
        {:ok, Repo.all(Repository), :updated}
    end
  end
  defp repository_list(_) do
    {:ok, Repo.all(Repository)}
  end

  defp fetch_repository(id, "true") do
    repo = Repo.get!(Repository, id)
    %{"tags" => tags} = Beanie.RegistryAPI.tag_list(Beanie.registry, repo.name)
    tags = Enum.map(tags, fn(tag_name) ->
      manifest = Beanie.RegistryAPI.manifest(Beanie.registry, repo.name, tag_name)
      created_at = Beanie.RegistryAPI.created_at_from_manifest(manifest)
      %Beanie.Tag{name: tag_name, creation_timestamp: created_at, repository: repo}
    end)
    Beanie.Repository.Query.update_tag_list(repo, tags)
    %{ repo | tags: tags }
  end
  defp fetch_repository(id, _) do
    Repo.get!(Repository, id) |> Repo.preload(:tags)
  end
end
