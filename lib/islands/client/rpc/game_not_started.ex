defmodule Islands.Client.RPC.GameNotStarted do
  alias IO.ANSI.Plus, as: ANSI
  alias Islands.Game

  @spec message(Game.name()) :: ANSI.ansilist()
  def message(name) do
    [
      :fuchsia_background,
      :light_white,
      "Islands Game ",
      :italic,
      "#{name}",
      :not_italic,
      " not started."
    ]
  end
end
