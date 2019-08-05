defmodule Fyresale.PriceFinder do
  @moduledoc """
  Functions to grab the price from the web.
  """
  require Logger

  alias Fyresale.{Product, ProductStore}

  def check_price(name) do
    product = name |> ProductStore.get_product
    price = get_price(product.url, product.selector)
    product = product |> Product.update_price(price)
    on_sale = Product.on_sale?(product)
    if on_sale, do: Logger.info("#{name} is on sale for $#{price}")
    name |> ProductStore.set_product(product)
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
