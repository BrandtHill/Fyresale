# Fyresale

Fyresale is a tool that tracks prices of items you're trying to snag for a good deal.
Given a URL for a product and a css selector, Fyresale will periodically check prices,
and, when they go on sale, send email notifications.

## Running

With elixir installed and this repo cloned, do the following:

* Run ```mix deps.get```
* Run ```mix compile```
* Copy ```example.env``` to ```.env``` and edit accordingly
* Run ```source .env``` to set environment
* Run ```iex -S mix``` to run Fyresale in foreground

## How It Works

The prices of products will be checked every hour. If they're on sale, an email notification will be sent
with the price of the item and a link to the page. Because no one wants to receive an email every hour something
is on sale, additional emails will only be sent if the price drops *even lower* or if the price eventually returns to
or exceeds the configured base price then goes on sale again.

The product is determined to be on sale if either the price is at or below an exact "sale price" or the price
is at or below a percentage of the base price. The default "sale ratio" is 0.9, so you'll get notified if the
price is <= 90% of the base. If you want to be notified of even the smallest change, consider setting that 
value to 0.99. If you set the sale ratio to >= 1 or the sale price to >= the base price, you'll get spammed
every hour, so don't do that.

To get the CSS selector of an item's price, do the following in Chrome (other browsers may work similarly):
* Go to the web page it's being sold at
* Right click the raw text of the price
* Click ```Inspect``` in the resulting menu, exposing the HTML in the dev console
* Right click the highlighted element in the dev console
* Click ```Copy > Copy selector```
* You now have the selector for the price. The selector for products on Amazon is usually ```#priceblock_ourprice```.

The CSS selector should ideally match only the text node of the price, but it will work so long as the first 
(deep) text field of the resulting html node can be parsed as a float after having any currency symbols removed.

## Testing Selectors

There are two custom mix tasks that both allow for testing and evaluation of css selectors.
You'll need to run ```mix deps.compile``` before using the tasks

* ```mix get_html "{URL}" "{SELECTOR}"```   - Runs ```Floki.find/2``` on html body from url with selector
* ```mix get_price "{URL}" "{SELECTOR}"```  - Runs ```Fyresale.PriceFinder.get_price/2``` with url and selector

## Configuration

Looking at ```example.env``` should explain most of what you need, but I'll explain
all of the variables here:

| Variable Name        | Default        | Explanation                                                     |
|----------------------|----------------|-----------------------------------------------------------------|
| NAME_{integer}       |                | Readable name of product                                        |
| URL_{integer}        |                | URL of product html page                                        |
| SELECTOR_{integer}   |                | CSS Selector of price text                                      |
| BASE_PRICE_{integer} | *0.0           | Base price of product *Gets set on first pass if not defined    |
| SALE_PRICE_{integer} | 0.0            | Product "on sale" if at or below this price                     |
| SALE_RATIO_{integer} | 0.9            | Product "on sale" if at or below this percentage of base price  |
| EMAIL_SERV           | smtp.gmail.com | SMTP server to connect to                                       |
| EMAIL_HOST           | gmail.com      | Hostname of email server                                        |
| EMAIL_PORT           | 587            | SMTP port of email server                                       |
| EMAIL_USER           |                | Email address signing in as                                     |
| EMAIL_PASS           |                | Password corresponding to EMAIL_USER                            |
| EMAIL_DEST           | ${EMAIL_USER}  | Email recipient(s). Separate multiples by space/comma/semicolon |

When configuring products to watch, you must define NAME, URL, and SELECTOR for each index. The order of the indexes doesn't matter,
as the indexes serve only to match all of the product's identifiers and optional price parameters.

Example: Say I have defined the following variables
* NAME_0, NAME_1, NAME_2, NAME_79
* URL_400, URL_1, URL_2, URL_79
* SELECTOR_911, SELECTOR_79, SELECTOR_2

We only have all the requisite parameters for products of indexes 2 and 79, so all others would get ignored.

Fyresale use SMTP for emailing because it's trivial to use a regular gmail account. It can easily be changed to use
an email service like Mailgun, Mandrill, or SendGrid, but I didn't want to have to sign up for a bunch of enterprise
email services. If you're using gmail, make sure to "allow less secure apps" for the account you're trying to send from.

## Dependencies

The dependencies are defined in ```mix.exs``` as follows:
```elixir
defp deps do
  [
    {:httpoison, "~> 1.5.1"},
    {:floki, "~> 0.21.0"},
    {:bamboo_smtp, "~> 1.7.0"}
  ]
end
```

A little explanation of what they're used in Fyresale for:

| Package            | Purpose                                                                          |
|--------------------|----------------------------------------------------------------------------------|
| HTTPoison          | HTTP client used for querying the products' web pages                            |
| Floki              | HTML parser used for grabbing the price from the products' HTML docs             |
| Bamboo.SMTPAdapter | SMTP adapter for Bamboo to allow sending emails without needing an email service |

## Installation

This section was auto generated by Mix, but if I ever put Fyresale in HexPM, there's no reason why you couldn't use it in a larger application.

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fyresale` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fyresale, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fyresale](https://hexdocs.pm/fyresale).

