defmodule Beanie.Repository do
  use Beanie.Web, :model

  schema "repositories" do
    field :name, :string
    field :tags, {:array, :string}, virtual: true, default: []

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
