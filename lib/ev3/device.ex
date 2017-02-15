defmodule Ev3.Device do
  defmodule InvalidCommandError do
    defexception message: "Invalid command for ev3 device"
  end
end
