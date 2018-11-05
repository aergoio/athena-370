import "aergoio/athena-343"


local suite = TestSuite('App')
system.setItem('account-sender', { abc = 10000 })
suite:add(TestCase('#fixed-amount-token', function()
    function system.getSender()
        return 'sender'
    end
    local balanceServiceComponent = Mixer(BalanceServiceComponent)
    balanceServiceComponent.balanceService:transfer('receiver', 'abc', 1000)
    balanceServiceComponent.balanceService:transfer('receiver', 'abc', 1000)
    balanceServiceComponent.balanceService:transfer('receiver', 'abc', 1000)
end))

suite:add(TestCase('#variable-amount-token', function()
    function system.getSender()
        return 'issuer'
    end
    local tokenSystem = Mixer(BalanceServiceComponent, MintServiceComponent)
    tokenSystem.mintService:issue('TEST', 1000)
    assertEquals(1000, tokenSystem.balanceService:getAmount('issuer', 'TEST'))
    tokenSystem.mintService:issue('TEST', 1000)
    assertEquals(2000, tokenSystem.balanceService:getAmount('issuer', 'TEST'))
end))

suite:add(TestCase('#must-not-permit-to-issue-by-other', function()
    function system.getSender()
        return 'issuer'
    end
    local tokenSystem = Mixer(BalanceServiceComponent, MintServiceComponent)
    tokenSystem.mintService:issue('TEST2', 1000)
    assertEquals(1000, tokenSystem.balanceService:getAmount('issuer', 'TEST2'))
    function system.getSender()
        return 'issuer2'
    end
    tokenSystem.mintService:issue('TEST2', 1000)
end):expected(function(error)
    return string.match(error, 'no authority')
end))

suite:run()
