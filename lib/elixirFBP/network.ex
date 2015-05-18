defmodule ElixirFBP.Network do
  @moduledoc """
  ElxirFBP.Network is a GenServer that provides support for starting and stopping
  FBP networks(graphs), and finding out about their state.

  Functions supported by this module are based on NoFlo's FBP Network Protocol,
  specifically the network sub-protocol. See http://noflojs.org/documentation/protocol/
  for the details.

  This module is registered with its module name.

  It is assumed that the ElixirFBP.Graph GenServer, which becomes this servers
  state, has been started and registered with its id as its name.

  """
  defstruct [
    graph_id: nil,
    status: :stopped
  ]
  use GenServer

  ########################################################################
  # The External API

  @doc """
  Starts things off with the creation of the state.
  """
  def start_link(fbp_graph_process_name) do
    GenServer.start_link(__MODULE__, fbp_graph_process_name, name: __MODULE__)
  end

  @doc """
  Start execution of the graph
  """
  def start do
    GenServer.cast(__MODULE__, :start)
  end

  @doc """
  Stop the execution of the graph
  """
  def stop do
    GenServer.cast(__MODULE__, :stop)
  end

  @doc """
  Get the networks current status
  """
  def get_status do
    GenServer.call(__MODULE__, :get_status)
  end

  @doc """
  Data transmission on an edge.
  """
  def data(graph_id, edge_id, src, tgt, subgraph \\ nil) do
    GenServer.cast(__MODULE__, {:data, graph_id, edge_id, src, tgt, subgraph})
  end

  ########################################################################
  # The GenServer implementations

  @doc """
  Callback implementation for ElixirFBP.Network.start_link()
  Initialize the state with an FBP graph.
  """
  def init(fbp_graph_process_name) do
    {:ok, %ElixirFBP.Network{graph_id: fbp_graph_process_name}}
  end

  @doc """
  Callback implementation for ElixirFBP.Network.start()
  Starting a network involves the following steps:
    1. Spawn (start_link) all components in the graph
    2. Send all initial data values to their respective processes.

  """
  def handle_cast(:start, network) do
    nodes = ElixirFBP.Graph.nodes(network.graph_id)
    Enum.each(nodes, fn (node) -> start_node(node) end)
    new_network = %{network | :status => :started}
    {:noreply, new_network}
  end

  @doc """
  Callback implementation for ElixirFBP.Network.stop()
  Stop the currently running graph.
  """
  def handle_cast(:stop, network) do
    new_network = %{network | :status => :stopped}
    {:noreply, new_network}
  end

  @doc """
  Callback implementation for ElixirFBP.Network.data
  """
  def handle_cast({:data, graph_id, edge_id, src, tgt, subgraph}, network) do
    nodes = ElixirFBP.Graph.nodes(network.graph_id)
    {:noreply, network}
  end
  
  @doc """
  Callback implementation for ElixirFBP.Network.get_status
  """
  def handle_call(:get_status, _req, network) do
    {:reply, network.status, network}
  end

  defp start_node(node) do
    component = node.label.component
    module = Module.concat([component])
    #spawn_link(component, :s)
  end
end
