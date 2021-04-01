defmodule LiveViewCounterWeb.Counter do
  use Phoenix.LiveView
  alias LiveViewCounter.Count

  @topic Count.topic

  def mount(_params, _session, socket) do
    LiveViewCounterWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, :val, Count.current())}
  end

  def handle_event("inc", _, socket) do
    {:noreply, assign(socket, :val, Count.increment())}
  end

  def handle_event("dec", _, socket) do
    {:noreply, assign(socket, :val, Count.decrement())}
  end

  def handle_info({:count, count}, socket) do
    {:noreply, assign(socket, :val, count)}
  end

  def render(assigns) do
    ~L"""
    <div>
      <h1>The count is: <%= @val %></h1>
      <button phx-click="dec">-</button>
      <button phx-click="inc">+</button>
    </div>
    """
  end
end
