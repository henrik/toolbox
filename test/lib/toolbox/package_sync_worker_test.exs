defmodule Toolbox.PackageSyncWorkerTest do
  use ExUnit.Case

  defmodule TestSyncer do
    def interval, do: 30
    def run, do: send(:test, :synced)
  end

  setup do
    old_syncer = Application.get_env(:toolbox, :package_syncer)

    Application.put_env(:toolbox, :package_syncer, TestSyncer)

    on_exit fn ->
      Application.put_env(:toolbox, :package_syncer, old_syncer)
    end

    :ok
  end

  test "it syncs on an interval" do
    Process.register self, :test
    {:ok, _} = Toolbox.PackageSyncWorker.start_link

    :timer.sleep 15
    refute_received :synced

    :timer.sleep 15
    assert_received :synced

    :timer.sleep 15
    refute_received :synced

    :timer.sleep 15
    assert_received :synced
  end
end
