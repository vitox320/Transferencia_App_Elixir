defmodule Bank.User do
  @required_keys [:registration_number, :name, :surname, :cpf, :balance]
  @enforce_keys @required_keys
  defstruct @required_keys

  def create_account(registration_number, name, surname, cpf, balance) do
    %Bank.User{
      registration_number: registration_number,
      name: name,
      surname: surname,
      cpf: cpf,
      balance: balance
    }
  end

  def get_balance(account) do
    IO.puts("Balance of this account is #{Map.get(account, :balance)}")
  end
end
