import "aergoio/athena-343"


local suite = TestSuite('mint')
suite:add(TestCase('#new', function()
  local mintServiceComponent = Mixer(MintServiceComponent)
  assertNotNull(mintServiceComponent.mintService)
end))


suite:add(TestCase('#issue', function()
  system.getSender = function()
    return 'executor'
  end

  local mintService = MintService()
  mintService:issue("TEST", 10000)
  assertTrue(AssetTypes.exists("TEST"))
  assertTrue(10000 == mintService:totalAmount("TEST"))
end))

suite:add(TestCase('#issueWithStringAmount', function()
  system.getSender = function()
    return 'executor'
  end

  local mintService = MintService()
  mintService:issue('T2', '10000')
  assertTrue(AssetTypes.exists('T2'))
  assertEquals(10000, mintService:totalAmount('T2'))
end))


suite:run()