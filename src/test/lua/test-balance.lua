import "aergoio/athena-343"

function system.getSender()
    return 'sender'
end

local suite = TestSuite('balance')
suite:add(TestCase('#transfer', function()
    system.setItem('account-sender', { aaa = 10000 })
    local balanceServiceComponent = Mixer(BalanceServiceComponent)
    balanceServiceComponent.balanceService:transfer('receiver', 'aaa', '100')
end))

suite:add(TestCase('#transferWithHistory', function()
    system.setItem('account-sender', { def = 10000 })
    local balanceServiceComponent = Mixer(HistoryServiceComponent, BalanceServiceComponent)
    balanceServiceComponent.balanceService:transfer('receiver', 'def', 100)
    assertEquals(2, balanceServiceComponent.historyService.sequence:next())
end))

suite:add(TestCase('#insufficient', function()
    system.setItem('account-insufficient', { xyz = 100 })
    function system.getSender()
        return 'insufficient'
    end
    local balanceServiceComponent = Mixer(BalanceServiceComponent)
    balanceServiceComponent.balanceService:transfer('receiver', 'xyz', 1000)
end):expected(function(error)
    return string.match(error, 'insufficient balance')
end))

suite:run()
