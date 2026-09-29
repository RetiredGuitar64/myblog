class Htmx::Search < BrowserAction
  param q : String?
  param scope : String?

  get "/htmx/search" do
    return head 400 unless scope == "docs"

    query = q.to_s.strip

    if query.bytesize < 4
      return component(
        ::Search::Results,
        matches: [] of NamedTuple(title: String, url: String, snippet: String),
        query: query,
        too_short: !query.empty?,
        current_user: current_user
      )
    end

    DocNavigation.load
    pages_by_path = DocNavigation.pages_by_path

    # Generate snippets only for the limited result set.
    sql = <<-SQL
        WITH matches AS MATERIALIZED (
          SELECT path_index, content, pgroonga_score(tableoid, ctid) AS score
          FROM docs
          WHERE content &@~ pgroonga_query_escape($1::text)
          ORDER BY score DESC, path_index
          LIMIT 20
        )
        SELECT path_index,
               COALESCE((pgroonga_snippet_html(content, pgroonga_query_extract_keywords(pgroonga_query_escape($1::text)), 120))[1], '')
        FROM matches
        ORDER BY score DESC, path_index
      SQL

    matches = AppDatabase.query_all(sql, query) do |rs|
      path, snippet = rs.read(String, String)

      {
        title:   pages_by_path[path]?.try(&.title) || path.split('/').last,
        url:     path,
        snippet: snippet,
      }
    end

    component(
      ::Search::Results,
      matches: matches,
      query: query,
      current_user: current_user
    )
  end
end
