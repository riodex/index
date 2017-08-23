import 'ds-thing/thing.sol';
import 'ds-token/token.sol';

contract Example1 is CostFunction {
    DSValue public feed;
    uint128 public fee; // % wad fee
    function Example1(DSValue feed_, uint128 fee_) {
        feed = feed_;
        fee = fee_;
    }
    function cost(uint128 want_amt) constant returns (uint need_amt) {
        var price = feed.read();
        var cost = wmul(price, want_amt);
        var fee = wdiv(cost, fee);
        var total = wadd(cost, fee);
        return total;
    }
}
contract CostFunction {
    // can use `now`
    function cost(uint128 want_amt) constant returns (uint128 need_amt);
}

contract LPC is DSThing {
    // caller has dstoken => caller wants dstoken => costFunction
    mapping( address =>mapping( address => CostFunction) ) costs;

    // "have, want" from caller's POV
    function look(DSToken have, DSToken want, uint128 wwad)
        constant
        returns (uint128 hwad)
    {
        var c = costs[have][want].cost(wwad);
    }
    // "have, want" from caller's POV
    function take(DSToken have, DSToken want, uint128 wwad)
        note
    {
        var c = costs[have][want].cost(wwad);
        have.pull(msg.sender, c);
        want.push(msg.sender, c);
    }
    function takeSafe(DSToken have, DSToken want, uint128 wwad, uint128 hwad)
        // note: `take` notes
    {
        var cost = look(have, want, wwad);
        require(cost <= hwad);
        take(have, want, wwad);
    }
    function make(DSToken have, DSToken want, CostFunction cost)
        auth
        note
    {
        costs[have][want] = cost;
    }
}
