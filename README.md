<div align="center">

# Fields

A **collection of frequently used fields** implemented as custom **`Ecto` types** <br />
with 
[validation](https://hexdocs.pm/fields/Fields.Validate.html), 
[sanitising](https://hexdocs.pm/fields/Fields.HtmlBody.html) 
and 
[encryption](https://hexdocs.pm/fields/Fields.AES.html)
/ 
[hashing](https://hexdocs.pm/fields/Fields.Password.html)
to **build `Phoenix` Apps _much_ faster!** 🚀<br />
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
[![HitCount](https://hits.dwyl.com/dwyl/fields.svg)](https://hits.dwyl.com/dwyl/fields)
<!-- uncomment when service is working ...
[![Inline docs](http://inch-ci.org/github/dwyl/fields.svg?branch=master&style=flat-square)](http://inch-ci.org/github/dwyl/fields)
-->

</div>

# _Why_? 🤷

We found ourselves repeating code
for commonly used fields on each new **`Phoenix`** project/App ... <br />
We wanted a **_much_ easier/faster** way of building apps
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

> This package was born out of our research 
> into the best/easiest way to encrypt data in **`Phoenix`**:
> [dwyl/phoenix-ecto-encryption-example](https://github.com/dwyl/phoenix-ecto-encryption-example)

# _Who_? 👥

This module is for people building Elixir/Phoenix apps
who want to ship _simpler_ and more maintainable code.

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
    {:fields, "~> 2.9.0"}
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
export ENCRYPTION_KEYS=nMdayQpR0aoasLaq1g94FLba+A+wB44JLko47sVQXMg=
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

An example for defining a "user" schema using **Fields**:

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
+ [`EmailPlaintext`](lib/email_plaintext.ex) - when an email address is `public`
there's no advantage to encrypting it. e.g. a customer support email.
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
+ [`IpAddressPlaintext`](lib/ip_address_plaintext.ex) - validate an ipv4 and ipv6 address and store as `plaintext`
+ [`IpAddressHash`](lib/ip_address_hash.ex) - hash for ipv4 or ipv6
+ [`IpAddressEncrypted`](lib/ip_address_encrypted.ex) - validate an ipv4 and ipv6 address and store as AES _encrypted_ `Binary`

***Detailed documentation*** available on **HexDocs**:
[hexdocs.pm/**fields**](https://hexdocs.pm/fields)

<br />

## Testing

```sh
mix t
```


### _Coverage_

```
mix c
```

## Contributing ➕

If there is a field that you need in your app
that is not already in the **`Fields`** package,
please open an issue so we can add it!
[github.com/dwyl/fields/issues](https://github.com/dwyl/fields/issues)

<br />


<br />

## Background / Further Reading 🔗

If you want an in-depth understanding of how automatic/transparent
encryption/decryption works using Ecto Types, see:
[github.com/dwyl/**phoenix-ecto-encryption-example**](https://github.com/dwyl/phoenix-ecto-encryption-example)

If you are rusty/new on Binaries in Elixir,
take a look at this post by @blackode: <br />
https://medium.com/blackode/playing-with-elixir-binaries-strings-dd01a40039d5


# Questions?

If you have questions, please open an issue:
[github.com/dwyl/fields/issues](https://github.com/dwyl/fields/issues)

A recent/good example is: [issues/169](https://github.com/dwyl/auth/issues/169)

### Why do we have _both_ `EmailEncrypted` and `EmailHash` ?

[`EmailEncrypted`](https://github.com/dwyl/fields/blob/main/lib/email_encrypted.ex)
and
[`EmailHash`](https://github.com/dwyl/fields/blob/main/lib/email_hash.ex)
serve very different purposes.
Briefly:
with 
[**encryption**](https://en.wikipedia.org/wiki/Encryption)
the output is **_always_ different** 
is meant for safely storing sensitive data
that we want to **_decrypt_** later
whereas with 
[**hash**](https://en.wikipedia.org/wiki/Hash_function)
the output is **_always_ the same**
it cannot be "unhashed" but 
can be used to
[***check***](https://en.wikipedia.org/wiki/Checksum) a value,
i.e. you can lookup a _hashed_ value in a database.

The best way to understand how these work 
is to see it for yourself. 
Start an 
[`IEx`](https://hexdocs.pm/iex/1.1.1/IEx.html) 
session in your terminal:

```sh
iex -S mix
```

You should see output similar to the following:

```sh
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [jit] [dtrace]

Compiling 23 files (.ex)
Generated fields app
Interactive Elixir (1.12.3) - press Ctrl+C to exit (type h() ENTER for help)
```
That confirms the `fields` module has compiled.

#### Encryption

Now that you've initialized `IEx`,
issue the following commands:

```sh
iex> email = "alex@gmail.com"

"alex@gmail.com"

iex(2)> encrypted = Fields.AES.encrypt(email)

<<48, 48, 48, 49, 20, 6, 117, 239, 107, 251, 80, 156, 109, 46, 6, 75, 119, 89,
  72, 163, 156, 243, 60, 6, 17, 166, 130, 239, 93, 222, 65, 186, 185, 78, 77, 2,
  80, 194, 241, 31, 28, 24, 155, 172, 208, 185, 142, 64, 65, 127>>
```

> **Note**: the `Fields.EmailEncrypted` 
uses the `AES.encrypt/1` behind the scenes,
that's why we are using it here directly. 
You could just as easily have written: 
`{:ok, encrypted} = Fields.EmailEncrypted.dump(email)`
this is just a shorthand.

That output `<<48, 48, 48 ... 64, 65, 127>>` is a 
[**bitstring**](https://elixir-lang.org/getting-started/binaries-strings-and-char-lists.html#bitstrings)
which is the sequence of bits in memory.
The encrypted data - usually called 
["ciphertext"](https://en.wikipedia.org/wiki/Ciphertext) - 
is not human readable, that's a feature.
But if you want to _decrypt_ it back to its human-readable form,
simply run:

```
iex(3)> decrypted = Fields.AES.decrypt(encrypted)

"alex@gmail.com"
```

So we know that an encrypted value can be decrypted.
In the case of `EmailEncrypted` this is useful
when we want to send someone an email message.
For security/privacy, 
we want their sensitive personal data to be stored
_encrypted_ in the Database,
but when we need to decrypt it to send them a message,
it's easy enough.

If you run the `Fields.AES.encrypt/1` function 
multiple times in your terminal,
you will _always_ see different output:

```elixir
iex(4)> Fields.AES.encrypt(email)
 <<48, 48, 48, 49, 168, 212, 210, 53, 233, 104, 27, 235, 199, 43, 87, 74, 3, 2,
   211, 114, 187, 229, 157, 182, 37, 34, 209, 37, 66, 160, 30, 126, 238, 180,
   146, 133, 227, 53, 245, 228, 119, 191, 117, 247, 37, 176, 130, 110, ...>>
iex(5)> Fields.AES.encrypt(email)
 <<48, 48, 48, 49, 196, 170, 48, 97, 75, 206, 148, 204, 41, 149, 64, 50, 27, 56,
   112, 19, 53, 108, 86, 153, 154, 53, 53, 97, 232, 133, 97, 88, 214, 254, 40,
   84, 65, 227, 75, 123, 212, 222, 63, 221, 176, 130, 11, 173, ...>>
iex(6)> Fields.AES.encrypt(email)
 <<48, 48, 48, 49, 201, 239, 104, 101, 140, 232, 0, 216, 183, 168, 220, 130, 24,
   236, 205, 220, 239, 112, 112, 168, 86, 235, 84, 115, 108, 116, 16, 234, 184,
   72, 111, 144, 245, 1, 125, 207, 230, 68, 126, 111, 84, 83, 23, 90, ...>>
iex(7)> Fields.AES.encrypt(email)
 <<48, 48, 48, 49, 176, 131, 145, 182, 128, 43, 11, 100, 253, 73, 179, 144, 139,
   45, 211, 156, 155, 117, 119, 59, 152, 148, 45, 36, 95, 141, 35, 242, 182, 51,
   235, 162, 186, 132, 23, 34, 174, 171, 157, 115, 54, 211, 124, 247, ...>>
```

The first 4 bytes `<<48, 48, 48, 49,` are the same 
because we are using the same encryption key.
But the rest is _always_ different. 


#### Hashing

A `hash` function 
can be used to map data of arbitrary size 
to fixed-size values.
i.e. _any_ length of `plaintext` will 
result in the _same_ length `hash` _value_.
A `hash` function is _one-way_,
it cannot be reversed or "un-hashed".
The `hash` _value_ is _always_ the same
for a given string of plaintext.


Try it in `IEx`:

```elixir
iex(1)> email = "alex@gmail.com"
"alex@gmail.com"

iex(2)> Fields.Helpers.hash(:sha256, email)
<<95, 251, 251, 204, 181, 59, 239, 4, 218, 193, 35, 20, 223, 131, 219, 101, 30,
  17, 97, 146, 103, 115, 3, 185, 230, 137, 218, 137, 209, 111, 48, 236>>
iex(3)> Fields.Helpers.hash(:sha256, email)
<<95, 251, 251, 204, 181, 59, 239, 4, 218, 193, 35, 20, 223, 131, 219, 101, 30,
  17, 97, 146, 103, 115, 3, 185, 230, 137, 218, 137, 209, 111, 48, 236>>
iex(4)> Fields.Helpers.hash(:sha256, email)
<<95, 251, 251, 204, 181, 59, 239, 4, 218, 193, 35, 20, 223, 131, 219, 101, 30,
  17, 97, 146, 103, 115, 3, 185, 230, 137, 218, 137, 209, 111, 48, 236>>
```

The hash _value_ is identical for the given input text 
in this case the email address `"alex@gmail.com"`.

If you use the `Fields.EmailHash.dump/1` function,
you will see the same hash value 
(_because the same helper function is invoked_):

```elixir
iex(5)> Fields.EmailHash.dump(email)
{:ok,
 <<95, 251, 251, 204, 181, 59, 239, 4, 218, 193, 35, 20, 223, 131, 219, 101, 30,
   17, 97, 146, 103, 115, 3, 185, 230, 137, 218, 137, 209, 111, 48, 236>>}
iex(6)> Fields.EmailHash.dump(email)
{:ok,
 <<95, 251, 251, 204, 181, 59, 239, 4, 218, 193, 35, 20, 223, 131, 219, 101, 30,
   17, 97, 146, 103, 115, 3, 185, 230, 137, 218, 137, 209, 111, 48, 236>>}
```

When the `EmailHash` is stored in a database
we can lookup an email address by hashing it
and comparing it to the list. 

The best way of _visualizing_ this 
is to convert the hash value (bitstring) 
to `base64` so that it is _human-readable_:


```elixir
iex(1)> email = "alex@gmail.com"
"alex@gmail.com"

iex(2)> Fields.Helpers.hash(:sha256, email) |> :base64.encode
"X/v7zLU77wTawSMU34PbZR4RYZJncwO55onaidFvMOw="

iex(3)> Fields.Helpers.hash(:sha256, email) |> :base64.encode
"X/v7zLU77wTawSMU34PbZR4RYZJncwO55onaidFvMOw="
```

Imagine you have a database table called `people` that has just 3 columns: `id`, `email_hash` and `email_encrypted`


| `id`  | `email_hash`  | `email_encrypted` | 
|:-----:| ------------- | ----------------- |
|   1   | X/v7zLU77wTawSMU34PbZR4RYZJncwO55onaidFvMOw= | MDAwMc57Y1j0nhwOdw7EvNeUVEfYQoAr7aT6oX |
|   2   | +zXMhia/Z2I64nul6pqoDZTVM1q2K21Pby6GtPcm9iE= | MDAwMXnS1uwGN/cZRFkQgArm2Sbj9y+hnUJIS7 |
|   3   | maY4IxoRSOSqm6qyJDrnEN1JQssJRqRGhzwOown4DPU= | MDAwMa4v0FBko++zqfAkfisXOLosQfrDLAdPax |

With this "database" table, 
we can now _lookup_ an email address to find out their `id`:

```elixir
iex(4)> Fields.Helpers.hash(:sha256, "alice@gmail.com") |> :base64.encode
"+zXMhia/Z2I64nul6pqoDZTVM1q2K21Pby6GtPcm9iE="
```

This matches the `email_hash` in the second row of our table,
therefore **Alice's** `id` is `2` in the database.

<!--

[AES.encrypt/1](https://github.com/dwyl/fields/blob/519f2e9da9c6267e9b9b5359370b21a78390d020/lib/aes.ex#L30)
has an 
[Initialization Vector](https://en.wikipedia.org/wiki/Initialization_vector) (**`IV`**)
which is a random set of bytes 
prepended to the data each time it gets encrypted.
This increases the randomness of the **`ciphertext`**
and thus makes it more difficult to `decrypt` 
in the event an attacker accesses the DB.


The `IV` is included in the `bitstring` returned by `AES.encrypt/1`
which could be split and stored separately in a high security system.
We are storing them together for now as we feel that having a unique key 
stored in a Key Management System (KMS) is adequate for our needs.



### How does 

-->