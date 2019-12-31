defmodule Fields.EncryptedTest do
  use ExUnit.Case
  alias Fields.Encrypted

  test ".type is :binary" do
    assert Encrypted.type() == :binary
  end

  test ".cast converts a value to a string" do
    assert {:ok, "123"} == Encrypted.cast(123)
  end

  test ".dump encrypts a value" do
    {:ok, ciphertext} = Encrypted.dump("hello")
    {:ok, decrypted} = Encrypted.load(ciphertext)
    assert ciphertext != "hello"
    assert String.length(ciphertext) != 0
    assert decrypted == "hello"
  end

  test ".dump with google token" do
    token =
      "ya29.Il-yB-eegeLyTvygvFAtX-gJhq-LIfR1UskKVsczYPKtOeMB3l0P4ipcYNs0IrI2S5f1jZXPzgRSIYFhdsSx6ws6FYlNySzxeixEDbnTTtcrBg2a9fQJHzvWM6i9DWp2HA"

    {:ok, ciphertext} = Encrypted.dump(token)
    {:ok, decrypted} = Encrypted.load(ciphertext)
    assert token == decrypted
  end
end
