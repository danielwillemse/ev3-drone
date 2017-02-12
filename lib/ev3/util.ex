defmodule Ev3.Util do

  def read!(device, name, stat) do
    [device, name, stat]
    |> extend_path()
    |> do_read()
  end

  defp do_read(path) do
    path
    |> File.read!()
    |> String.split("\n")
    |> hd()
  end

  def write!(device, name, command, value) do
    [device, name, command]
    |> extend_path()
    |> do_write(value)
  end

  def do_write(path, value) do
    File.write!(path, value)
  end

  defp extend_path(path) do
    [Ev3.root_path() | path] |> Enum.join("/")
  end

end
