defmodule Exjprop.Mixfile do
  use Mix.Project

  def project do
    [app: :exjprop,
     version: "1.3.0",
     elixir: "~> 1.8",
     name: "exjprop",
     source_url: "https://github.com/stocks29/exjprop",
     homepage_url: "https://github.com/stocks29/exjprop",
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://gthub.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [
      {:ex_aws, "~> 2.1", optional: true},
      {:sweet_xml, "~> 0.6.6", optional: true},
      {:httpoison, "~> 1.5.1", optional: true},
      {:jason, "~> 1.1.2", optional: true},
      {:earmark, "~> 1.3.3", only: :dev},
      {:ex_doc, "~> 0.21.1", only: :dev},
    ]
  end

  defp description do
    """
    Elixir library for reading Java properties files from various sources
    """
  end

  def package do
    [ maintainers: ["Bob Stockdale"],
      licenses: ["MIT License"],
      links: %{
        "GitHub" => "https://github.com/stocks29/exjprop.git",
        "Docs" => "http://hexdocs.pm/exjprop"
        }]
  end
end
