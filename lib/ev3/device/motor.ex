defmodule Ev3.Device.Motor do
  use GenServer

  @device_path "tacho-motor"

  defstruct [:device, :type, :path]

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def report(pid) do
    GenServer.call(pid, :report)
  end

  def init(path) do
    {:ok, %__MODULE__{path: path}}
  end

  def handle_call(:report, _from, motor) do
    motor =
      motor
      |> add_stat(:type)

    {:reply, motor, motor}
  end

  defp add_stat(motor, :type) do
    type =
       Ev3.Util.read!(@device_path, motor.path, "driver_name")
      |> driver_name_to_type()

    %{motor | type: type}
  end

  defp driver_name_to_type(driver_name) do
    case driver_name do
      "lego-ev3-l-motor" -> :large
      "lego-ev3-m-motor" -> :medium
      _ -> :none
    end
  end
end
