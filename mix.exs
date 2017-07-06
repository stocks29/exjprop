defmodule Exjprop.Mixfile do
  use Mix.Project

  def project do
    [app: :exjprop,
     version: "1.0.0",
     elixir: "~> 1.4",
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
      {:ex_aws, "~> 1.1", optional: true},
      {:sweet_xml, "~> 0.6", optional: true},
      {:httpoison, "~> 0.11", optional: true},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.16.2", only: :dev},
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
