import "./util.lua"

--- mint.lua
MintService = { }
MintServiceMetatable = { __index = MintService }
setmetatable(MintService, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function MintService.new(parent)
    return setmetatable({ parent = parent },
        MintServiceMetatable)
end

function MintService:totalAmount(assetSymbol)
    if AssetTypes.exists(assetSymbol) then
        local mintInfo = system.getItem('mint-' .. assetSymbol)
        return mintInfo.amount or -1
    else
        return -1
    end
end

function MintService:issue(assetSymbol, amount)
    amount = tonumber(amount)
    assert(0 < amount)
    if not AssetTypes.exists(assetSymbol) then
        AssetTypes.register(assetSymbol)
    end
    local issuer = system.getSender()
    local mintInfo = system.getItem('mint-' .. assetSymbol) or { issuer = issuer, amount = 0 }
    assert(mintInfo.issuer == issuer, 'no authority')

    mintInfo.amount = M.add(mintInfo.amount, amount)
    system.setItem('mint-' .. assetSymbol, mintInfo)

    if self.parent and self.parent.balanceService then
        self.parent.balanceService:receiveFromExternal(issuer, assetSymbol, amount)
    end

end

MintServiceComponent = {}
MintServiceComponentMetatable = { __index = MintServiceComponent }
setmetatable(MintServiceComponent, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function MintServiceComponent.new(o)
    local data = o or {}
    data.mintService = MintService(data)
    return setmetatable(data, MintServiceMetatable)
end
