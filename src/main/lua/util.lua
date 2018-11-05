------------------------------------------------------------------------------
-- Safe maths
------------------------------------------------------------------------------
local M = {}

function M.add(a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end

    local c = a + b
    assert(c >= a, "number overflow")

    return c
end

function M.sub(a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end

    assert(b <= a, "first value must be bigger than second one")
    local c = a - b

    return c
end

function M.mul(a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end

    local c = a * b
    assert(a == 0 or c/a == b, "number overflow")

    return c
end

function M.div(a, b)
    if a == nil then a = 0 end
    if b == nil then b = 0 end

    assert(b > 0, "second value must be bigger than 0")
    c = a / b

    return c
end


Mixer = {}
MixerMetatable = { __index = Mixer }
setmetatable(Mixer, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function Mixer.new(...)
    local r = {}
    for k, v in ipairs{...} do
        r = v.new(r)
    end
    return r
end


Sequence = {}
SequenceMetatable = { __index = Sequence }
setmetatable(Sequence, {
    __call = function(cls, ...)
        return cls.new(...)
    end
})

function Sequence.new(name)
    return setmetatable({name = 'sequence-' .. name}, SequenceMetatable)
end

function Sequence:next()
    local currentSequence = system.getItem(self.name)
    if (nil == currentSequence) then
        currentSequence = 0
    end
    local nextSequence = currentSequence + 1
    system.setItem(self.name, nextSequence)
    return nextSequence;
end