defmodule Islands.Client.RPC.CannotConnectToNode do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(node) do
    [
      :fuchsia_background,
      :light_white,
      "Cannot connect to node ",
      :italic,
      "#{inspect(node)}",
      :not_italic,
      "."
    ]
  end
end
