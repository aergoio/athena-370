import "aergoio/athena-343"

local suite = TestSuite('util')
suite:add(TestCase('#Sequence', function()
    local seq = Sequence('test')
    assertNotNull(seq:next())
end))

suite:run()
