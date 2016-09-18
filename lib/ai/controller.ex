defprotocol AI.Controller do
  @doc """
  Connect two cells together
  """
  def connect(publisher, subscriber)

  @doc """

  """
  def stimulate(cell, transmitter)

  def create(cell)

end

IO.inspect AI.Cell.StandardGraded

defimpl AI.Controller, for: AI.Cell.StandardGraded do
  def create(cell) do
    Agent.start_link(fn -> cell end)
  end
  @doc """
  Adds subscriber to publisher's subscribers array.  When the publisher
  is stimulated with a positive charge, it will depolarize and transmit
  to the subscriber
  """
  def connect(publisher, subscriber) do

  end
end


defimpl AI.Controller, for: AI.Cell.BizarroGraded do
  def connect(publisher, subscriber) do

  end
end
