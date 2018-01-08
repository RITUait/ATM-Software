$bank_hash = {}

class Bank
  attr_accessor :bankname
  def initialize(text)
    @bankname = text
  end

  def accounts
    @accounts ||= {}
  end

  def self.operations(a1)
    begin
      print "1.Enter 1 to deposit money","\n","2.Enter 2 to withdraw money","\n","3.Enter 3 to show account details","\n","4.Enter 4 to show transaction history"
      print "\n enter choice"
      choice = gets.chomp.to_i
      if choice == 1
        #print "enter amount to deposit"
        #deposit_amount = gets.chomp.to_i
        #these 2 lines write in deposit function and no need to pass deposit_amount because deposit function  can be used from anywhere else also if your project is big.
        #line number to indent then == to indent utni number of lines
        a1.deposit(deposit_amount)
      elsif choice == 2
        print "enter amount to withdraw"
        withdraw_amount = gets.chomp.to_i
        a1.withdraw(withdraw_amount)
      elsif choice == 3
        print " name : #{a1.name} balance : #{a1.balance}"
      else
        print "date_time","\t\t\t","action","\t\t\t","amount","\t\t\t","current_balance","\n"
        a1.transactions.each {|history_obj|  
          print history_obj.date_time.strftime("%d %b %H %H:%M %p") , "\t\t" 
          print history_obj.action,"\t\t\t"
          print history_obj.amount,"\t\t"
          print history_obj.balance,"\n"
        }
      end
      print "\n", "enter y or Y to continue"
      continue = gets.chomp.to_s
    end while["Y" , "y"].include?continue
    main_func()
  end
end



class Account
  attr_accessor :account_no,:name,:password,:balance,:transactions
  def initialize(account_no)
    @account_no = account_no
  end

  def create_account
    print "enter name"
    @name       = gets.chomp.to_s
    print "enter password"
    @password   = gets.chomp.to_i
    print"enter money to open your account"
    @balance    = gets.chomp.to_i
    t1 = TransHistory.new("deposit",balance,balance)
    self.transactions<<t1
  end

  def deposit(deposit_amount)
    @balance += deposit_amount
    self.transactions << TransHistory.new("deposit",deposit_amount,balance)
  end

  def withdraw(withdraw_amount)
    if withdraw_amount > @balance
      print "oops! you are low on your balance"
    else
      @balance -= withdraw_amount
      self.transactions << TransHistory.new("withdraw",withdraw_amount,balance)
    end
  end

  def transactions
    @transactions ||= []
  end
end



class TransHistory
  attr_accessor :date_time, :action,:amount,:balance
  def initialize(action,amount,balance)
    @date_time = Time.now
    @action    = action
    @amount    = amount
    @balance   = balance
  end
end




#main
def new_account(account_no,bank_name)
  print "new account : enter details \n "
  a1 = Account.new(account_no)
  a1.create_account
  $bank_hash[bank_name][a1.account_no] =a1
  Bank.operations(a1)
end

def main_func
  print "enter bank name "
  bank_name = gets.chomp.to_s

  if $bank_hash[bank_name].nil?
    print "new bank detected \n"
    b1 =  Bank.new(bank_name)
    $bank_hash[bank_name] =b1.accounts
    print "enter account_no"
    account_no = gets.chomp.to_i
    if $bank_hash[bank_name][account_no].nil?
      new_account(account_no,bank_name)
    else
      print "account already exists \n"
      Bank.operations(a1)
    end

  else
    print "bank already exists \n"
    print "enter account no"
    account_no = gets.chomp.to_i
    if $bank_hash[bank_name][account_no].nil?
      new_account(account_no,bank_name)
    else
      print "account already exists \n"
      Bank.operations($bank_hash[bank_name][account_no])
    end
  end
end


main_func()
