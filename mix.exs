defmodule AI.Mixfile do
  use Mix.Project

  def project do
    [app: :ai,
     version: "0.0.0",
     elixir: "~> 1.3",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :cowboy, :ranch],
      #mod: {Experiment, []}
      mod: {AI, []}
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
    [
      { :cowboy, github: "ninenines/cowboy", tag: "2.0.0-pre.3" },
      {:ex_doc, "~> 0.12", only: :dev},
      {:jiffy, "~> 0.14.7"}
    ]
  end
end
