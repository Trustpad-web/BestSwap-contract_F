pragma solidity =0.5.16;

import '../BestSwapERC20.sol';

contract ERC20 is BestSwapERC20 {
    constructor(uint _totalSupply) public {
        _mint(msg.sender, _totalSupply);
    }
}
