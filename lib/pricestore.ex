defmodule Fyresale.PriceStore do
  @moduledoc """
  Maintains state of watched prices  
  """

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(init_data) do
    {:ok, init_data}
  end

  def get_price(pid) do
    GenServer.call(pid, :get_price)
  end

  def set_price(pid, price) do
    GenServer.cast(pid, {:set_price, price})
  end

  def handle_call({:get_price, key}, _from, state) do
    {:reply, Map.get(state, key), state}
  end

  def handle_cast({:set_price, key, price}, _from, state) do
    {:no_reply, Map.put(state, key, price)}
  end

end