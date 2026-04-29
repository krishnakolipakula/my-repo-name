// Test demonstrating private field access control

BankAccount = class begin
    private var balance: integer;
    
    constructor() begin
        balance := 100;
    end
    
    procedure deposit() begin
        balance := balance + 50;
    end
    
    procedure showBalance() begin
        writeln(balance);
    end
end

var account: BankAccount;
account := BankAccount.Create();
account.deposit();
account.showBalance();
// Note: Trying to access account.balance directly would cause an error
