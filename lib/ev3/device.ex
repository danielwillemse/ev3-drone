defmodule Ev3.Device do
  defmodule InvalidCommandError do
    defexception message: "Invalid command for ev3 device"
  end

  def connected_devices(type) do
    Ev3.Util.ls(type)
  end

  def connected?(type, name) do
    connected_devices(type)
    |> Enum.any?(fn(f) -> f == name end)
  end
end
