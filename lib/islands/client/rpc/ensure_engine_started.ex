defmodule Islands.Client.RPC.EnsureEngineStarted do
  alias IO.ANSI.Plus, as: ANSI

  @spec message(node) :: ANSI.ansilist()
  def message(node) do
    [
      :fuchsia_background,
      :light_white,
      "Ensure Islands Engine is started on node ",
      :italic,
      "#{inspect(node)}",
      :not_italic,
      "."
    ]
  end
end
