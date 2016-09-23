defmodule AI do
  use Application
  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: AI.Supervisor]
    Task.Supervisor.start_link(opts)
  end
end

# Task.Supervisor.start_child(AI.TaskSupervisor, fn -> IO.puts "yease" end)
