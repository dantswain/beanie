defmodule Beanie.Repo.Migrations.CreateRepository do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :name, :string

      timestamps()
    end

  end
end
