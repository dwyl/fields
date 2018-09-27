use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :fields, TestFieldsWeb.Endpoint,
  http: [port: 4001],
  secret_key_base: "oU0T594I8GLngy1g5Bu6g3xBXwRFEMo5NFO4EbPPxo0gV4IAXIKWmOiM2gW/yiBp",
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
