defmodule Beanie.Repo.Migrations.AddNoteRepository do
  use Ecto.Migration

  def change do
    alter table(:repositories) do
      add :description, :text
    end
  end
end
