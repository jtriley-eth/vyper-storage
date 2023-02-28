// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "src/Lib.sol";
import "lib/forge-std/src/Test.sol";

contract VyperStorageTest is Test {
    bytes32 implSlot = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
    bytes32 beaconSlot = 0xa3f0ad74e5423aebfd80d3ef4346578335a9a72aeaee59ff6cb3582b35133d50;
    bytes32 adminSlot = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    bytes32 initcodeHash = 0x86393f9d9fc0a868d15f23efc33e8a3da56540ef6fc307846990b05e62e9d87b;

    function testNewVyperStorage() external {
        VyperStorage memory vyperStorage = newVyperStorage();

        assertEq(vyperStorage.vyperPath, "vyper");
        assertEq(vyperStorage.filePath, "");
        assertEq(vyperStorage.variablesLength, 0);
    }

    function testSetMaxLength() external {
        VyperStorage memory vyperStorage = newVyperStorage().setMaxLength(1);

        assertEq(vyperStorage.variables.length, 1);
    }

    function testSetVyperPath() external {
        VyperStorage memory vyperStorage = newVyperStorage().setVyperPath("test");

        assertEq(vyperStorage.vyperPath, "test");
    }

    function testSetFilePath() external {
        VyperStorage memory vyperStorage = newVyperStorage().setFilePath("test");

        assertEq(vyperStorage.filePath, "test");
    }

    function testAssignSlot() external {
        VyperStorage memory vyperStorage = newVyperStorage()
            .assignSlot("test", "uint256", bytes32(uint256(1)));

        assertEq(vyperStorage.variablesLength, 1);
        assertEq(vyperStorage.variables[0].name, "test");
        assertEq(vyperStorage.variables[0].typ, "uint256");
        assertEq(vyperStorage.variables[0].slot, bytes32(uint256(1)));
    }

    function testJsonPath() external {
        VyperStorage memory vyperStorage = newVyperStorage().setFilePath("test/mock/ERC1967Proxy");

        assertEq(vyperStorage.jsonPath(), ".temp_vyper_storage.json");
    }

    function testToJson() external {
        VyperStorage memory vyperStorage = newVyperStorage()
            .assignSlot("test", "uint256", bytes32(uint256(1)));

        assertEq(vyperStorage.toJson(), '{"test":{"type":"uint256","slot":1}}');
    }

    function testCompile() external {
        bytes memory initcode = newVyperStorage()
            .setFilePath("test/mock/ERC1967Proxy")
            .assignSlot("implementation", "address", implSlot)
            .assignSlot("beacon", "address", beaconSlot)
            .assignSlot("admin", "address", adminSlot)
            .compile();

        assertEq(keccak256(initcode), initcodeHash);
    }
}
