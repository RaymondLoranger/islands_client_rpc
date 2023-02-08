defmodule Islands.Client.RPC.GameNotStarted do
  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Game

  @spec message(Game.name(), term) :: ANSI.ansilist()
  def message(name, reason) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Game ",
      :italic,
      "#{name}",
      :not_italic,
      " not started.\nReason:\n",
      :italic,
      "#{inspect(reason)}"
    ]
  end
end
