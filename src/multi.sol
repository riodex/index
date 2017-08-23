import 'ds-token/token.sol';

contract PullBids {
    struct Bid {
        address owner;
        DSToken have;
        uint128 have_wad;
        DSToken want;
        uint128 want_wad;
    }
    Bid[] public bids;
    function make(DSToken have, uint128 hwad, DSToken want, uint128 wwad) returns (uint256 bid) {
        return bids.push(Bid({
            owner: msg.sender,
            have: have,
            have_wad: hwad,
            want: want,
            want_wad: wwad
        })) - 1;
    }
    function take(uint128 bid) {
        var B = bids[bid];
        B.have.move(B.owner, msg.sender, B.have_wad);
        B.want.move(msg.sender, B.owner, B.want_wad);
    }
    // Convienience
    function look(uint128 bid) returns (bool) {
        var B = bids[bid];
        var deps = B.have.deps(B.owner, this);
        var enuf = B.have.bals(B.owner) >= bid;
        return (deps && enuf);
    }
}
