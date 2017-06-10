defmodule Conduit.Wait do
  @default_timeout 1_000
  @default_retry_interval 50

  def until(fun), do: until(@default_timeout, fun)

  def until(0, fun) do
    case fun.() do
      nil -> {:error, :timeout}
      result -> {:ok, result}
    end
  end

  def until(timeout, fun) do
    case fun.() do
      nil ->
        :timer.sleep(@default_retry_interval)
        until(max(0, timeout - @default_retry_interval), fun)

      result -> {:ok, result}
    end
  end
end