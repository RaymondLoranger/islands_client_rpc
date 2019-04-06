# ┌─────────────────────────────────────────────────────────────────┐
# │ Inspired by the course "Elixir for Programmers" by Dave Thomas. │
# └─────────────────────────────────────────────────────────────────┘
defmodule Islands.Client.RPC do
  use PersistConfig

  @course_ref Application.get_env(@app, :course_ref)

  @moduledoc """
  Remote procedure calls for clients of the _Game of Islands_.
  \n##### #{@course_ref}
  """

  alias __MODULE__.{
    GameAlreadyStarted,
    GameAlreadyUnderway,
    GameNotStarted,
    IslandsEngineNotStarted
  }

  alias IO.ANSI.Plus, as: ANSI
  alias Islands.{Engine, Player, Tally}

  @node Application.get_env(@app, :islands_node)

  @spec new_game(String.t(), String.t(), Player.gender()) ::
          String.t() | no_return
  def new_game(game_name, player_name, gender) do
    Node.connect(@node)
    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    case :rpc.call(@node, Engine, :new_game, args) do
      {:ok, _pid} ->
        game_name

      {:error, {:already_started, _pid}} ->
        game_name |> GameAlreadyStarted.message() |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, :nodedown} ->
        IslandsEngineNotStarted.message(:nodedown) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:undef, _}}} ->
        IslandsEngineNotStarted.message(:nodeup) |> ANSI.puts()
        self() |> Process.exit(:normal)

      error ->
        exit(error)
    end
  end

  @spec add_player(String.t(), String.t(), Player.gender()) ::
          String.t() | no_return
  def add_player(game_name, player_name, gender) do
    Node.connect(@node)
    :ok = :global.sync()
    args = [game_name, player_name, gender, self()]

    case :rpc.call(@node, Engine, :add_player, args) do
      %Tally{response: {:ok, :player2_added}} ->
        game_name

      %Tally{response: {:error, :player2_already_added}} ->
        game_name |> GameAlreadyUnderway.message() |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:noproc, _}}} ->
        game_name |> GameNotStarted.message() |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, :nodedown} ->
        IslandsEngineNotStarted.message(:nodedown) |> ANSI.puts()
        self() |> Process.exit(:normal)

      {:badrpc, {:EXIT, {:undef, _}}} ->
        IslandsEngineNotStarted.message(:nodeup) |> ANSI.puts()
        self() |> Process.exit(:normal)

      error ->
        exit(error)
    end
  end
end
