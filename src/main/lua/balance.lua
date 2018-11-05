import "./util.lua"
--- balance.lua

BalanceService = { }
BalanceServiceMetatable = { __index = BalanceService }
setmetatable(BalanceService, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function BalanceService.new(parent)
    return setmetatable({ parent = parent }, BalanceServiceMetatable)
end

function BalanceService:getAmount(address, assetSymbol)
    assert(nil ~= address)
    local account = system.getItem('account-' .. address)
    if nil == account then
        return 0
    else
        return account[assetSymbol] or 0
    end
end

function BalanceService:receiveFromExternal(receiverAddress, assetSymbol, amount)
    amount = tonumber(amount)
    local receiverAccount = system.getItem('account-' .. receiverAddress) or { balance = 0 }
    assert(0 < amount)
    assert(nil ~= receiverAddress)
    local key = assetSymbol
    receiverAccount[key] = M.add(receiverAccount[key] or 0, amount)

    system.setItem('account-' .. receiverAddress, receiverAccount)

    if nil ~= self.parent and nil ~= self.parent.historyService then
        local tx = Transaction(2, nil, receiverAddress, assetSymbol, amount)
        self.parent.historyService:record(tx)
    end
end

function BalanceService:transfer(receiverAddress, assetSymbol, amount)
    amount = tonumber(amount)
    local senderAddress = system.getSender()
    local senderAccount = system.getItem('account-' .. senderAddress)
    local receiverAccount = system.getItem('account-' .. receiverAddress) or { balance = 0 }

    assert(0 < amount)
    assert(nil ~= receiverAddress)
    assert(nil ~= senderAccount)
    local key = assetSymbol
    assert(amount <= senderAccount[key], 'insufficient balance')
    senderAccount[key] = M.sub(senderAccount[key] or 0, amount)
    receiverAccount[key] = M.add(receiverAccount[key] or 0, amount)

    system.setItem('account-' .. senderAddress, senderAccount)
    system.setItem('account-' .. receiverAddress, receiverAccount)

    if nil ~= self.parent and nil ~= self.parent.historyService then
        local tx = Transaction(1, senderAddress, receiverAddress, assetSymbol, amount)
        self.parent.historyService:record(tx)
    end
end


BalanceServiceComponent = {}
BalanceServiceComponentMetatable = { __index = BalanceServiceMetatable }
setmetatable(BalanceServiceComponent, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function BalanceServiceComponent.new(o)
    local data = o or {}
    data.balanceService = BalanceService(data)
    return setmetatable(data, BalanceServiceComponentMetatable)
end