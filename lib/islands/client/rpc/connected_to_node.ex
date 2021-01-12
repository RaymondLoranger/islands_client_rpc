defmodule Islands.Client.RPC.ConnectedToNode do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(atom) :: ANSI.ansilist()
  def message(engine_node) do
    [
      :fuchsia_background,
      :light_white,
      "Connected to node ",
      :fuchsia_background,
      :stratos,
      "#{inspect(engine_node)}",
      :fuchsia_background,
      :light_white,
      "."
    ]
  end
end
