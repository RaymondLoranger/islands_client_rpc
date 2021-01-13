defmodule Islands.Client.RPC.GameAlreadyUnderway do
  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Game

  @spec message(Game.name()) :: ANSI.ansilist()
  def message(game_name) do
    [
      :fuchsia_background,
      :light_white,
      "Game ",
      :italic,
      "#{game_name}",
      :not_italic,
      " already underway."
    ]
  end
end
