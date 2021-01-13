defmodule Islands.Client.RPC.CannotConnectToNode do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(atom) :: ANSI.ansilist()
  def message(engine_node) do
    [
      :fuchsia_background,
      :light_white,
      "Cannot connect to node ",
      :italic,
      "#{inspect(engine_node)}."
    ]
  end
end
