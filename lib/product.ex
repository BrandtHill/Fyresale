defmodule Fyresale.Product do
  defstruct [
    :name,
    :url,
    :selector, 
    curr_price: 0.0,
    base_price: 0.0, 
    sale_price: 0.0,
    sale_ratio: 0.0
  ]

  def new, do: %__MODULE__{}
  def new(params), do: struct(__MODULE__, params)

  def on_sale?(product) do
    product.curr_price <= product.sale_price or
    product.curr_price <= product.sale_ratio * product.base_price
  end

  def update_price(product, price) do
    %{product | curr_price: price}
  end

end