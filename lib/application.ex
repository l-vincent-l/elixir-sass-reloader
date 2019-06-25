defmodule ElixirSassReloader.Application do
  use Application
  require Logger

  def start(_type, _args) do
    children = [
      ElixirSassReloader
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
