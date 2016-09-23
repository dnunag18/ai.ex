defmodule AI.Cell.BizarroGraded do
  @moduledoc """
  Graded cell that when it is stimulated with positive charges, it produces negative charges/trasmitters
  """
  @behaviour AI.Cell


  defstruct [
    subscribers: [],
    charge: 0.0,
    publish: &AI.Cell.BizarroGraded.publish/1,
    threshold: 0.0
  ]

  @spec start_link() :: {Keyword.t, term}
  def start_link do
    Agent.start_link(fn -> %AI.Cell.BizarroGraded{} end)
  end

  def publish(cell) do
    [charge, subscribers] = Enum.map(
      [:charge, :subscribers],
      &AI.Cell.get(cell, &1)
    )
    if subscribers do
      Enum.each(subscribers, &AI.Cell.stimulate(&1, -charge))
    end
    {:published, charge}
  end
end
