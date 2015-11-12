defmodule Toolbox.PackageSyncWorkerTest do
  use ExUnit.Case

  defmodule TestSyncer do
    def run do
      send :test, :synced
    end
  end

  setup do
    old_env = Application.get_env(:toolbox, Toolbox.PackageSyncWorker)

    Application.put_env(:toolbox, Toolbox.PackageSyncWorker,
      syncer: TestSyncer,
      interval: 30,
    )

    on_exit fn ->
      Application.put_env(:toolbox, Toolbox.PackageSyncWorker, old_env)
    end

    :ok
  end

  test "it syncs on an interval" do
    Process.register self, :test
    {:ok, _} = Toolbox.PackageSyncWorker.start_link

    :timer.sleep 20
    refute_received :synced

    :timer.sleep 10
    assert_received :synced

    :timer.sleep 20
    refute_received :synced

    :timer.sleep 10
    assert_received :synced
  end
end
