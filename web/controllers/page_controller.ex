defmodule Beanie.PageController do
  use Beanie.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
