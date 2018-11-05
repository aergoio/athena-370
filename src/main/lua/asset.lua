--- asset.lua
AssetType = { }
AssetTypeMetatable = { __index = AssetType }
setmetatable(AssetType, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

AssetTypes = {}

function AssetTypes.exists(symbol)
  return nil ~= system.getItem('symbol-' .. symbol)
end

function AssetTypes.register(symbol)
    assert(not AssetTypes.exists(symbol))
    system.setItem('symbol-' .. symbol, symbol)
end

