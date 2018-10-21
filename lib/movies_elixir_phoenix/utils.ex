defmodule MoviesElixirPhoenix.Utils do
  def movie_and_roles(nodes, relationships, title) do
    movie = List.first(nodes |> Enum.filter(&(Map.has_key?(&1, :title) && &1.title == title)))
    roles = Enum.filter(relationships, &(&1.end == movie.id))
    persons = Enum.map(roles, &Map.merge(List.first(find_person_by_id(nodes, &1.start)), &1))

    Map.merge(movie, %{crew: persons})
  end

  def nodes_and_relationships(graph) do
    nodes = Enum.map(graph, &parse_nodes(&1)) |> Enum.filter(&(&1 != nil))
    rels = Enum.map(graph, &parse_relationships(&1)) |> Enum.filter(&(&1 != nil && &1 != []))
    # todo: refactor me
    {List.flatten(nodes), List.flatten(rels)}
  end

  def graph(data) do
    nodes = artists_and_movies(data)

    links =
      data
      |> Enum.map(fn %{"cast" => cast, "movie" => movie} ->
        Enum.map(cast, &{&1, movie})
      end)
      |> List.flatten()
      |> Enum.map(fn {a, m} ->
        {Enum.find_index(nodes, &(%{artist: a} == &1)),
         Enum.find_index(nodes, &(%{movie: m} == &1))}
      end)

    %{links: links, nodes: nodes}
  end

  # private stuff, playground mostly
  # ================================
  #

  defp artists_or_movie(data, node_type) do
    case node_type do
      "cast" -> data |> Enum.map(fn %{"cast" => node} -> Enum.map(node, &%{artist: &1}) end)
      "movie" -> data |> Enum.map(fn %{"movie" => node} -> node end) |> Enum.map(&%{movie: &1})
    end
    |> List.flatten()
    |> Enum.uniq()
  end

  defp artists_and_movies(data) do
    artists_or_movie(data, "cast") ++ artists_or_movie(data, "movie")
  end

  defp parse_nodes(graph) do
    graph["p"].nodes
    |> Enum.map(fn n ->
      model = %{id: n.id, labels: n.labels}
      func = &Map.merge(model, &1)

      n.properties
      |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
      |> Enum.into(%{})
      |> func.()
    end)
  end

  defp parse_relationships(graph) do
    extract_rel(Bolt.Sips.Types.Path.graph(graph["p"]))
  end

  defp extract_rel([]), do: []
  defp extract_rel(g) when length(g) < 3, do: []
  defp extract_rel([_n1, rel, _n2]), do: rel

  defp find_person_by_id(nodes, id) do
    nodes
    |> Enum.map(
      &if &1.id == id do
        %{id: &1.id, name: &1.name}
      end
    )
    |> Enum.filter(&(&1 != nil))
    |> List.flatten()
  end
end
