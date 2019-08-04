defmodule Fyresale.PriceStore do
  @moduledoc """
  Maintains state of watched prices  
  """

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: Prices)
  end

  def init(init_data) do
    {:ok, init_data}
  end

  def handle_call({:get_price, name}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_cast({:set_price, name, price}, _from, state) do
    {:no_reply, Map.put(state, name, price)}
  end

  def get_product(name) do
    GenServer.call(Prices, {:get_product, name})
  end

  def set_product(name, price) do
    GenServer.cast(Prices, {:set_product, name, price})
  end
end