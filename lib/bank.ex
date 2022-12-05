defmodule Bank do
  alias Bank.{Transaction,User}
  def create_account(registration_number,name,surname,cpf,opening_balance) do
    User.create_account(registration_number,name,surname,cpf,opening_balance)
  end

  def start_transaction(account_payer, account_reciever, value) do
    Transaction.start_transaction(account_payer, account_reciever, value)
  end
end
