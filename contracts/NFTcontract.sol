// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

//importation of ERC1155 contract from openzeppelin
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTcontract is ERC1155, Ownable {

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping from token ID to account balances
    mapping(uint256 => mapping(address => uint256)) private _balances;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     *setting the contructor and calling that of ERC1155
     */
    constructor(address owner) ERC1155("ipfs://QmRZGcLzNLw4e5B8ZbtDTQoGjvoSjp3kZgKDenvFKBg2t3/{id}.json") {
        mint(owner, 1, 10);
        mint(owner, 2, 10);
        mint(owner, 3, 10);
        mint(owner, 4, 10);
    }

    function exists(uint256 tokenId) public returns (bool) {
        if(_owners[tokenId] != address(0)) {
            return true;
        }
        else{
            return false;
        }
    }

    // function to Buy the NFTs
    function buyNFT(uint tokenId) payable public {
        uint price1 = 1 * (10 ** 18);
        uint price2 = 5 * (10 ** 18);
        uint price3 = 10 * (10 ** 18);
        uint price4 = 20 * (10 ** 18);
        if(tokenId == 1){
            require(msg.value == price1, "The amount is insufficient");
            mint(msg.sender, 1, 1);
        }
        else if(tokenId == 2){
            require(msg.value == price2, "The amount is insufficient");
            mint(msg.sender, 2, 1);
        }
        else if(tokenId == 3){
            require(msg.value == price3, "The amount is insufficient");
            mint(msg.sender, 3, 1);
        }
        else if(tokenId == 4){
            require(msg.value == price4, "The amount is insufficient");
            mint(msg.sender, 4, 1);
        }
    }

    function mint(address account, uint256 id, uint256 amount) internal {
        _mint(account, id, amount, "");
        _balances[id][account] += amount;
        _owners[id] = account;
    }

    function _safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) internal virtual {
        require(to != address(0), "ERC1155: transfer to the zero address");
        _owners[id] = to;
        uint256 fromBalance = _balances[id][from];
        require(fromBalance >= 1, "ERC1155: insufficient balance for transfer");
        unchecked {
            _balances[id][from] = fromBalance - 1;
        }
        _balances[id][to] += 1;

    }

    /**
     * @dev See {IERC1155-balanceOf}.
     */
    function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
        require(account != address(0), "ERC1155: address zero is not a valid owner");
        return _balances[id][account];
    }


    // function to transfer NFT
      function transferFrom(
      address from,
      address to,
      uint tokenId
    ) public returns (bool success) {
        _safeTransferFrom(from, to, tokenId);
        return success;
    }

}
