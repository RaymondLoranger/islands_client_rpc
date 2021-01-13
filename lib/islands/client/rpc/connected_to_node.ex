defmodule Islands.Client.RPC.ConnectedToNode do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(atom) :: ANSI.ansilist()
  def message(engine_node) do
    [
      :dark_green_background,
      :light_white,
      "Connected to node ",
      :italic,
      "#{inspect(engine_node)}...\n"
    ]
  end
end
