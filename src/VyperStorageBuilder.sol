// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "src/VyperStorage.sol";

// Error: Variable Name and Slot Length Greater than Max Length
error ArrayOverflow();

// Vyper Storage Builder
struct VyperStorageBuilder {
    VyperStorage vyperStorage;
    uint32 length;
}

// Default Max Length
uint32 constant DEFAULT_MAX_LENGTH = 10;

// Initialize Vyper Storage Builder
function newVyperStorageBuilder() pure returns (VyperStorageBuilder memory builder) {
    return VyperStorageBuilder({
        vyperStorage: VyperStorage({
            vyperPath: "vyper",
            filePath: "",
            variables: new Variable[](DEFAULT_MAX_LENGTH)
        }),
        length: 0
    });
}

// Set Max Length
function maxLength(
    VyperStorageBuilder memory builder,
    uint32 length
) pure returns (VyperStorageBuilder memory) {
    builder.vyperStorage.variables = new Variable[](length);
    return builder;
}

// Set Vyper Path
function vyperPath(
    VyperStorageBuilder memory builder,
    string memory path
) pure returns (VyperStorageBuilder memory) {
    builder.vyperStorage.vyperPath = path;
    return builder;
}

// Set File Path
function filePath(
    VyperStorageBuilder memory builder,
    string memory path
) pure returns (VyperStorageBuilder memory) {
    builder.vyperStorage.filePath = path;
    return builder;
}

// Assign Variable Name and Slot
function assignSlot(
    VyperStorageBuilder memory builder,
    string memory variableName,
    string memory variableType,
    bytes32 slot
) pure returns (VyperStorageBuilder memory) {
    uint32 length = builder.length;
    if (length >= builder.vyperStorage.variables.length) revert ArrayOverflow();
    builder.vyperStorage.variables[length] = Variable({
        name: variableName,
        typ: variableType,
        slot: slot
    });
    builder.length = length + 1;
    return builder;
}

// Build Vyper Storage
function build(VyperStorageBuilder memory builder) pure returns (VyperStorage memory) {
    return builder.vyperStorage;
}

using {
    maxLength,
    vyperPath,
    filePath,
    assignSlot,
    build
} for VyperStorageBuilder global;
