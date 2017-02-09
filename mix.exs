defmodule Drone.Mixfile do
  use Mix.Project

  @target "nerves_system_ev3"

  def project do
    [app: :drone,
     version: "0.1.0",
     target: @target,
     archives: [nerves_bootstrap: "~> 0.2.1"],

     deps_path: "deps/#{@target}",
     build_path: "_build/#{@target}",

     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     deps: deps() ++ system(@target)]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Drone, []},
     applications: [:logger, :logger_file_backend, :nerves_interim_wifi, :ex_ncurses, :runtime_tools]]
  end

  def deps do
    [{:nerves, "~> 0.4", runtime: false},
     {:logger_file_backend, "~> 0.0.8"},
     {:nerves_interim_wifi, "~> 0.0.1"},
     {:ex_ncurses, github: "jfreeze/ex_ncurses", ref: "2fd3ecb1c8a1c5e04ddb496bb8d57f30b619f59e"},
    ]
  end

  def system(_target) do
    [{:nerves_system_ev3, "~> 0.10.1", runtime: false}]
  end

  def aliases do
    ["deps.precompile": ["nerves.precompile", "deps.precompile"],
     "deps.loadpaths":  ["deps.loadpaths", "nerves.loadpaths"]]
  end

end
