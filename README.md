<div align="center">

# Fields

A collection of commonly used fields implemented as custom Ecto types
with the validation, sanitising and encryption/hashing. <br />
<!--
TODO: update intro copy once we ship better docs!
Ship your Phoenix App _much_ faster by using well-documented fields
with built-in validation, testing, sanitising and encryption.
See below for examples!
-->

[![Build Status](https://img.shields.io/travis/dwyl/fields/master.svg?style=flat-square)](https://travis-ci.org/dwyl/fields)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/fields/master.svg?style=flat-square)](http://codecov.io/github/dwyl/fields?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/fields?color=brightgreen&style=flat-square)](https://hex.pm/packages/fields)
[![docs](https://img.shields.io/badge/docs-maintained-brightgreen?style=flat-square)](https://hexdocs.pm/fields/api-reference.html)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/fields/issues)
[![HitCount](http://hits.dwyl.io/dwyl/fields.svg)](http://hits.dwyl.io/dwyl/fields)
<!-- uncomment when service is working ...
[![Inline docs](http://inch-ci.org/github/dwyl/fields.svg?branch=master&style=flat-square)](http://inch-ci.org/github/dwyl/fields)
-->

</div>

# _Why_? 🤷

We found ourselves repeating code
for commonly used fields on each new Phoenix project/App.  
We wanted a _much_ easier/faster way of building apps
so we created a collection of pre-defined fields
with built-in validation, sanitising and security.
**`Fields`** makes defining Ecto Schemas faster
and more precise.


# _What_? 💭

An Elixir package that helps you add popular custom types
to your Phoenix/Ecto schemas so you can build apps faster!

> **@dwyl** we are firm believers that personal data
(_Personally Identifiable Information_ (PII)) should be encrypted "at rest"
i.e. all "user" data should be encrypted _before_ being stored in the database.
This project makes hashing, encryption and _decryption_ for secure data storage
_much_ easier for everyone.

# _Who_? 👥

This module is for people building Elixir/Phoenix apps
who want to ship _simpler_ more maintainable code.

> We've attempted to make **`Fields`**
as **beginner-friendly** as possible. <br />
If you get stuck using it or anything is unclear, please ask for
[help!](https://github.com/dwyl/fields/issues)

# _How_? ✅

Start using **`Fields`** in your Phoenix App today with these 3 easy steps:


## 1. Add the `fields` hex package to `deps` in `mix.exs` 📦

Add the `fields` package to your list of dependencies in your `mix.exs` file:

```elixir
def deps do
  [
    {:fields, "~> 2.1.0"}
  ]
end
```

Once you have saved the `mix.exs` file,
run **`mix deps.get`** in your terminal to download.


## 2. Ensure you have the necessary environment variables 🔑

In order to use Encryption and Hashing,
you will need to have environment variables
defined for `ENCRYPTION_KEYS` and `SECRET_KEY_BASE` respectively.

```yaml
export ENCRYPTION_KEYS='nMdayQpR0aoasLaq1g94FLba=,L+ZVX8iheoqgqb22mUpATmMDsvVGtafoAeb='
export SECRET_KEY_BASE=GLH2S6EU0eZt+GSEmb5wEtonWO847hsQ9fck0APr4VgXEdp9EKfni2WO61z0DMOF
```

If you need to create a secure `SECRET_KEY_BASE` value, please see:
[How to create Phoenix `secret_key_base`](https://github.com/dwyl/phoenix-ecto-encryption-example#generate-the-secret_key_base) <br />
And for `ENCRYPTION_KEYS`, see:
[How to create encryption keys](https://github.com/dwyl/phoenix-ecto-encryption-example#how-to-generate-aes-encryption-keys)


> In our case we use a **`.env`** file
to manage our environment variables.
See:
[github.com/dwyl/**learn-environment-variables**](https://git.io/JeMLg) <br />
This allows us to securely manage our secret keys in dev
without the risk of accidentally publishing them on Github. <br />
When we _deploy_ our Apps, we use our service provider's
built-in key management service to securely store Environment Variables.
e.g:
[Environment Variables on Heroku](https://github.com/dwyl/learn-environment-variables#environment-variables-on-heroku)


## 3. Apply the relevant field(s) to your schema 📝

Each field can be used in place of an Ecto type when defining your schema.

An example fo defining a "user" schema using **Fields**:

```elixir
schema "users" do
  field :first_name, Fields.Name            # Length validated and encrypted
  field :email, Fields.EmailEncrypted       # Validates email then encrypts
  field :address, Fields.AddressEncrypted   # Trims address string then encrypts
  field :postcode, Fields.PostcodeEncrypted # Validates postcode then encrypts
  field :password, Fields.Password          # Hash password with argon2

  timestamps()
end
```

Each field is defined as an
[Ecto type](https://hexdocs.pm/ecto/Ecto.Type.html),
with the relevant callbacks.
So when you call `Ecto.Changeset.cast/4`
in your schema's changeset function,
the field will be correctly validated.
For example, calling cast on the `:email` field
will ensure it is a valid format for an email address
[RFC 5322](https://en.wikipedia.org/wiki/Email_address).

When you load one of the fields into your database,
the corresponding `dump/1` callback will be called,
ensuring it is inserted into the database in the correct format.
In the case of `Fields.EmailEncrypted`,
it will encrypt the email address
using a given encryption key
before inserting it.

Likewise, when you load a field from the database,
the `load/1` callback will be called,
giving you the data in the format you need.
`Fields.EmailEncrypted` will be decrypted back to plaintext.
This all happens 100% transparently to the developer.
It's _like_ magic. But the kind where you can
actually _understand_ how it works!
(_if you're curious, read the
[**`code`**](https://github.com/dwyl/fields/tree/master/lib)_)

Each Field optionally defines an `input_type/0` function.
This will return an atom
representing the `Phoenix.HTML.Form` input type to use for the Field.
For example: `Fields.DescriptionPlaintextUnlimited.input_type`
returns `:textarea` which helps us render the correct field in a form.

The fields `DescriptionPlaintextUnlimited`
and `HtmlBody` uses
[`html_sanitize_ex`](https://github.com/rrrene/html_sanitize_ex)
to remove scripts and help keep your project safe.
`HtmlBody` is able to display basic html elements
whilst `DescriptionPlaintextUnlimited` displays text.
Remember to use `raw` when rendering
the content of your `DescriptionPlaintextUnlimited`
and `HtmlBody` fields
so that symbols such as & (ampersand) and Html are rendered correctly.
e.g:
`<p><%= raw @product.description %></p>`

## Available `Fields` 📖

+ [`Address`](lib/address.ex) - an address for a physical location.
Validated and stored as a (`plaintext`) `String`.
+ [`AddressEncrypted`](lib/address_encrypted.ex) - an address for a customer
or user which should be stored encrypted for data protection.
+ [`DescriptionPlaintextUnlimited`](lib/description_plaintext_unlimited.ex) -
filters any HTML/JS to avoid security issues. Perfect for blog post comments.
+ [`Encrypted`](lib/encrypted.ex) - a general purpose encrypted field.
  converts any type of data `to_string` and then encrypts it.
+ [`EmailEncrypted`](lib/email_encrypted.ex) - validate and strongly encrypt
email address to ensure they are kept private and secure.
+ [`EmailHash`](lib/email_hash.ex) - when an email needs to be looked up fast
without decrypting. Salted and hashed with `:sha256`.
+ [`EmailPlaintext`](lib/email_plaintext.ex) - useful on the rare occasion when
it is acceptable to store an email in `plaintext` e.g. your local pizzeria.
+ [`Hash`](lib/hash.ex) - a general-purpose hash field using `:sha256`,
useful if you need to store the hash of a value. (_one way_)
+ [`HtmlBody`](lib/html-body.ex) - useful for storing HTML data e.g in a CMS.
+ [`Name`](lib/html-body.ex) - used for personal names
that need to be kept private/secure. Max length 35 characters. AES Encrypted.
+ [`Password`](lib/password.ex) - passwords hashed using `argon2`.
+ [`PhoneNumberEncrypted`](lib/phone_number_encrypted.ex) - a phone number that should be kept private gets validated and encrypted.
+ [`PhoneNumber`](lib/phone_number.ex) - when a phone number is _not_
sensitive information and can be stored in plaintext.
+ [`Postcode`](lib/postcode.ex) - validated postcode stored as `plaintext`.
+ [`PostcodeEncrypted`](lib/postcode_encrypted.ex) - validated and encrypted.
+ [`Url`](lib/url.ex) - validate a URL and store as `plaintext`
(_not encrypted_) `String`
+ [`UrlEncrypted`](lib/url_encrypted.ex) - validate a URL and store as AES _encrypted_ `Binary`

***Detailed documentation*** available on **HexDocs**:
[hexdocs.pm/**fields**](https://hexdocs.pm/fields)

<br />

## Contributing ➕

If there is a field that you need in your app
that is not already in the **`Fields`** package,
please open an issue so we can add it!
[github.com/dwyl/fields/issues](https://github.com/dwyl/fields/issues)

<br />

## Background / Further Reading 🔗

If you want an in-depth understanding of how automatic/transparent
encryption/decryption works using Ecto Types, <br />see:
[github.com/dwyl/**phoenix-ecto-encryption-example**](https://github.com/dwyl/phoenix-ecto-encryption-example)

If you are rusty/new on Binaries in Elixir,
take a look at this post by @blackode: <br />
https://medium.com/blackode/playing-with-elixir-binaries-strings-dd01a40039d5
