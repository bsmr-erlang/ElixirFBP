defmodule Core.Output do

  def inports, do: [in_port: nil, out_pid: nil]
  def outports, do: []

  def loop(in_port, out_pid) do
    receive do
      {:in_port, value} ->
        IO.puts("\nCore.Output:in = #{inspect value}")
        loop(nil, nil)
    end
  end
end
