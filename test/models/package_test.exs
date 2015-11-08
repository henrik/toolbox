defmodule Toolbox.PackageTest do
  use Toolbox.ModelCase

  alias Toolbox.Package

  @valid_attrs %{description: "some content", hex_updated_at: "2010-04-17 14:00:00", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Package.changeset(%Package{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Package.changeset(%Package{}, @invalid_attrs)
    refute changeset.valid?
  end
end
