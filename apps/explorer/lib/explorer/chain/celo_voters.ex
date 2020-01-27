defmodule Explorer.Chain.CeloVoters do
  @moduledoc """
  Data type and schema for signer history for accounts
  """

  require Logger

  use Explorer.Schema

  alias Explorer.Chain.{Address, Hash, Wei}

  @typedoc """
  * `address` - address of the validator.
  * 
  """

  @type t :: %__MODULE__{
          group_address_hash: Hash.Address.t(),
          voter_address_hash: Hash.Address.t(),
          active: Wei.t(),
          pending: Wei.t()
        }

  @attrs ~w(
    group_address_hash voter_address_hash active pending
      )a

  @required_attrs ~w(
    group_address_hash voter_address_hash
      )a

  # Voter change events
  @validator_group_vote_revoked "0xa06c722f7d446349fdd811f3d539bc91c7b11df8a2f4e012685712a30068f668"
  @validator_group_vote_activated "0x50363f7a646042bcb294d6afdef2d53f4122379845e67627b6db367f31934f16"
  @validator_group_vote_cast "0xd3532f70444893db82221041edb4dc26c94593aeb364b0b14dfc77d5ee905152"

  @voter_rewards "0x91ba34d62474c14d6c623cd322f4256666c7a45b7fdaa3378e009d39dfcec2a7"

  # Events for updating voter
  def voter_events,
    do: [
      @validator_group_vote_revoked,
      @validator_group_vote_activated,
      @validator_group_vote_cast
    ]

  def distributed_events,
    do: [
      @voter_rewards
    ]

  schema "celo_voters" do
    belongs_to(
      :group_address,
      Address,
      foreign_key: :group_address_hash,
      references: :hash,
      type: Hash.Address
    )

    belongs_to(
      :voter_address,
      Address,
      foreign_key: :voter_address_hash,
      references: :hash,
      type: Hash.Address
    )

    field(:pending, Wei)
    field(:active, Wei)

    timestamps(null: false, type: :utc_datetime_usec)
  end

  def changeset(%__MODULE__{} = celo_voters, attrs) do
    celo_voters
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:celo_voter_key, name: :celo_voters_group_address_hash_voter_address_hash_index)
  end
end
