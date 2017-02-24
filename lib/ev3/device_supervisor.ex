defmodule Ev3.DeviceSupervisor do
  use Supervisor

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok)
  end

  def init(:ok) do
    children =
      Enum.map(motors(), fn(motor) ->
        worker(Ev3.Device.Motor, [motor], id: motor)
      end)

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end

  def motors do
    ~w(motor0 motor1 motor2 motor3)
  end
end
