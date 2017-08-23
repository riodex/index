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
            msg.sender, have, hwad, want, wwad
        })) - 1;
    }
    function take(uint256 bid) {
        var B = bids[bid];
        B.have.move(owner, msg.sender, B.have_wad);
        B.want.move(msg.sender, owner, B.want_wad);
    }
    // Convienience
    function look(uint256 bid) returns (bool) {
        var B = bids[bid];
        var approves = B.have.allowance(B.owner, this);
        var bal = B.have.balanceOf(B.owner);
        var has = B.have_wad;
        return ( bal >= has && approves >= has );
    }
}
