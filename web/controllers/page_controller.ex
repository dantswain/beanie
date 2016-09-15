defmodule Beanie.PageController do
  use Beanie.Web, :controller

  def index(conn, _params) do
    redirect conn, to: "/repositories"
  end
end
