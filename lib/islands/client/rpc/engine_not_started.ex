defmodule Islands.Client.RPC.EngineNotStarted do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(node) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Engine not started on node ",
      :italic,
      "#{inspect(node)}",
      :not_italic,
      "."
    ]
  end
end
