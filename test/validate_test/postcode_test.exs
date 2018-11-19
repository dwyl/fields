defmodule Fields.ValidatePostcodeTest do
  use ExUnit.Case
  use ExUnitProperties

  require Integer

  alias Fields.Validate

  def postcode(chars) do
    chars
    |> Enum.concat([:i, :s, :s])
    |> Enum.map(fn
      :i -> string(?0..?9, length: 1)
      :s -> string(?a..?z, length: 1)
      :space -> string(' ', length: 1)
    end)
    |> List.to_tuple()
    |> StreamData.map(fn sd -> sd |> Tuple.to_list() |> Enum.join("") end)
  end

  def invalid_format() do
    StreamData.map(StreamData.integer(), fn i ->
      cond do
        Integer.is_odd(i) -> :i
        Integer.is_even(i) -> :s
      end
    end)
    |> StreamData.list_of(min_length: 2, max_length: 4)
    |> StreamData.filter(fn l ->
      l not in [
        [:s, :s, :i, :s],
        [:s, :i, :s],
        [:s, :i],
        [:s, :i, :i],
        [:s, :s, :i],
        [:s, :s, :i, :i]
      ]
    end)
  end

  property "AA9A 9AA is valid format" do
    check all postcode <- postcode([:s, :s, :i, :s, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :s, :i, :s]) do
      assert Validate.postcode(postcode)
    end
  end

  property "A9A 9AA is valid format" do
    check all postcode <- postcode([:s, :i, :s, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :i, :s]) do
      assert Validate.postcode(postcode)
    end
  end

  property "A9 9AA is valid format" do
    check all postcode <- postcode([:s, :i, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :i]) do
      assert Validate.postcode(postcode)
    end
  end

  property "A99 9AA is valid format" do
    check all postcode <- postcode([:s, :i, :i, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :i, :i]) do
      assert Validate.postcode(postcode)
    end
  end

  property "AA9 9AA is valid format" do
    check all postcode <- postcode([:s, :s, :i, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :s, :i]) do
      assert Validate.postcode(postcode)
    end
  end

  property "AA99 9AA is valid format" do
    check all postcode <- postcode([:s, :s, :i, :i, :space]) do
      assert Validate.postcode(postcode)
    end

    check all postcode <- postcode([:s, :s, :i, :i]) do
      assert Validate.postcode(postcode)
    end
  end

  property "postcode that is too long is not valid" do
    check all postcode <- string(:alphanumeric, min_length: 8) do
      refute Validate.postcode(postcode)
    end
  end

  property "all other formats are invalid" do
    check all format <- invalid_format(),
              postcode <- postcode(format) do
      refute Validate.postcode(postcode)
    end
  end
end
