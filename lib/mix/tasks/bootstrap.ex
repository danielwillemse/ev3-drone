defmodule Mix.Tasks.Ev3.Bootstrap do
  use Mix.Task

  def run(_) do
    bootstrap_system()
    bootstrap_motors()
    bootstrap_sensors()
  end

  defp bootstrap_system do
    File.mkdir_p("power_supply/legoev3-battery/")
  end

  defp bootstrap_motors do
    (0..3) |> Enum.map(fn(nr) ->
      [Ev3.root_path(), "tacho-motor", "motor" <> Integer.to_string(nr)]
      |> Enum.join("/")
      |> File.mkdir_p()
    end)
  end

  defp bootstrap_sensors do
    (0..3) |> Enum.map(fn(nr) ->
      [Ev3.root_path(), "lego-sensor", "sensor" <> Integer.to_string(nr)]
      |> Enum.join("/")
      |> File.mkdir_p()
    end)
  end

end
