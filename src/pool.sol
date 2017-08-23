import 'ds-thing/thing.sol';

// direct-owned by LiquidContainer
// non-0 balance exists only in a sub-call to LiquidContainer
contract Liquid is DSToken {
    address container;
    address user;
    bool flowing;
    function flow() auth
    {
        flowing = true;
    }
    function plug() auth
    {
        flowing = false;
    }
}

contract LiquidContainer {
    Liquid liq;
    uint128 fee;
    function LiquidContainer() {
        // start as Liquid owner
        liq = new Liquid();
    }
    function flood(address code, bytes data) {
        var bef = liq.size();
        liq.flow();
        code.call(data);
        liq.plug();
        var aft = liq.size();
        require( aft >= bef );
    }
}

contract Pool {
    DSToken gem;
    DSToken share;
    uint128 fee;

    function exec(address code, bytes data)
        note
    {
        var bal = gem.bals(this);
        gem.push(who);
        code.call(data);
        require(gem.bals(this) >= bal + fee);
    }

    function join(uint128 amt)
        note
    {
    }

    function exit(uint128 amt)
        note
    {
    }
}
