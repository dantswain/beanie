defmodule Beanie.PageControllerTest do
  use Beanie.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Beanie"
  end
end
