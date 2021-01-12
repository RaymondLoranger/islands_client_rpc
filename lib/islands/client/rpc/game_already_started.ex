defmodule Islands.Client.RPC.GameAlreadyStarted do
  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Game

  @spec message(Game.name()) :: ANSI.ansilist()
  def message(game_name) do
    [
      :fuchsia_background,
      :light_white,
      "Game ",
      :fuchsia_background,
      :stratos,
      "#{game_name}",
      :fuchsia_background,
      :light_white,
      " already started."
    ]
  end
end
