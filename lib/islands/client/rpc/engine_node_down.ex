defmodule Islands.Client.RPC.EngineNodeDown do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(engine_node) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Engine node ",
      :fuchsia_background,
      :stratos,
      "#{inspect(engine_node)}",
      :fuchsia_background,
      :light_white,
      " is down."
    ]
  end
end
