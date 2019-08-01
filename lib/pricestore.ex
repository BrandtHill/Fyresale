defmodule PriceStore do
  @moduledoc """
  Maintains state of watched prices  
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(init_data) do
    {:ok, init_data}
  end

  def get_price(pid) do
    GenServer.call(pid, :get_price)
  end

  def set_price(pid, price) do
    GenServer.call(pid, {:set_price, price})
  end

  def handle_call(:get_price, _from, state) do
    {:reply, Map.get(state, :eft), state}
  end

  def handle_call({:set_price, price}, _from, state) do
    new_state = Map.put(state, :eft, price)
    {:reply, new_state, new_state}
  end

end