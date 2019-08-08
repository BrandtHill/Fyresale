defmodule Fyresale.Mailer do
  use Bamboo.Mailer, otp_app: :fyresale
  
  import Bamboo.Email

  def sale_email(name) do
    product = Fyresale.ProductStore.get_product(name)
    new_email(
      to: get_recipients(),
      from: Application.get_env(:fyresale, Fyresale.Mailer)[:username],
      subject: "Fyresale - #{name} is on sale",
      html_body: "<h3>#{name} is on sale for $#{product.curr_price}</h3><br><a href=\"#{product.url}\">Link to product</a>",
      text_body: "#{name} is on sale for #{product.curr_price}. Link here: #{product.url}"
    )
  end

  defp get_recipients do
    unless Enum.empty?(Application.get_env(:fyresale, :recipients)) do
      Application.get_env(:fyresale, :recipients)
    else
      Application.get_env(:fyresale, Fyresale.Mailer)[:username]
    end
  end
end