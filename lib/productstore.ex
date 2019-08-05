defmodule Fyresale.ProductStore do
  @moduledoc """
  Maintains state of watched prices  
  """
  require Logger

  use GenServer

  def start_link(_opts) do
    Logger.info("Fyresale.ProductStore process starting")
    GenServer.start_link(__MODULE__, %{}, name: Products)
  end

  def init(init_data) do
    Logger.debug("Fyresale.ProductStore.init/1 called with initial data: #{inspect(init_data)}")
    {:ok, init_data}
  end

  def handle_call({:get_product, name}, _from, state) do
    {:reply, Map.get(state, name), state}
  end

  def handle_cast({:set_product, name, product}, state) do
    {:noreply, Map.put(state, name, product)}
  end

  def get_product(name) do
    product = GenServer.call(Products, {:get_product, name})
    Logger.debug("Fetching #{product.name}: #{inspect(product)}")
    product
  end

  def set_product(name, product) do
    Logger.info("Setting #{name} to #{inspect(product)}")
    GenServer.cast(Products, {:set_product, name, product})
  end
end