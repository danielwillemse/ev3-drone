defmodule Ev3.Brick do

  @name :brick

  defstruct [:current_now, :voltage_now]

  ### API ###

  def start_link() do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def report do
    GenServer.call(@name, :report)
  end

  def init(_) do
    {:ok, %__MODULE__{} }
  end

  ### Callbacks ###

  def handle_call(:report, _from, brick) do
    {:reply, brick |> with_stats(), brick}
  end

  ### Internal API ###

  defp with_stats(brick) do
    brick
    |> Map.put(:voltage_now, voltage_now())
    |> Map.put(:current_now, current_now())
  end

  defp voltage_now do
    Ev3.Util.read!("power_supply", "legoev3-battery", "voltage_now")
    |> String.to_integer()
  end

  defp current_now do
    Ev3.Util.read!("power_supply", "legoev3-battery", "current_now")
    |> String.to_integer()
  end
end
