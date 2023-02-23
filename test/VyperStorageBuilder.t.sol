// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "src/Lib.sol";
import "lib/forge-std/src/Test.sol";

contract VyperStorageBuilderTest is Test {
    function testNewVyperStorageBuilder() external {
        VyperStorageBuilder memory builder = newVyperStorageBuilder();

        assertEq(builder.length, 0);
        assertEq(builder.vyperStorage.vyperPath, "vyper");
        assertEq(builder.vyperStorage.filePath, "");
        assertEq(builder.vyperStorage.variables.length, 10);
    }

    function testMaxLength() external {
        VyperStorageBuilder memory builder = newVyperStorageBuilder().maxLength(20);

        assertEq(builder.length, 0);
        assertEq(builder.vyperStorage.vyperPath, "vyper");
        assertEq(builder.vyperStorage.filePath, "");
        assertEq(builder.vyperStorage.variables.length, 20);
    }

    function testVyperPath() external {
        VyperStorageBuilder memory builder = newVyperStorageBuilder().vyperPath("vyper2");

        assertEq(builder.length, 0);
        assertEq(builder.vyperStorage.vyperPath, "vyper2");
        assertEq(builder.vyperStorage.filePath, "");
        assertEq(builder.vyperStorage.variables.length, 10);
    }

    function testFilePath() external {
        VyperStorageBuilder memory builder = newVyperStorageBuilder().filePath("test");

        assertEq(builder.length, 0);
        assertEq(builder.vyperStorage.vyperPath, "vyper");
        assertEq(builder.vyperStorage.filePath, "test");
        assertEq(builder.vyperStorage.variables.length, 10);
    }

    function testAssignSlot() external {
        VyperStorageBuilder memory builder = newVyperStorageBuilder()
            .assignSlot("test", "uint256", bytes32(uint256(1)));

        assertEq(builder.length, 1);
        assertEq(builder.vyperStorage.vyperPath, "vyper");
        assertEq(builder.vyperStorage.filePath, "");
        assertEq(builder.vyperStorage.variables.length, 10);
        assertEq(builder.vyperStorage.variables[0].name, "test");
        assertEq(builder.vyperStorage.variables[0].typ, "uint256");
        assertEq(builder.vyperStorage.variables[0].slot, bytes32(uint256(1)));
    }

    function testAssignSlotOverflow() external {
        vm.expectRevert();
        VyperStorageBuilder memory builder = newVyperStorageBuilder()
            .maxLength(1)
            .assignSlot("test", "uint256", bytes32(uint256(1)))
            .assignSlot("test2", "uint256", bytes32(uint256(2)));

        assertEq(builder.length, 2);
        assertEq(builder.vyperStorage.variables.length, 10);
        assertEq(builder.vyperStorage.variables[0].name, "test");
        assertEq(builder.vyperStorage.variables[0].typ, "uint256");
        assertEq(builder.vyperStorage.variables[0].slot, bytes32(uint256(1)));
        assertEq(builder.vyperStorage.variables[1].name, "test2");
        assertEq(builder.vyperStorage.variables[1].typ, "uint256");
        assertEq(builder.vyperStorage.variables[1].slot, bytes32(uint256(2)));
    }

    function testBuild() external {
        VyperStorage memory vyperStorage = newVyperStorageBuilder()
            .assignSlot("test", "uint256", bytes32(uint256(1)))
            .build();

        assertEq(vyperStorage.vyperPath, "vyper");
        assertEq(vyperStorage.filePath, "");
        assertEq(vyperStorage.variables[0].name, "test");
        assertEq(vyperStorage.variables[0].typ, "uint256");
        assertEq(vyperStorage.variables[0].slot, bytes32(uint256(1)));
    }
}
