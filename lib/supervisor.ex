defmodule Fyresale.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Fyresale.ProductStore,
      Fyresale.PriceFinder
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end

end