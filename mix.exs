defmodule AtEx.MixProject do
  use Mix.Project

  def project do
    [
      app: :at_ex,
      version: "0.20.21",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "AtEx",
      source_url: "https://github.com/elixirkenya/africastalking-elixir",
      docs: [
        # The main page in the docs
        main: "readme",
        canonical: "http://hexdocs.pm/at_ex",
        source_url: "https://github.com/beamkenya/africastalking-elixir",
        logo: "assets/logo.jpg",
        assets: "assets",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tesla, "~> 1.2.1"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp description() do
    " This is an elixir wrapper for the Africa’s Talking API
     allowing for the integration with the api to build powerful mobile solutions."
  end

  defp package() do
    [
      # This option is only needed when you don't want to use the OTP application name
      name: "at_ex",
      maintainers: ["Paul Oguda", "Magak Emmanuel", "Zacck Osiemo", "Tracey Onim", "Sigu Magwa"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/elixirkenya/africastalking-elixir"},
      source_url: "https://github.com/elixirkenya/africastalking-elixir",
      homepage_url: "https://github.com/elixirkenya/africastalking-elixir"
    ]
  end
end
