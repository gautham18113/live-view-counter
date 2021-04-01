defmodule LiveViewCounter.Count do
  @moduledoc """
  This module preserves the state of the counter. 
  Without a module for preserving state, the counter value will be initialized at 0 whenever a the app is opened in a new browser session.
  Pubsub will then synchronize the counter value when increment or decrement button is pressed. This can be a costly operation for larger systems.

  Preserving the state or value of the counter through a separate service and then broadcasting through PubSub will take away the responsibility from the app. 
  Hence a new app instance will always be initialized with the current value of the counter on the Count service.
  """
  use GenServer

  alias Phoenix.PubSub

  @count 0

  @name :count_server

  def topic, do: "count" 

  # ------- Client API -------
  def start_link(_opts) do
    GenServer.start_link(__MODULE__, @count, name: @name)
  end

  def increment() do
    GenServer.call @name, :increment
  end

  def decrement() do
    GenServer.call @name, :decrement
  end

  def current() do
    GenServer.call @name, :current
  end

  def init(count), do: {:ok, count}

  # ------ GenServer Process -------
  def handle_call(:current, _from, count) do
    { :reply, count, count }
  end

  def handle_call(:increment, _from, count) do
    make_change(count, +1)
  end

  def handle_call(:decrement, _from, count) do
    make_change(count, -1)
  end

  defp make_change(count, change) do
    new_count = count + change
    PubSub.broadcast(LiveViewCounter.PubSub, topic(), {:count, new_count})
    { :reply, new_count, new_count }
  end
  
end

