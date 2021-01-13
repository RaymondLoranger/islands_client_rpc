defmodule Islands.Client.RPC.EngineNodeDown do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(engine_node) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Engine node ",
      :italic,
      "#{inspect(engine_node)}",
      :not_italic,
      " is down."
    ]
  end
end
