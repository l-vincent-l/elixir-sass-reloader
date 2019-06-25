defmodule ElixirSassReloader do
  use GenServer
  require Logger

  def start_link(args), do: GenServer.start_link(__MODULE__, args)

  @impl true
  def init(_) do
    opts = [
      name: :elixir_sass_reloader_file_monitor,
      dirs: Enum.map([input_dir()], &Path.absname/1),
    ]

    case FileSystem.start_link(opts) do
      {:ok, pid} ->
        FileSystem.subscribe(pid)
        {:ok, %{watcher_pid: pid, queued: false} |> IO.inspect}
      other ->
        Logger.warn """
        Could not start ElixirSassReloader because we cannot listen to the file system.
        """
        other
    end
  end

  @impl true
  def handle_info({:file_event, _pid, {path, _event}}, state) do
    if String.ends_with?(path, ".scss") do
      Logger.info "file #{path} changed!"
      Process.send_after(self(), :queue_execution, latency())
    end

    {:noreply, %{state | queued: true}}
  end

  def handle_info(:queue_execution, %{queued: true} = state) do
    {:noreply, %{state | queued: false}, {:continue, :execute}}
  end
  def handle_info(:queue_execution, state), do: {:noreply, state}

  @impl true
  def handle_continue(:execute, state) do
    output_filename = String.replace_suffix(entry_point(), ".scss", ".css")
    output_path = Path.join(output_dir(), output_filename)
    cmd = "sassc -m auto -I #{input_dir()} #{entry_point()} #{output_path}"

    Logger.info "cmd: #{cmd}"
    Exexec.run(cmd)
    {:noreply, state}
  end

  defp entry_point, do: Application.get_env(:phoenix_css_live_reload, :entry_point, "app.scss")
  defp input_dir, do: Application.get_env(:phoenix_css_live_reload, :input_dir, "priv/scss")
  defp output_dir, do: Application.get_env(:phoenix_css_live_reload, :output_dir, "priv/static/css")
  defp latency, do: Application.get_env(:phoenix_css_live_reload, :latency, 500)
end
