defmodule Fields.TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      setup do
        System.put_env("ENCRYPTION_KEYS", generate_keys())
        System.put_env("SECRET_KEY_BASE", generate_secret())
      end

      defp generate_keys do
        generate_secret() <> "," <> generate_secret() 
      end

      defp generate_secret do
        :crypto.strong_rand_bytes(32) |> :base64.encode
      end
    end
  end
end
