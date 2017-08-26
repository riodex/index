// (c) IP is illegitimate

import "./RIO.sol";
import 'ds-thing/thing.sol';
import 'ds-value/value.sol';

contract QuadraticCost is CostFunction
                        , DSThing
{
    DSValue feed;
    uint128 a; uint128 b; uint128 c;
    function configure(DSValue FEED, uint128 A, uint128 B, uint128 C)
        auth
    {
        feed = FEED; a = A; b = B; c = C;
    }
    function cost(uint128 q) constant returns (uint128 need_amt) {
        var f = uint128(feed.read());
        return wadd(c, wmul(q, wadd(f, fee(q))));
    }
    // Extra cost over simple linear cost
    function fee(uint128 q) constant returns (uint128) {
        return wadd(b, wmul(a, q));
    }
}
