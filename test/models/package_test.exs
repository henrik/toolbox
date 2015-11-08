defmodule Toolbox.PackageTest do
  use Toolbox.ModelCase
  alias Toolbox.Package
  alias Toolbox.Factory

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

  test "newest_hex_updated_at_with_names when there are values" do
    Factory.create(:package, name: "a", hex_updated_at: datetime("2000-01-02T00:00:00Z"))
    Factory.create(:package, name: "b", hex_updated_at: datetime("2000-01-02T00:00:00Z"))
    Factory.create(:package, name: "c", hex_updated_at: datetime("1999-01-02T00:00:00Z"))

    actual = Package.newest_hex_updated_at_with_names

    assert actual == {datetime("2000-01-02T00:00:00Z"), ["a", "b"]}
  end

  test "newest_hex_updated_at_with_names when there are no values" do
    actual = Package.newest_hex_updated_at_with_names

    assert actual == {datetime("0000-01-01T00:00:00Z"), []}
  end

  # Converts to Ecto.DateTime.
  # TODO: Move into factories. See:
  # https://github.com/thoughtbot/ex_machina/issues/54#issuecomment-155191465
  defp datetime(string) do
    {:ok, datetime} = Ecto.DateTime.cast(string)
    datetime
  end
end
