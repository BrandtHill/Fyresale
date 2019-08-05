import Config

config :fyresale, :products,
  name: System.get_env("NAME"),
  url: System.get_env("URL"),
  selector: System.get_env("SELECTOR"),
  base_price: System.get_env("BASE_PRICE", "0") |> Float.parse |> elem(0),
  sale_price: System.get_env("SALE_PRICE", "0") |> Float.parse |> elem(0),
  sale_ratio: System.get_env("SALE_RATIO", "0") |> Float.parse |> elem(0)

config :logger,
  level: :debug
