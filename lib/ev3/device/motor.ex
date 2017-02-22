defmodule Ev3.Device.Motor do
  use GenServer

  alias Ev3.Device

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

  def execute(pids, command, value) when is_list(pids) do
    validate_command!(command)
    pids
    |> Enum.each(fn(pid) ->
      do_execute(pid, command, value)
    end)
  end

  def execute(pid, command, value) do
    validate_command!(command)
    do_execute(pid, command, value)
  end

  defp do_execute(pid, command, value) do
    GenServer.cast(pid, {:execute, command |> Atom.to_string, value})
  end

  def init(path) do
    {:ok, %__MODULE__{path: path}}
  end

  ### Callbacks ###

  def handle_call(:report, _from, %{status: :connected} = motor) do
    motor = motor |> add_stat(:type)

    {:reply, motor, motor}
  end

  def handle_call(msg, _from, %{status: :not_connected} = motor) do
    {:reply, motor, motor}
  end

  def handle_call(msg, from, motor) do
    motor = motor |> add_stat(:status)
    handle_call(msg, from, motor)
  end

  def handle_cast({:execute, command, value}, motor) do
    Ev3.Util.write!(@device_path, motor.path, command, value)
    {:noreply, motor}
  end

  ### Internal API ###

  defp add_stat(motor, :type) do
    type =
      if Device.connected?(@device_path, motor.path) do
        Ev3.Util.read!(@device_path, motor.path, "driver_name")
        |> driver_name_to_type()
      end

    motor |> Map.put(:type, type)
  end

  defp add_stat(motor, :status) do
    status = if Device.connected?(@device_path, motor.path), do: :connected, else: :not_connected

    motor |> Map.put(:status, status)
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
      raise Device.InvalidCommandError
    end
  end
end
