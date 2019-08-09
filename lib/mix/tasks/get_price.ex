defmodule Mix.Tasks.GetPrice do
  use Mix.Task

  @shortdoc "Runs Fyresale.PriceFinder.get_price/2 with url and selector"
  def run([url, selector]) do
    Application.ensure_all_started(:httpoison)
    Fyresale.PriceFinder.get_price(url, selector) |> IO.inspect
  end
end