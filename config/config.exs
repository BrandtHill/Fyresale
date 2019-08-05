import Config

regexes = [
  ~r|NAME_[0-9]|,
  ~r|URL_[0-9]|,
  ~r|SELECTOR_[0-9]|
]

# Returns a set of indexes from env vars based on a regex in form "<String>_<Int>"
get_index_set = fn regex -> 
  System.get_env
  |> Map.keys
  |> Enum.filter(&Regex.match?(regex, &1))
  |> Enum.map(fn x -> String.split(x, "_") |> List.last |> String.to_integer end)
  |> MapSet.new
end

get_env_at = fn name, index -> System.get_env(name <> "_" <> Integer.to_string(index)) end
get_env_at_def = fn name, index, default -> System.get_env(name <> "_" <> Integer.to_string(index), default) end

# Returns a keyword list for config for Fyresale.Product using env vars ending with _<index>
get_product = fn index -> [
  name: get_env_at.("NAME", index),
  url: get_env_at.("URL", index),
  selector: get_env_at.("SELECTOR", index),
  base_price: get_env_at_def.("BASE_PRICE", index, "0") |> Float.parse |> elem(0),
  sale_price: get_env_at_def.("SALE_PRICE", index, "0") |> Float.parse |> elem(0),
  sale_ratio: get_env_at_def.("SALE_RATIO", index, "0") |> Float.parse |> elem(0)
]
end

# List of indexes that are present in each of required options
indexes = regexes
|> Enum.map(&get_index_set.(&1))
|> Enum.reduce(&MapSet.intersection(&1, &2))
|> Enum.to_list

config :fyresale, :product_names, indexes |> Enum.map(&get_env_at.("NAME", &1))

config :fyresale, :products, indexes |> Enum.map(&get_product.(&1))

config :logger,
  level: :debug


IO.inspect(indexes |> Enum.map(&get_product.(&1)))
IO.inspect(indexes |> Enum.map(&get_env_at.("NAME", &1)))