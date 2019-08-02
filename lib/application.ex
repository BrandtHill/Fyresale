defmodule Fyresale do
  @moduledoc """
  Application entrypoint for Fyresale.
  """

  use Application

  def start(_type, _args) do
    Fyresale.Supervisor.start_link([])
  end
end
