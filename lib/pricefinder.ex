defmodule Fyresale.PriceFinder do
  @moduledoc """
  Module to grab the price from the web.
  Can be supervised and will periodically check prices.
  """
  require Logger

  alias Fyresale.{Product, ProductStore, Mailer}

  @headers [
    {"User-Agent", "Fyresale App (Elixir HTTPoison)"}
  ]

  @currency_regex ~r|[$¢£€¥₿]|

  @loop_period (1000 * 60 * 60)

  def check_price(name) do
    product = name |> ProductStore.get_product
    price = get_price(product.url, product.selector)
    product = product |> Product.update_price(price)
    name |> ProductStore.set_product(product)
    if Product.on_sale?(product) and Product.should_send_sale?(product) do
      email = Mailer.sale_email(name)
      email |> Mailer.deliver_later
      ProductStore.set_product(name, Product.update_sent_to_curr(product))
      Logger.info("#{name} is on sale for $#{price}")
      Logger.debug("Email: #{inspect(email, pretty: true)}")
    end
  end

  def get_price(url, selector) do
    with  {:ok, %{body: body}}    <- HTTPoison.get(url, @headers, follow_redirect: true),
          html_node               <- Floki.find(body, selector),
          text                    <- Floki.text(html_node, sep: " "),
          num_str                 <- String.replace(text, @currency_regex, ""),
          {price, _rest}          <- Float.parse(num_str),
          do: price
  end

  def child_spec(_arg) do
    %{
      id: PriceFinder,
      start: {__MODULE__, :init, [Application.get_env(:fyresale, :product_names)]}
    }
  end

  defp check_price_task(name), do: Task.start(fn -> check_price(name) end)

  def init(names) do
    Logger.debug("PriceFinder init called with #{inspect(names)}")
    send(self(), names)
    loop()
  end

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
