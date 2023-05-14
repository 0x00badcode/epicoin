pragma solidity ^0.8.0;

import "./ERC20.sol";
import "@openzeppelin/contracts/access/Roles.sol";

contract EpiCoin is ERC20 {
    using Roles for Roles.Role;

    Roles.Role private _admins;

    constructor(address[] memory admins)
        ERC20("EpiCoin", "EPI")
    {
        for (uint256 i; i < admins.length; ++i) {
            _admins.add(admins[i]);
        }
    }

    function mint(address to, uint256 amount) public {
        require(_admins.has(msg.sender), "EpiCoin: must have admin role to mint");
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        require(_admins.has(msg.sender), "EpiCoin: must have admin role to burn");
        _burn(from, amount);
    }
}
