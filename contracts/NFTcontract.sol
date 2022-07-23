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
    constructor() ERC1155("https://ipfs.infura.io/ipfs/QmTCWCMvbNqqB2ZfASEodUffEtMuvvNYTNfFvbSyy3aN14") {
        for (uint i = 0; i < 1000; i++) {
            mint(msg.sender, 1, i);
        }
    }

    function exists(uint256 tokenId) public returns (bool) {
        if(_owners[tokenId] != address(0)) {
            return true;
        }
        else{
            return false;
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

    /**
     * @dev See {IERC1155-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual returns (address owner) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC1155: owner query for nonexistent token");
        return owner;
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
