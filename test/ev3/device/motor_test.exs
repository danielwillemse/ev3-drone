defmodule Ev3.Device.MotorTest do
  use ExUnit.Case

  alias Ev3.Device.Motor

  test "it starts a worker for a given motor" do
    Ev3.Util.write!("tacho-motor", "motor0", "driver_name", "lego-ev3-l-motor\n")
    {:ok, _pid} = Motor.start_link("motor0")

    assert %{type: :large} = Motor.report(:motor0)
  end
end
