defmodule Bank.Transaction do
  use Agent

  def start_transaction(account_payer, account_reciever, value) do
    handle_result_balance(account_payer, account_reciever, value)
  end

  defp handle_result_balance(account_payer, _account_reciever, value)
       when account_payer.balance - value < 0,
       do: {:error, :invalid_balance}

  defp handle_result_balance(account_payer, account_reciever, value) do
    account_payer |> create_transaction(account_reciever, value)
    update_transaction()
  end

  defp create_transaction(account_payer, account_reciever, value) do
    initial_transaction = %{
      account_payer: account_payer,
      account_reciever: account_reciever,
      value: value
    }

    Agent.start_link(fn -> initial_transaction end, name: __MODULE__)
  end

  defp info_transaction() do
    Agent.get(__MODULE__, & &1)
  end

  defp update_transaction() do
    account_payer =
      fetch_info_transaction(:account_payer) |> withdraw(fetch_info_transaction(:value))

    account_reciever =
      fetch_info_transaction(:account_reciever) |> deposit(fetch_info_transaction(:value))

    value = fetch_info_transaction(:value)

    state = %{
      account_payer: account_payer,
      account_reciever: account_reciever,
      value: value
    }

    Agent.update(__MODULE__, fn _ -> state end)
    info_transaction()
  end

  defp fetch_info_transaction(info), do: Map.get(info_transaction(), info)

  defp deposit(account_reciever, value) do
    new_balance = account_reciever.balance + value
    account_reciever |> Map.put(:balance, new_balance)
  end

  defp withdraw(account_payer, value) do
    new_balance = account_payer.balance - value
    account_payer |> Map.put(:balance, new_balance)
  end
end
