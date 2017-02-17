defmodule Ev3.BrickTest do
  use ExUnit.Case

  alias Ev3.Brick

  test "it reads battery status" do
    Ev3.Util.write!("power_supply", "legoev3-battery", "voltage_now", "123")
    Ev3.Util.write!("power_supply", "legoev3-battery", "current_now", "456")

    {:ok, _pid} = Brick.start_link()

    assert %Brick{current_now: 456, voltage_now: 123} = Brick.report()
  end
end
