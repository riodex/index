import 'ds-thing/thing.sol';

// direct-owned by LiquidContainer
// non-0 balance exists only in a sub-call to LiquidContainer
contract Liquid is DSToken {
    address public lad;
    uint128 public owe;
    function lend(uint128 amt) {
        require(msg.sender == lad);
        owe = wadd(owe, amt);
        this.mint(amt);
    }
    function mend(uint128 amt) {
        require(msg.sender == lad);
        owe = wsub(owe, amt);
        this.burn(amt);
    }
    function flow(address who)
        auth
    {
        lad = who;
        flowing = true;
    }
    function plug()
        auth
    {
        lad = 0;
        flowing = false;
    }
}

contract LiquidContainer is DSAuth
{
    Liquid liq;
    uint128 fee;
    function LiquidContainer() {
        liq = new Liquid();
    }
    function flood(address code, bytes data) {
        var bef = liq.size();
        liq.flow(msg.sender);
        code.call(data);
        liq.plug();
        var aft = liq.size();
        require( aft >= wadd(bef, fee) );
    }
    function leak()
        auth
    {
        liq.mint(now);
    }
}
