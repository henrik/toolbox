defmodule Toolbox.CategoryController do
  use Toolbox.Web, :controller

  alias Toolbox.Category

  plug :scrub_params, "category" when action in [:create, :update]

  def index(conn, _params) do
    categories = Repo.all(Category)

    conn
    |> assign(:page_title, "Manage categories")
    |> render("index.html", categories: categories)
  end

  def new(conn, _params) do
    changeset = Category.changeset(%Category{})

    conn
    |> render_new(changeset)
  end

  def create(conn, %{"category" => category_params}) do
    changeset = Category.changeset(%Category{}, category_params)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        render_new(conn, changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category)

    conn
    |> render_edit(category, changeset)
  end

  def update(conn, %{"id" => id, "category" => category_params}) do
    category = Repo.get!(Category, id)
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: category_path(conn, :index))
      {:error, changeset} ->
        render_edit(conn, category, changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: category_path(conn, :index))
  end

  defp render_new(conn, changeset) do
    conn
    |> assign(:page_title, "Add category")
    |> render("new.html", changeset: changeset)
  end

  defp render_edit(conn, category, changeset) do
    conn
    |> assign(:page_title, "Edit \"#{category.name}\"")
    |> render("edit.html", category: category, changeset: changeset)
  end
end
