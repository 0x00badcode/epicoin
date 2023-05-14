pragma solidity ^0.8.0;

import "./EpiCoin.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Betting is AccessControl {

    struct Bet {
        address creator;
        uint256 deadline;
        string[] options;
        bool resolved;
        mapping(string => address[]) betters;
        mapping(address => uint256) bets;
        string winningOption;
    }

    EpiCoin public token;
    Bet[] public bets;

    bytes32 public constant BET_RESOLVER_ROLE = keccak256("BET_RESOLVER_ROLE");

    constructor(EpiCoin _token) {
        token = _token;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function createBet(uint256 deadline, string[] memory options) public {
        bets.push(Bet({
            creator: msg.sender,
            deadline: deadline,
            options: options,
            resolved: false
        }));
    }

    function placeBet(uint256 betId, string memory option, uint256 amount) public {
        require(!bets[betId].resolved, "Bet has been resolved");
        require(block.timestamp < bets[betId].deadline, "Bet deadline has passed");

        // transfer the tokens from the bettor to the contract
        token.transferFrom(msg.sender, address(this), amount);

        bets[betId].betters[option].push(msg.sender);
        bets[betId].bets[msg.sender] += amount;
    }

    function resolveBet(uint256 betId, string memory winningOption) public {
        require(hasRole(BET_RESOLVER_ROLE, msg.sender), "Caller is not a bet resolver");
        require(!bets[betId].resolved, "Bet has been resolved");

        bets[betId].resolved = true;
        bets[betId].winningOption = winningOption;

    }

}
