defmodule Mix.Tasks.GetHtml do
  use Mix.Task
  
  @headers [
    {"User-Agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"}
  ]

  @shortdoc "Runs Floki.find/2 on html body from url with selector"
  def run([url, selector]) do
    Application.ensure_all_started(:httpoison)
    with  {:ok, %{body: body}}    <- HTTPoison.get(url, @headers, follow_redirect: true),
          html_node               <- Floki.find(body, selector),
          do: IO.inspect(html_node)
  end
end