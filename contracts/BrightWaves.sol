//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.6.8;

// needed for upgradability
//import "@openzeppelin/upgrades/contracts/Initializable.sol";

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract BrightWaves is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter public _collectionCount;

    event NewCollection(uint256 id, string title, string description);

    struct Collection {
        string title;
        string description;
        uint256 count;
    }

    struct Artwork {
        string hash;
        string title;
        string description;
        uint256 collection;
    }

    // mapping to store art IPFS hashes
    mapping(uint256 => Artwork) internal artwork;
    mapping(uint256 => Collection) internal collections;

    /**
     * @dev Contract constructor.
     * @notice Constructor inherits ERC721
     */
    constructor(string memory baseURI) public ERC721("Bright Waves", "~~~") {
        _setBaseURI(baseURI);
    }

    // create a new collection
    function newCollection(string calldata title, string calldata description)
        external
        onlyOwner()
        returns (uint256)
    {
        _collectionCount.increment();
        uint256 id = _collectionCount.current();
        collections[id] = Collection(title, description, 0);
        emit NewCollection(id, title, description);
        return id;
    }

    // mint a piece of artwork
    function mintArtwork(
        string calldata uri,
        string calldata hash,
        string calldata title,
        string calldata description,
        uint256 collection
    ) external onlyOwner() returns (uint256) {
        // check the collection exists
        require(
            (collection > 0 && collection < _collectionCount.current()),
            "Nonexistant Collection ID"
        );
        uint256 id = _tokenIds.current();
        _tokenIds.increment();
        collections[collection].count++;
        artwork[id] = Artwork(hash, title, description, collection);
        _safeMint(msg.sender, id);
        _setTokenURI(id, uri);
        return id;
    }

    // get artwork
    function getArtwork(uint256 id)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            uint256 collection
        )
    {
        Artwork memory a = artwork[id];
        return (a.hash, a.title, a.description, a.collection);
    }

    // get collection
    function getCollection(uint256 id)
        external
        view
        returns (
            string memory,
            string memory,
            uint256
        )
    {
        Collection memory c = collections[id];
        return (c.title, c.description, c.count);
    }
}
