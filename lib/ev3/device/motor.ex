defmodule Ev3.Device.Motor do
  use GenServer

  @device_path "tacho-motor"
  @valid_calls ~w(speed_sp command)a

  defstruct [:device, :type, :path, :status]

  ### API ###

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: String.to_atom(name))
  end

  def report(pid) do
    GenServer.call(pid, :report)
  end

  def execute(pid, command, value) do
    validate_command!(command)
    GenServer.cast(pid, {:execute, command |> Atom.to_string, value})
  end

  def init(path) do
    {:ok, %__MODULE__{path: path}}
  end

  ### Callbacks ###

  def handle_call(:report, _from, motor) do
    motor =
      motor
      |> add_stat(:type)
      |> add_stat(:status)

    {:reply, motor, motor}
  end

  def handle_cast({:execute, command, value}, motor) do
    Ev3.Util.write!(@device_path, motor.path, command, value)
    {:noreply, motor}
  end

  ### Internal API ###

  defp add_stat(motor, :type) do
    type =
      if is_connected?(motor.path) do
        Ev3.Util.read!(@device_path, motor.path, "driver_name")
        |> driver_name_to_type()
      end

    motor |> Map.put(:type, type)
  end

  defp add_stat(motor, :status) do
    status = if is_connected?(motor.path), do: :connected, else: :not_connected

    motor |> Map.put(:status, status)
  end

  defp connected_devices do
    Ev3.Util.ls(@device_path)
  end

  defp is_connected?(name) do
    connected_devices |> Enum.any?(fn(f) -> f == name end)
  end

  defp driver_name_to_type(driver_name) do
    case driver_name do
      "lego-ev3-l-motor" -> :large
      "lego-ev3-m-motor" -> :medium
      _ -> :none
    end
  end

  defp validate_command!(command) do
    if !Enum.any?(@valid_calls, fn(c) -> c == command end) do
      raise Ev3.Device.InvalidCommandError
    end
  end
end
