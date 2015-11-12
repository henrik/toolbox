defmodule Toolbox.PackageSync.NoOp do
  def interval, do: 999_999  # ms
  def run, do: :noop
end
