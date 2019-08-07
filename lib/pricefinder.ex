defmodule Fyresale.PriceFinder do
  @moduledoc """
  Module to grab the price from the web.
  Can be supervised and will periodically check prices.
  """
  require Logger

  alias Fyresale.{Product, ProductStore}

  @headers [
    {"User-Agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36"}
  ]

  @loop_period (1000 * 60 * 60)

  def check_price(name) do
    product = name |> ProductStore.get_product
    price = get_price(product.url, product.selector)
    product = product |> Product.update_price(price)
    on_sale = Product.on_sale?(product)
    if on_sale, do: Logger.info("#{name} is on sale for $#{price}")
    name |> ProductStore.set_product(product)
  end

  def get_price(url, selector) do
    with {:ok, res} <- HTTPoison.get(url, @headers)
    do
      IO.inspect(Floki.find(res.body, selector))
      res.body
      |> Floki.find(selector)
      |> hd
      |> elem(2)
      |> hd
      |> String.replace("$", "")
      |> Float.parse
      |> elem(0)
    end
  end

  def child_spec(_arg) do
    %{
      id: PriceFinder,
      start: {__MODULE__, :init, [Application.get_env(:fyresale, :product_names)]}
    }
  end

  def init(names) do
    Logger.debug("PriceFinder init called with #{inspect(names)}")
    send(self(), names)
    loop()
  end

  defp check_price_task(name), do: Task.start(fn -> check_price(name) end)

  defp loop do
    receive do
      msg when is_list msg -> 
        Logger.debug("Got this message: #{inspect(msg)}")
        msg |> Enum.each(&check_price_task(&1))
        Process.send_after(self(), msg, @loop_period)
        loop()
    end
  end
end
