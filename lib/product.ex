defmodule Fyresale.Product do
  defstruct [
    :name,
    :url,
    :selector, 
    curr_price: 0.0,
    base_price: 0.0, 
    sale_price: 0.0,
    sale_ratio: 0.9,
    sent_price: 0.0
  ]

  require Logger

  def new, do: %__MODULE__{}
  def new(params), do: struct(__MODULE__, params)

  @doc "Returns true if product is on sale at current price"
  def on_sale?(product) do
    product.curr_price <= product.sale_price or
    product.curr_price <= product.sale_ratio * product.base_price
  end

  @doc """
  Given an on-sale product, returns true if we should send notification. Notifications
  should only be sent if we haven't already sent them for the given sale price. If
  sent price is 0, it means we haven't notified since the last time the product's price
  has been at its base price.
  """
  def should_send_sale?(product) do
    product.sent_price == 0.0 or product.curr_price <= product.sent_price
  end

  @doc """
  Update product with current price. Error will be raised if price is not a number.
  If product's base price is zero (not configured), it will be set to current price.
  If the current price is equal to (or greater than) the base price, it will set the 
  sent price to 0, which indicates we should send a notification next time the product
  is on sale.
  """
  def update_price(product, price) do
    Logger.debug("Updating price for #{product.name}: $#{price}")
    unless is_number(price), do: raise ArgumentError, message: "Price was not a number"
    base_price = if product.base_price == 0, do: price, else: product.base_price
    sent_price = if price >= base_price, do: 0.0, else: product.sent_price
    %{product | curr_price: price, base_price: base_price, sent_price: sent_price}
  end

  @doc "Updates product's sent price to current price"
  def update_sent_to_curr(product) do
    %{product | sent_price: product.curr_price}
  end

end