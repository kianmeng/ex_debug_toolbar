defmodule ExDebugToolbar.Collector.EctoCollector do
  alias ExDebugToolbar.Toolbar
  alias Ecto.LogEntry

  def log(%LogEntry{} = entry) do
    {id, duration} = parse_entry(entry)
    Toolbar.add_finished_event(id, "ecto.query", duration)
    Toolbar.add_data(id, :ecto, entry)
    entry
  end

  defp parse_entry(entry) do
    case entry.caller_pid do
      nil ->
        duration = (entry.queue_time || 0) + (entry.query_time || 0) + (entry.decode_time || 0)
        {self(), duration}
      pid -> {pid, 0}
    end
  end
end
