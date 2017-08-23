import 'ds-thing/thing.sol';

contract CostFunction {
    function cost(uint128 want_amt) returns (uint128 need_amt);
}

contract LPC {
    CostFunction public costFunc;
    // "have, want" from caller's POV
    function buy(DSToken have, DSToken want, uint128 wwad)
        note
    {
        var c = costFunc.cost(wwad);
        have.pull(msg.sender, c);
        want.push(msg.sender, c);
    }

}
