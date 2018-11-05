import "./util.lua"

Transaction = { }
TransactionMetatable = { __index = Transaction }
setmetatable(Transaction, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function Transaction.new(type, sender, receiver, assetType, amount)
    setmetatable({
        type = type,
        sender = sender,
        receiver = receiver,
        assetType = assetType,
        amount = amount
    }, TransactionMetatable)
end


HistoryService = {}
HistoryServiceMetatable = { __index = HistoryService }
setmetatable(HistoryService, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})
function HistoryService.new(parent)
    return setmetatable(
        { parent = parent, sequence = Sequence('history') },
        HistoryServiceMetatable)
end

function HistoryService:record(transaction)
    system.setItem('history-' .. self.sequence:next(), transaction)
end

HistoryServiceComponent = {}
HistoryServiceComponentMetatable = { __index = HistoryServiceComponent }
setmetatable(HistoryServiceComponent, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function HistoryServiceComponent.new(o)
    local data = o or {}
    data.historyService = HistoryService(data)
    return setmetatable(data, HistoryServiceComponentMetatable)
end