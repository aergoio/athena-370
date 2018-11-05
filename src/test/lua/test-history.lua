import "aergoio/athena-343"

function system.getSender()
    return 'executor'
end

local suite = TestSuite('history')
suite:add(TestCase('#new', function()
    local historyServiceComponent = Mixer(HistoryServiceComponent)
    assertNotNull(historyServiceComponent.historyService)
end))

suite:add(TestCase('#record', function()
    AssetTypes.register('ASSET_NAME')
    local historyServiceComponent = Mixer(HistoryServiceComponent)
    local tx = Transaction(1, 'sender', 'receiver', 'ASSET_NAME', 100)
    historyServiceComponent.historyService:record(tx)
    assertEquals(2, historyServiceComponent.historyService.sequence:next())
end))

suite:run()
