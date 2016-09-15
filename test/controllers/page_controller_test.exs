defmodule Beanie.PageControllerTest do
  use Beanie.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert redirected_to(conn) =~ "/repositories"
  end
end
