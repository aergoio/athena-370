import java.util.UUID

import org.scalatest.FunSuite

class BalanceTest extends FunSuite
  with MintServiceComponent
  with BalanceServiceComponent
  with HistoryServiceComponent
  with AergoComponent {

  test("BalanceServiceComponent#transferTo") {
    val symbol = UUID.randomUUID().toString
    mintService.issue(symbol, 10000)
    val sender = aergo.executor
    val receiver = UUID.randomUUID().toString
    balanceService.transfer(sender, receiver, symbol, 300)
    balanceService.get(sender, symbol)
  }

}
