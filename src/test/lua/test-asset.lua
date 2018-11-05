import "aergoio/athena-343"

local suite = TestSuite('asset')
suite:add(TestCase('#register', function()
  AssetTypes.register("TEST")
  assertTrue(AssetTypes.exists("TEST"))
end))

suite:add(TestCase('#issue', function()

end))

suite:run()