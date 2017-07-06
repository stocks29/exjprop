Exjprop
=======

[![Build Status](https://travis-ci.org/stocks29/exjprop.svg?branch=master)](https://travis-ci.org/stocks29/exjprop)

Exjprop is a library for reading Java properties files from various sources.

Implementations are provided for File, Stream, Function (which returns a stream), and Amazon S3.

API documentation is available at http://hexdocs.pm/exjprop

### Add as dependency

```elixir
{:exjprop, "~> 1.0.0"}
```

### Load application properties at runtime

First, define a property loader module

```elixir
defmodule MyApp.PropLoader do
  use Exjprop.Loader
  import Exjprop.Validators, only: [required: 1]

  property "endpoint.secret", {:my_app, MyApp.Endpoint, :secret_key_base}

  property "foo.bar", {:my_app, MyApp.Foo, :bar}, secret: false, pipeline: [&required/1]
  property "foo.quux", {:my_app, MyApp.Foo, :quux}, secret: false, pipeline: [&required/1, &integer/1]
end
```

Next, when your application starts, have it read in your properties and update
your application environment

```elixir
defmodule MyApp do
  use Application
  import Supervisor.Spec
  alias MyApp.PropLoader

  def start(_type, _args) do
    PropLoader.load_and_update_env({:system, "MYAPP_PROPS_FILE"})
    ...
```

This configuration will cause the prop loader to read the `MYAPP_PROPS_FILE`
environment var, and attempt to use that as a uri for loading a properties file.
The uri should either `file:///path/to/file.properties` or
`s3:///myapp_bucket/path/to/s3/file.properties`.

### Using S3 URLs

To enable support for retrieving property files from S3, a few additional dependencies are required.

```
    {:ex_aws, "~> 1.0"},
    {:sweet_xml, "~> 0.6"},
```

ExAws also needs an HTTP client - it defaults to Hackney, but can be modified (see https://hexdocs.pm/ex_aws/ExAws.Request.HttpClient.html)
