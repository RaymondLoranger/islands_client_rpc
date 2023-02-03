defmodule Islands.Client.RPC.GameAlreadyUnderway do
  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Game

  @spec message(Game.name(), node) :: ANSI.ansilist()
  def message(name, node) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Game ",
      :italic,
      "#{name}",
      :not_italic,
      " already underway on node ",
      :italic,
      "#{inspect(node)}",
      :not_italic,
      "."
    ]
  end
end
