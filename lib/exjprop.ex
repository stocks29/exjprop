defmodule Exjprop do
  @moduledoc """
  Exjprop is a library for reading Java properties files.

  It includes the `Exjprop.Properties` protocol and several
  implementations including File, Stream, Function, and S3.

  ## Examples

  ### File Example

      props = Exjprop.Properties.File.new("/path/to/java.properties")
      props = Exjprop.Properties.load

      some_prop = Exjprop.Properties.get_property!(props, "some.prop")

  ### Stream Example

      stream = File.stream!("/path/to/java.properties")
      props = Exjprop.Properties.Stream.new(stream)
      props = Exjprop.Properties.load

      some_prop = Exjprop.Properties.get_property!(props, "some.prop")

  ### Function Example

      fun = fn ->
        File.stream!("/path/to/java.properties")
      end

      props = Exjprop.Properties.Function.new(fun)
      props = Exjprop.Properties.load

      some_prop = Exjprop.Properties.get_property!(props, "some.prop")

  ### S3 Example

      # using access/secret keys from environment or ec2 identity 
      # metadata service
      props = Exjprop.Properties.S3.new("props-bucket", "java.properties")
      props = Exjprop.Properties.load

      some_prop = Exjprop.Properties.get_property!(props, "some.prop") 


      # explicitly specifying access/secret keys
      props = Exjprop.Properties.S3.new(
        "props-bucket", "java.properties", "access", "secret")
      props = Exjprop.Properties.load

      some_prop = Exjprop.Properties.get_property!(props, "some.prop") 
  """
end
