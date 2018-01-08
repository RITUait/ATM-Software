# welcome to my code...(ATM)...

accounts={}
# To display message
def show_message(text)
  puts text
end

# To encript your password using base64
def encript(text_to_encript)
  require 'base64'
  Base64.encode64(text_to_encript)

end
 
# To store the create_history for a particular account_id
def create_history(account_id, accounts, action, deposit_withdrawl, current_balance)
  new_transaction_history= {
    date_time: Time.now,
    action: action,
    amount: deposit_withdrawl,
    current_balance: current_balance
  }
 # print new_transaction_history
 accounts[account_id][:transaction].push(new_transaction_history)
end 

#To take user input
def input(account_id, accounts)
  require 'io/console'
  if accounts[account_id]
    show_message("successful..account number exists")
    show_message("Enter your password plzzzz...")
    encript_to_match=encript(STDIN.noecho(&:gets).chomp.to_s)
    match(account_id, encript_to_match, accounts)
    #operations(account_id)
  else
    show_message "new account..needs to register.."
    show_message "enter details to be stored .."
    show_message "Enter your name ..."
    name = gets.chomp.to_s
    show_message "enter your password.."
    pass_encripted= encript(STDIN.noecho(&:gets).chomp.to_s)
  end
    show_message "Enter the balance amount :depositing.."
    balance = gets.chomp.to_i
    details_store(name,pass_encripted, balance, accounts, account_id,[])
    create_history( account_id,accounts,"deposit",balance,accounts[account_id][:balance])
    operations(account_id, accounts)
end


#To store details_store of a particular person in a hash
def details_store(name, pass_encripted, balance, accounts, account_id, trans_array)
  accounts[account_id] = { name: name, password: pass_encripted, balance: balance,transaction:trans_array } 
end

#To show your all details_store
def show(account_id, accounts)
  account =	accounts[account_id]
  show_message "Name: #{account[:name]} Balance: #{account[:balance]} password: #{account[:password]}"
end

# To show your transation history
def show_history(account_id,accounts)
  account = accounts[account_id]

  length1=account[:transaction].length
  copy_to_sort=account[:transaction]

  copy_to_sort.sort_by! {|obj| obj[:time]}.reverse!
  show_message "\n"
  show_message "##############################################################################################################################################\n"
  show_message "Date and Time\t\t\t\t\t action\t\t\t\t amount\t\t\t\tcurrent_balance"
  show_message "#############################################################################################################################################\n"
  show_message "\n"
  copy_to_sort.each { |element|
    element.each{ |key,value| 
      if key == :date_time
        value = value.strftime( "%d %b %Y %H:%M %p") 
      end    
      print "#{value}\t\t\t\t"
    }
    print "\n"

  }
  show_message "\n"
  show_message "**********************************************************************************************************************************************\n"
end

#operations 1.withdraw 2.deposit
def operations(account_id, accounts)
  #show_message "enter y/Y to continute"	
  #continue=gets.chomp.to_s
  begin
    show_message "****************************************************************************************\n"
    show_message "1. Enter 1 to deposit money\n2. Enter 2 to withdraw money \n3.Enter 3 to show your details_stored \n4.Enter 4 to show your transaction History"
    show_message "******************************************************************************************\n"
    action_done = gets.chomp.to_i
    if action_done  == 1
      deposit(account_id, accounts,"deposit")
    elsif action_done == 2
      withdraw(account_id, accounts,"withdraw")
    elsif action_done == 3
      show(account_id,accounts)
    else
      show_history(account_id,accounts)
    end
    show_message "Enter y or Y to continue and any other key to exit"
    continue=gets.chomp.to_s
  end while continue =="y"||continue== "Y"
  first(accounts)
end

# Withdraw money from your account
def withdraw(account_id, accounts,action)
  account = accounts[account_id]
  show_message "Enter amount to withdraw from your account"
  withdrawl_amount  = gets.chomp.to_i
  balance = account[:balance]
  if balance < withdrawl_amount
    show_message("Ooops! Your balance is low!")
  else
    account[:balance] = balance - withdrawl_amount
    show_message "Withdrawl Successfull! Your remaining balance is #{account[:balance]}"
  end
  create_history(account_id,accounts,action,withdrawl_amount,account[:balance])
end

# Deposit money to your account
def deposit(account_id, accounts,action)
  account = accounts[account_id]
  show_message "Enter amount to deposit in your account"
  money_to_deposit = gets.chomp.to_i
  balance=account[:balance]
  #accounts[:account_id].store :balance ,balance+money_to_deposit
  account[:balance] = balance + money_to_deposit
  show_message "wooow !!! transaction sucessful..your current balance is #{account[:balance]}"
  create_history(account_id,accounts,action,money_to_deposit,account[:balance])
end

# To match password for a given account_id(account id)
def match(account_id, encript_to_match, accounts)
  if encript_to_match == accounts[account_id][:password]
    operations(account_id,accounts)
  else
    show_message("failed..")
  end
end

def first(accounts)
  begin
    show_message("You are most welcome here..")
    show_message("Enter account number..")
    account_id = gets.chomp.to_i
    input(account_id, accounts)
    show_message "Enter y or Y to continue"
    more=gets.chomp.to_s
  end while ["y","Y"].include? more
end

first(accounts)
