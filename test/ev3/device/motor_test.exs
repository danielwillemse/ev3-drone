defmodule Ev3.Device.MotorTest do
  use ExUnit.Case

  alias Ev3.Device.Motor

  test "it starts a worker for a given motor" do
    Ev3.Util.write!("tacho-motor", "motor0", "driver_name", "lego-ev3-l-motor\n")
    {:ok, _pid} = Motor.start_link("motor0")

    assert %{type: :large} = Motor.report(:motor0)
  end

  test "it writes a command" do
    {:ok, _pid} = Motor.start_link("motor0")

    Motor.execute(:motor0, :speed_sp, "500")

    :timer.sleep 10
    assert "500" = Ev3.Util.read!("tacho-motor", "motor0", "speed_sp")
  end

  test "it only writes a valid command" do
    {:ok, _pid} = Motor.start_link("motor0")

    assert_raise Ev3.Device.InvalidCommandError, fn ->
      Motor.execute(:motor0, :exit, "now")
    end
  end

  test "it writes the command for all given motors" do
    {:ok, _pid} = Motor.start_link("motor0")
    {:ok, _pid} = Motor.start_link("motor1")

    Motor.execute([:motor0, :motor1], :speed_sp, "500")

    :timer.sleep 10
    assert "500" = Ev3.Util.read!("tacho-motor", "motor0", "speed_sp")
    assert "500" = Ev3.Util.read!("tacho-motor", "motor1", "speed_sp")
  end

  test "it does not write commands to motors that are connected" do
    Ev3.Util.write!("tacho-motor", "motor0", "speed_sp", "nothing written")
    Motor.execute(:motor0, :speed_sp, "500")

    assert "nothing written" = Ev3.Util.read!("tacho-motor", "motor0", "speed_sp")
  end

  test "it polls the status of the motor" do
    {:ok, _pid} = Motor.start_link("motor0")

    assert %{status: :connected} = Motor.report(:motor0)
  end

  test "it returns not_connected if motor is not found" do
    {:ok, _pid} = Motor.start_link("motor99")

    assert %{status: :not_connected} = Motor.report(:motor99)
  end
end
