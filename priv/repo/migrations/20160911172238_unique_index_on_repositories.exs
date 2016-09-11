defmodule Beanie.Repo.Migrations.UniqueIndexOnRepositories do
  use Ecto.Migration

  def change do
    create index(:repositories, [:name], unique: true)
  end
end
