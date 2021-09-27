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

	uint256 public listings;
	uint256 public registrationFee;

	mapping(uint256 => TokenSale) public listedTokens;
	mapping(address => bool) public tokenWhitelist;

	bytes32 public constant TOKEN_MANAGER = keccak256('TOKEN_MANAGER');
	bytes32 public constant FUNDS_MANAGER = keccak256('FUNDS_MANAGER');

	event tokenListed(address seller, ERC20 sellToken, ERC20 buyToken, uint256 amount, uint256 price, uint256 indexed listingId);
	event tokenPurchased(address seller, ERC20 sellToken, ERC20 buyToken, uint256 amount, uint256 price, uint256 indexed listingId);

	constructor(address payable _superAdmin)
	{
		listings = 0;
		registrationFee = 20000000000000000;
		_setupRole(DEFAULT_ADMIN_ROLE, _superAdmin);
		superAdmin = _superAdmin;
	}

	// Allows adding of a token to the whitelist in exchange for eth
	function whiteListToken(address token) public payable
	{
		require(!tokenWhitelist[token], "Token already whitelisted");
		require(msg.value == registrationFee, "Must send registration fee of .02 ETH");
		tokenWhitelist[token] = true;
	}

	function collectRegistrationFees() public onlyRole(FUNDS_MANAGER)
	{
		payable(msg.sender).transfer(address(this).balance);
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
	// pricePerToken is price of 1 unit of sellToken expressed in units of buyToken
	function listToken(address sellToken, address buyToken, uint256 amountToSell, uint256 pricePerToken) public
	{
		require(tokenWhitelist[sellToken] && tokenWhitelist[buyToken], "Both sell and buy tokens must be whitelisted");
		ERC20(sellToken).transferFrom(msg.sender, address(this), amountToSell);
        TokenSale memory newSale = TokenSale({seller:payable(msg.sender), sellToken:ERC20(sellToken), buyToken:ERC20(buyToken), 
        	amount:amountToSell, price:pricePerToken});
        listedTokens[listings] = newSale;
        listings += 1;
	}

	// Allows seller of a token to cancel a listing
	function cancelListing(uint256 listingId) public
	{
		TokenSale memory listing = listedTokens[listingId];
		require(msg.sender == listing.seller, "Caller must be the original creator of listing");
		// Give amount of sellToken back to seller
		listing.sellToken.transfer(listing.seller, listing.amount);
		// Set the listing amount to 0
		listedTokens[listingId].amount = 0;
	}

	// Allows a buyer to purchase part or all of a token listing
	function purchaseToken(uint256 listingId, uint256 amountToBuy) public
	{
		TokenSale memory listing = listedTokens[listingId];
		require(amountToBuy <= listing.amount, "Purchase amount cannot exceed listing amount");

		// Buyer pays lister for the tokens
		listing.buyToken.transferFrom(msg.sender, listing.seller, amountToBuy * listing.price);
		// Buyer receives tokens from contract
		listing.sellToken.transfer(msg.sender, amountToBuy);
		// Listing amount is decreased by amount bought
		listedTokens[listingId].amount -= amountToBuy;
	}
}
