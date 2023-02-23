// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "src/Lib.sol";
import "lib/forge-std/src/Test.sol";

contract VyperStorageTest is Test {
    bytes32 implSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 beaconSlot = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
    bytes32 adminSlot = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    function testJsonPath() external {
        VyperStorage memory vyperStorage = newVyperStorageBuilder()
            .filePath("test/mock/ERC1967Proxy")
            .build();

        assertEq(vyperStorage.jsonPath(), ".temp_vyper_storage.json");
    }

    function testToJson() external {
        VyperStorage memory vyperStorage = newVyperStorageBuilder()
            .assignSlot("test", "uint256", bytes32(uint256(1)))
            .build();

        assertEq(vyperStorage.toJson(), '{"test":{"type":"uint256","slot":1}}');
    }

    function testCompile() external {
        VyperStorage memory vyperStorage = newVyperStorageBuilder()
            .filePath("test/mock/ERC1967Proxy")
            .assignSlot("implementation", "address", implSlot)
            .assignSlot("beacon", "address", beaconSlot)
            .assignSlot("admin", "address", adminSlot)
            .build();

        string memory jsonPath = vyperStorage.jsonPath();

        console.logBytes32(keccak256(vyperStorage.compile()));
    }
}
