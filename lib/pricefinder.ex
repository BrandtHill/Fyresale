defmodule Fyresale.PriceFinder do
  @moduledoc """
  Functions to grab the price from the web.
  """

  def child_spec(_opts) do
    IO.write("Starting PriceFinder")
  end

  def get_price(url, selector) do
    with {:ok, res} <- HTTPoison.get(url)
    do
      [{_, _, [content | _]} | _] = res.body |> Floki.find(selector)
      {price, _} = content |> String.replace("$", "") |> Float.parse
      price
    end
  end
end
