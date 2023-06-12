defmodule HouseholdAccountBookApp.Purchases do
  @moduledoc """
  The Purchases context.
  """

  import Ecto.Query, warn: false
  alias HouseholdAccountBookApp.Repo

  alias HouseholdAccountBookApp.Purchases.Purchase
  alias HouseholdAccountBookApp.Purchases.Category

  def keyword_list_categories() do
    Category
    |> Repo.all()
    |> Enum.reduce([], fn %Category{id: id, category_name: category_name}, list ->
      Keyword.merge(list, "#{category_name}": "#{id}")
    end)
  end

  @doc """
  Returns the list of purchases.

  ## Examples

      iex> list_purchases()
      [%Purchase{}, ...]

  """
  def list_purchases do
    Repo.all(Purchase)
  end

  # 指定した月のカテゴリーごとの購入品金額の合計を計算する関数
  def get_money_by_categories(%Date{year: year, month: month}) do
    # 指定した月の最初の日付と終わりの日付を計算
    start_date = Date.new!(year, month, 1)
    end_date = Date.end_of_month(start_date)

    query =
      from(p in Purchase,
        join: c in assoc(p, :category),
        where: p.date >= ^start_date and p.date <= ^end_date,
        group_by: c.category_name,
        select: {c.category_name, sum(p.money)}
      )

    # カテゴリーのカラーコードが必要なので再度データベースからカテゴリーを取得
    query
    |> Repo.all()
    |> Enum.map(fn {category_name, money} ->
      category = Repo.get_by(Category, category_name: category_name)
      {category.category_name, category.color_code, money}
    end)
  end

  @doc """
  Gets a single purchase.

  Raises `Ecto.NoResultsError` if the Purchase does not exist.

  ## Examples

      iex> get_purchase!(123)
      %Purchase{}

      iex> get_purchase!(456)
      ** (Ecto.NoResultsError)

  """
  def get_purchase!(id), do: Repo.get!(Purchase, id)

  @doc """
  Creates a purchase.

  ## Examples

      iex> create_purchase(%{field: value})
      {:ok, %Purchase{}}

      iex> create_purchase(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_purchase(attrs \\ %{}) do
    %Purchase{}
    |> Purchase.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a purchase.

  ## Examples

      iex> update_purchase(purchase, %{field: new_value})
      {:ok, %Purchase{}}

      iex> update_purchase(purchase, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_purchase(%Purchase{} = purchase, attrs) do
    purchase
    |> Purchase.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a purchase.

  ## Examples

      iex> delete_purchase(purchase)
      {:ok, %Purchase{}}

      iex> delete_purchase(purchase)
      {:error, %Ecto.Changeset{}}

  """
  def delete_purchase(%Purchase{} = purchase) do
    Repo.delete(purchase)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking purchase changes.

  ## Examples

      iex> change_purchase(purchase)
      %Ecto.Changeset{data: %Purchase{}}

  """
  def change_purchase(%Purchase{} = purchase, attrs \\ %{}) do
    Purchase.changeset(purchase, attrs)
  end
end
