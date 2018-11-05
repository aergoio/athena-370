import java.util.UUID

import org.scalatest.FunSuite

class MintTest extends FunSuite
  with MintServiceComponent
  with BalanceServiceComponent
  with HistoryServiceComponent
  with AergoComponent {

  test("MintService#issue") {
    val symbol = UUID.randomUUID().toString
    mintService.issue(symbol, 1000)
    val amount = balanceService.get(Account(aergo.executor, symbol))
    assert(amount === 1000)
  }

  test("MintService#issue should throw exception") {
    val symbol = UUID.randomUUID().toString
    mintService.issue(symbol, 1000)
    intercept[IllegalArgumentException] {
      mintService.issue(symbol, 1000)
    }
  }
}