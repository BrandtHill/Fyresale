defmodule Fyresale.Mailer do
  use Bamboo.Mailer, otp_app: :fyresale
  
  import Bamboo.Email

  def sale_email(name) do
    product = Fyresale.ProductStore.get_product(name)
    new_email(
      to: Application.get_env(:fyresale, Fyresale.Mailer)[:username],
      from: Application.get_env(:fyresale, Fyresale.Mailer)[:username],
      subject: "Fyresale - #{name} is on sale",
      html_body: "<h3>#{name} is on sale for <b>$#{product.curr_price}</b></h3><a href=\"#{product.url}\">Link to product</a>",
      text_body: "#{name} is on sale for #{product.curr_price}. Link here: #{product.url}"
    )
  end
end