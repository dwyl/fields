# fields
https://youtu.be/KLVq0IAzh1A


A collection of commonly used fields implemented as custom Ecto types with the necessary validation, encryption, and/or hashing. 


## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `fields` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:fields, "~> 0.1.2"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/fields](https://hexdocs.pm/fields).

## Usage

Each field can be used in place of an Ecto type when defining your schema.

```
schema "users" do
  field(:email, Fields.EmailEncrypted)
  field(:address, Fields.Address)
  field(:postcode, Fields.Postcode)
  field(:password, Fields.Password)

  timestamps()
end
```

Each field is defined as an [Ecto type](https://hexdocs.pm/ecto/Ecto.Type.html), with the relevant callbacks. So when you call `Ecto.Changeset.cast/4` in your schema's changeset function, the field will be correctly validated. For example, calling cast on the `:email` field will ensure it is a valid format for an email address.

When you load one of the fields into your database, the corresponding `dump/1` callback will be called, ensuring it is inserted into the database in the correct format. In the case of `Fields.EmailEncrypted`, it will encrypt the email address using a give encryption key (set in your config file) before inserting it.

Likewise, when you load a field from the database, the `load/1` callback will be called, giving you the data in the format you need. `Fields.EmailEncrypted` will be decrypted back to plaintext. 

The currently existing fields are:

- [Encrypted](lib/encrypted.ex)
- [Hash](lib/hash.ex)
- [EmailPlaintext](lib/email_plaintext.ex)
- [EmailHash](lib/email_hash.ex)
- [EmailEncrypted](lib/email_encrypted.ex)
- [Password](lib/password.ex)
- [Postcode](lib/postcode.ex)
- [PostcodeEncrypted](lib/postcode_encrypted.ex)

## Config 

If you use any of the `Encrypted` fields, you will need to set a list of one or more encryption keys in your config:

``` elixir
config :fields, Fields.AES,
  keys:
    System.get_env("ENCRYPTION_KEYS")
    # remove single-quotes around key list in .env
    |> String.replace("'", "")
    # split the CSV list of keys
    |> String.split(",")
    # decode the key.
    |> Enum.map(fn key -> :base64.decode(key) end)
```

If you use any of the `Hash` fields, you will need to set a secret key base:

``` elixir
config :fields, Fields,
  secret_key_base: "rVOUu+QTva+VlRJJI3wSYONRoffFQH167DfiZcegvYY/PEasjPLKIDz7wPTvTPIP"
```

## Background / Further Reading


### How to Create a Re-useable Elixir Package and Publish to `hex.pm`
+ https://hex.pm/docs/publish
+ https://medium.com/kkempin/how-to-create-and-publish-hex-pm-package-elixir-90cb33e2592d
+ https://medium.com/blackode/how-to-write-elixir-packages-and-publish-to-hex-pm-8723038ebe76

### How to _Use_ the Package Locally _Before_ Publishing it to `hex.pm`

+ https://stackoverflow.com/questions/28185003/using-a-package-locally-with-hex-pm
