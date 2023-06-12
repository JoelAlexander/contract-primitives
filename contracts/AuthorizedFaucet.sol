pragma solidity ^0.8.0;

import "./IFaucet.sol";
import "./Authorized.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract AuthorizedFaucet is IFaucet, Authorized {

    using Math for uint;
    using SafeMath for uint;

    uint private constant DISBURSEMENT_FRACTION = 1000000;
    uint private constant DISBURSEMENT_PERIOD_BLOCKS = 14400;

    mapping(address => uint) private canUseFaucetAtBlock;

    constructor(IAuthorizer authorizer) Authorized(authorizer) {}

    function use() public only_authorized {
        require(canUse(msg.sender), "You must wait before using the faucet again");
        canUseFaucetAtBlock[msg.sender] = block.number + DISBURSEMENT_PERIOD_BLOCKS;
        (, uint amount) = balance().tryDiv(DISBURSEMENT_FRACTION);
        payable(msg.sender).transfer(amount);
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }

    function canUseAtBlock(address a) public view returns (uint) {
        return canUseFaucetAtBlock[a];
    }

    function canUse(address a) public view returns (bool) {
        return block.number >= canUseAtBlock(a);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IFaucet).interfaceId || super.supportsInterface(interfaceId);
    }

    function pay() public payable {}

    receive() external payable {}
}
