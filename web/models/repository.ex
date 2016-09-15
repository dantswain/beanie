defmodule Beanie.Repository do
  use Beanie.Web, :model

  schema "repositories" do
    field :name, :string
    field :description, :string
    has_many :tags, Beanie.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description])
  end
end
