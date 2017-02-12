defmodule Mix.Tasks.Ev3.Bootstrap do
  use Mix.Task

  def run(_) do
    (0..3) |> Enum.map(fn(nr) ->
      [Ev3.root_path(), "tacho-motor", "motor" <> Integer.to_string(nr)]
      |> Enum.join("/")
      |> File.mkdir_p()
    end)

    (0..3) |> Enum.map(fn(nr) ->
      [Ev3.root_path(), "lego-sensor", "sensor" <> Integer.to_string(nr)]
      |> Enum.join("/")
      |> File.mkdir_p()
    end)
  end
end
