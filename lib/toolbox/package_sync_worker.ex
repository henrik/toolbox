defmodule Toolbox.PackageSyncWorker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :noargs)
  end

  def init(state) do
    work_after_interval

    {:ok, state}
  end

  def handle_info(:work, state) do
    work
    work_after_interval

    {:noreply, state}
  end

  defp work_after_interval do
    Process.send_after(self, :work, interval)
  end

  defp work do
    syncer.run
  end

  defp interval, do: fetch_config!(:interval)
  defp syncer, do: fetch_config!(:syncer)

  defp fetch_config!(key) do
    Application.get_env(:toolbox, __MODULE__)
    |> Dict.fetch!(key)
  end
end
