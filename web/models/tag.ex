defmodule Beanie.Tag do
  use Beanie.Web, :model

  schema "tags" do
    field :name, :string
    field :creation_timestamp, Ecto.DateTime
    belongs_to :repository, Beanie.Repository
    has_many :tags, Beanie.Tag

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :creation_timestamp])
    |> validate_required([:name, :creation_timestamp])
  end
end
