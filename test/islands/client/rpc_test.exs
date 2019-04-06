defmodule Islands.Client.RPCTest do
  use ExUnit.Case, async: true

  alias Islands.Client.RPC

  doctest RPC

  test "the truth" do
    assert 1 + 2 == 3
  end
end
