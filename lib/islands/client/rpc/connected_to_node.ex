defmodule Islands.Client.RPC.ConnectedToNode do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(node) do
    [
      :dark_green_background,
      :light_white,
      "Connected to node ",
      :italic,
      "#{inspect(node)}",
      :not_italic,
      "..."
    ]
  end
end
