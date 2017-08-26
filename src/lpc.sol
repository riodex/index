import 'ds-thing/thing.sol';
import 'ds-token/token.sol';
import 'ds-value/value.sol';

import './RIO.sol';

contract LPC is DSThing {
    // caller has dstoken => caller wants dstoken => costFunction
    address vault; // the thing with the coins
    mapping( address =>mapping( address => CostFunction) ) costs;

    // "have, want" from caller's POV
    function look(DSToken have, DSToken want, uint128 wwad)
        constant
        returns (uint128 hwad)
    {
        var c = costs[have][want].cost(have, want, wwad);
    }
    // "have, want" from caller's POV
    function take(DSToken have, DSToken want, uint128 wwad)
        note
    {
        var c = look(have, want, wwad);
        want.move(msg.sender, vault, c);
        have.move(vault, msg.sender, wwad);
    }
    function take(DSToken have, DSToken want, uint128 wwad, uint128 hwad)
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

contract LPCFactory is DSThing {
    mapping(address=>bool) public isLPC;
    function create() returns (LPC) {
        var lpc = new LPC();
        lpc.setOwner(msg.sender);
        isLPC[address(lpc)] = true;
    }
}
