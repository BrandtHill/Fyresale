defmodule Mix.Tasks.GetHtml do
  use Mix.Task
  
  @headers [
    {"User-Agent", "Fyresale App (Elixir HTTPoison)"}
  ]

  @shortdoc "Runs Floki.find/2 on html body from url with selector"
  def run([url, selector]) do
    Application.ensure_all_started(:httpoison)
    with  {:ok, %{body: body}}    <- HTTPoison.get(url, @headers, follow_redirect: true),
          html_node               <- Floki.find(body, selector),
          do: IO.inspect(html_node)
  end
end
