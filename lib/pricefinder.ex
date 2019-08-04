defmodule Fyresale.PriceFinder do
  @moduledoc """
  Functions to grab the price from the web.
  """
  alias Fyresale.{Product, PriceStore}

  def check_price(name) do
    product = name |> PriceStore.get_product
    price = get_price(product.url, product.selector)
    product = product |> Product.update_price(price)
    Product.on_sale?(product)
    name |> PriceStore.set_product(product)
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
