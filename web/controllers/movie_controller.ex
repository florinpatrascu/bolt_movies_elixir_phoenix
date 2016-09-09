defmodule MoviesElixirPhoenix.MovieController do
  use MoviesElixirPhoenix.Web, :controller

  alias MoviesElixirPhoenix.Utils
  alias Bolt.Sips, as: Bolt

  def search_by_title(conn, %{"title" => title}) do
    cypher = """
      MATCH (n:Movie {title: \"#{title}\"})
         WITH n MATCH p=(n)-[*0..1]-(m)
         RETURN p
    """

    data = Bolt.query!(Bolt.conn, cypher)
    {nodes, relationships} = data |> Utils.nodes_and_relationships

    render(conn, "search_by_title.json",
        movie: Utils.movie_and_roles(nodes, relationships, title))
  end

  def search_by_title_containing(conn, %{"title" => title}) do
    cypher = """
      MATCH (m:Movie) WHERE m.title =~ (\"(?i).*#{title}.*\")
      RETURN m as movie
    """

    movies=Bolt.query!(Bolt.conn, cypher)
    render(conn, "search_by_title_containing.json", movies: movies)
  end

  def graph(conn, %{"limit" => limit}) do
    cypher = """
      MATCH (m:Movie)<-[:ACTED_IN]-(a:Person)
      RETURN m.title as movie, collect(a.name) as cast
      LIMIT #{limit}
    """

    data = Bolt.query!(Bolt.conn, cypher)
    render(conn, "graph.json", data: Utils.graph(data))
  end

end
