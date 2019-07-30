defmodule Fyresale do
  @moduledoc """
  Documentation for Fyresale.
  """

  def get_price(url, selector) do
    with {:ok, res} <- HTTPoison.get(url)
    do
      [{_, _, [content | _]} | _] = res.body |> Floki.find(selector)
      {price, _} = content |> String.replace("$", "") |> Float.parse
      price
    end
  end
end
