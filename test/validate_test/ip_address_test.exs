defmodule Fields.ValidateIpAddressTest do
  use ExUnit.Case
  use ExUnitProperties

  alias Fields.Validate

  test "ipv6 address is valid" do
    ip_address = "2001:cdba:0000:0000:0000:0000:3257:9652"
    assert Validate.ip_address(ip_address)
  end

  test "ipv4 address is valid" do
    ip_address = "168.212.226.204"
    assert Validate.ip_address(ip_address)
  end

  test "refute wrong ip address" do
    ip_address = "0.0"
    refute Validate.ip_address(ip_address)
  end

end
