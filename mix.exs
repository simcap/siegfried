defmodule Siegfried.Mixfile do
  use Mix.Project

  def project do
    [app: :siegfried,
     version: "0.0.1",
     elixir: "~> 1.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :runtime_tools, :cowboy, :gproc],
      mod: {Siegfried, []}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [ {:cowboy, "1.0.4"}, { :exrm, "~> 0.14.2" }, { :gproc, "~> 0.5"} ]
  end
end
