defmodule HouseholdAccountBookAppWeb.HouseholdAccountBookController do
  use HouseholdAccountBookAppWeb, :controller

  alias HouseholdAccountBookApp.Incomes
  alias HouseholdAccountBookApp.Purchases

  def summary(conn, %{"date" => date}) do
    [year, month] =
      date
      |> String.split("-")
      |> Enum.map(fn d -> String.to_integer(d) end)

    date = Date.new!(year, month, 1)

    sum_incomes = Incomes.sum_incomes_by_month(date)
    money_by_categories = Purchases.get_money_by_categories(date)
    money_by_date = Purchases.get_money_by_date(date)

    render(
      conn,
      :summary,
      sum_incomes: sum_incomes,
      money_by_categories: money_by_categories,
      money_by_date: money_by_date,
      date: date
    )
  end

  def summary(conn, _params) do
    date = Date.utc_today()

    sum_incomes = Incomes.sum_incomes_by_month(date)
    money_by_categories = Purchases.get_money_by_categories(date)
    money_by_date = Purchases.get_money_by_date(date)

    render(
      conn,
      :summary,
      sum_incomes: sum_incomes,
      money_by_categories: money_by_categories,
      money_by_date: money_by_date,
      date: date
    )
  end
end
