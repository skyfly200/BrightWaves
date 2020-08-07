//SPDX-License-Identifier: Unlicensed
pragma solidity ^0.6.8;

//import "@openzeppelin/upgrades/contracts/Initializable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/access/Ownable.sol";
import "@openzeppelin/contracts-ethereum-package/contracts/utils/Counters.sol";

contract BrightWaves is ERC721UpgradeSafe, OwnableUpgradeSafe {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;
    Counters.Counter public _collectionCount;

    event NewCollection(uint256 id, string title);

    struct Collection {
        string title;
        uint256 count;
    }

    struct Artwork {
        string hash;
        uint256 collection;
    }

    // mapping to store art IPFS hashes
    mapping(uint256 => Artwork) internal artwork;
    mapping(uint256 => Collection) internal collections;

    /**
     * @dev Contract constructor.
     * @notice Constructor inherits ERC721
     */
    // constructor(string memory baseURI) public ERC721("Bright Waves", "~BW~") {
    //     _setBaseURI(baseURI);
    // }

    /**
     * @dev Contract initializer.
     * @notice Constructor inherits ERC721 and Initializable
     */
    function initialize(string memory baseURI) public initializer {
        __ERC721_init_unchained("Bright Waves", "~BW~");
        // ERC721UpgradeSafe.initialize("Bright Waves", "~BW~");
        // OwnableUpgradeSafe.initialize();
        //_setBaseURI(baseURI);
    }

    // create a new collection
    function newCollection(string calldata title)
        external
        onlyOwner()
        returns (uint256)
    {
        _collectionCount.increment();
        uint256 id = _collectionCount.current();
        collections[id] = Collection(title, 0);
        emit NewCollection(id, title);
        return id;
    }

    // mint a piece of artwork
    function mintArtwork(
        string calldata uri,
        string calldata hash,
        uint256 collection
    ) external onlyOwner() returns (uint256) {
        // check the collection exists
        require(
            (collection > 0 && collection <= _collectionCount.current()),
            "Nonexistant Collection ID"
        );
        uint256 id = _tokenIds.current();
        artwork[id] = Artwork(hash, collection);
        _safeMint(msg.sender, id);
        _tokenIds.increment();
        collections[collection].count++;
        _setTokenURI(id, uri);
        return id;
    }

    // get artwork
    function getArtwork(uint256 id)
        external
        view
        returns (string memory, uint256)
    {
        Artwork memory a = artwork[id];
        return (a.hash, a.collection);
    }

    // get collection
    function getCollection(uint256 id)
        external
        view
        returns (string memory, uint256)
    {
        Collection memory c = collections[id];
        return (c.title, c.count);
    }
}
