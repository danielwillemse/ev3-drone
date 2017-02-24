defmodule Drone do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Ev3.bootstrap!

    # Define workers and child supervisors to be supervised
    children = [
      supervisor(Ev3.DeviceSupervisor, [strategy: :one_for_one])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Drone.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
