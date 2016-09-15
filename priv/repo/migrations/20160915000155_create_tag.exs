defmodule Beanie.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :name, :string, null: false
      add :creation_timestamp, :datetime, null: false
      add :repository_id, references(:repositories, on_delete: :nothing), null: false

      timestamps()
    end
    create index(:tags, [:repository_id])
    create index(:tags, [:repository_id, :name], unique: true)

    alter table(:repositories) do
      modify :name, :string, null: false
    end
  end
end
