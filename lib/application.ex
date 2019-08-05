defmodule Fyresale do
  @moduledoc """
  Application entrypoint for Fyresale.
  """

  use Application

  alias Fyresale.{Product, ProductStore, PriceFinder}

  def start(_type, _args) do
    sup = Fyresale.Supervisor.start_link([])
    product = Application.get_env(:fyresale, :products) |> Product.new
    ProductStore.set_product(product.name, product)
    product.name |> PriceFinder.check_price
    sup
  end
end
