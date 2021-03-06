defmodule ElixirFBPNetworkTest do
  use ExUnit.Case, async: false
  alias ElixirFBP.Graph
  alias ElixirFBP.Network

  @graph_1      "graph_n1"
  @node_1       "node_1"
  @node_2       "node_2"

  test "Create an ElixirFBP Network" do
    {:ok, fbp_graph_reg_name} = Graph.start_link(@graph_1)
    {:ok, _fbp_network_pid} =
            Network.start_link(fbp_graph_reg_name)
    status = Network.get_status()
    assert status == :stopped
    # Make sure the network is stopped?
    Network.stop()
    Network.stop_network()
  end

  test "Start an ElxirFBP Network" do
    {:ok, fbp_graph_reg_name} = Graph.start_link(@graph_1)
    Graph.add_node(fbp_graph_reg_name, @node_1, "Math.Add")
    Graph.add_node(fbp_graph_reg_name, @node_2, "Core.Output")
    _edge = Graph.add_edge(
                  fbp_graph_reg_name,
                  @node_1, :sum,
                  @node_2, :in)

    Graph.add_initial(fbp_graph_reg_name, 42, @node_1, :addend)
    Graph.add_initial(fbp_graph_reg_name, 24, @node_1, :augend)
    {:ok, _fbp_network_pid} =
        Network.start_link(fbp_graph_reg_name)
    Network.start()
    status = Network.get_status()
    assert status == :started
    # Make sure the network is stopped
    Network.stop()
    # kill the network process
    Network.stop_network
  end

  test "Stop an ElxirFBP Network" do
    {:ok, fbp_graph_reg_name} = Graph.start_link(@graph_1)
    {:ok, _fbp_network_pid} =
          Network.start_link(fbp_graph_reg_name)
    Network.start()
    Network.stop()
    status = Network.get_status()
    assert status == :stopped
    # Stop the GenServer Network process
    Network.stop_network
  end

end
