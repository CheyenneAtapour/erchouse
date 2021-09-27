// SPDX-License-Identifier: Unlicense

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract ERCHouse is AccessControl
{
	address payable superAdmin;

	struct TokenSale{
		address payable seller;
		ERC20 sellToken;
		ERC20 buyToken;
		uint256 amount;
		uint256 price;
	}

	uint256 listings;
	mapping(uint256 => TokenSale) public listedTokens;
	mapping(address => bool) public tokenWhitelist;

	bytes32 public constant TOKEN_MANAGER = keccak256('TOKEN_MANAGER');

	event tokenListed(address seller, ERC20 sellToken, ERC20 buyToken, uint256 amount, uint256 price, uint256 indexed listingId);
	event tokenPurchased(address seller, ERC20 sellToken, ERC20 buyToken, uint256 amount, uint256 price, uint256 indexed listingId);

	constructor(address payable _superAdmin)
	{
		listings = 0;
		_setupRole(DEFAULT_ADMIN_ROLE, _superAdmin);
		superAdmin = _superAdmin;
	}

	// Adds a token to the token whitelist
	function addToken(address token) public onlyRole(TOKEN_MANAGER)
	{
		require(!tokenWhitelist[token], "Token already whitelisted");
		tokenWhitelist[token] = true;
	}

	// Removes a token from the token whitelist
	function removeToken(address token) public onlyRole(TOKEN_MANAGER)
	{
		require(tokenWhitelist[token], "Token not whitelisted");
		tokenWhitelist[token] = false;
	}

	// Allows seller of a token to create a listing
	function listToken() public
	{

	}

	// Allows seller of a token to cancel a listing
	function cancelListing() public
	{

	}

	// Allows a buyer to purchase part or all of a token listing
	function purchaseToken() public
	{

	}
}
