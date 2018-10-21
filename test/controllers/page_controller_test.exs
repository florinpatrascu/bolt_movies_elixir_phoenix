defmodule MoviesElixirPhoenixWeb.PageControllerTest do
  use MoviesElixirPhoenixWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Neo4j Movies"
  end
end
