// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "lib/forge-std/src/Vm.sol";
import "src/String.sol";

using { toString } for uint256;

Vm constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

uint256 constant DEFAULT_MAX_LENGTH = 10;

// Error: Variable Name and Slot Length Greater than Max Length
error ArrayOverflow();

// Variable Declaration
struct Variable {
    // Vyper Variable Name
    string name;
    // Vyper Variable Type
    string typ;
    // Storage Slot
    bytes32 slot;
}

// Vyper Storage
struct VyperStorage {
    // Vyper Compiler Path
    string vyperPath;
    // File Path to Compile
    string filePath;
    // Variable Storage Overrides
    Variable[] variables;
    // Current Length of Storage Overrides
    uint256 variablesLength;
}

// Create new Vyper Storage
function newVyperStorage() pure returns (VyperStorage memory) {
    return VyperStorage({
        vyperPath: "vyper",
        filePath: "",
        variables: new Variable[](DEFAULT_MAX_LENGTH),
        variablesLength: 0
    });
}

// Set Max Length
function setMaxLength(
    VyperStorage memory vyperStorage,
    uint32 length
) pure returns (VyperStorage memory) {
    vyperStorage.variables = new Variable[](length);
    return vyperStorage;
}

// Set Vyper Path
function setVyperPath(
    VyperStorage memory vyperStorage,
    string memory path
) pure returns (VyperStorage memory) {
    vyperStorage.vyperPath = path;
    return vyperStorage;
}

// Set File Path
function setFilePath(
    VyperStorage memory vyperStorage,
    string memory path
) pure returns (VyperStorage memory) {
    vyperStorage.filePath = path;
    return vyperStorage;
}

// Assign Variable Name and Slot
function assignSlot(
    VyperStorage memory vyperStorage,
    string memory variableName,
    string memory typ,
    bytes32 slot
) pure returns (VyperStorage memory) {
    uint256 len = vyperStorage.variablesLength;
    if (len >= vyperStorage.variables.length) revert ArrayOverflow();
    vyperStorage.variables[len] = Variable({
        name: variableName,
        typ: typ,
        slot: slot
    });
    vyperStorage.variablesLength += 1;
    return vyperStorage;
}

// Create Storage Layout and Compile
function compile(VyperStorage memory vyperStorage) returns (bytes memory initCode) {
    createStorage(vyperStorage);

    string[] memory compileArgs = new string[](4);
    compileArgs[0] = vyperStorage.vyperPath;
    compileArgs[1] = string.concat(vyperStorage.filePath, ".vy");
    compileArgs[2] = "--storage-layout-file";
    compileArgs[3] = vyperStorage.jsonPath();

    initCode = vm.ffi(compileArgs);
    vm.removeFile(vyperStorage.jsonPath());
}

// Create Storage Layout
function createStorage(VyperStorage memory vyperStorage) {
    string[] memory rmArgs = new string[](2);
    rmArgs[0] = "touch";
    rmArgs[1] = vyperStorage.jsonPath();
    vm.ffi(rmArgs);

    vm.writeFile(vyperStorage.jsonPath(), vyperStorage.toJson());
}

// Create Vyper Storage JSON Path
function jsonPath(VyperStorage memory) pure returns (string memory path) {
    return string.concat(".temp_vyper_storage.json");
}

// Convert Vyper Storage to JSON
function toJson(VyperStorage memory vyperStorage) pure returns (string memory json) {
    uint256 len = vyperStorage.variables.length;

    uint256 i;
    while (i < len) {
        if (bytes(vyperStorage.variables[i].name).length == 0) break;

        // "<variableName>":<slot>,
        json = string.concat(
            json,
            i == 0 ? '"' : ',"',
            vyperStorage.variables[i].name,
            '":{',
            '"type":"',
            vyperStorage.variables[i].typ,
            '","slot":',
            toString(uint256(vyperStorage.variables[i].slot)),
            "}"
        );
        i += 1;
    }
    // { "variableName": slot, ... }
    return string.concat("{", json, "}");
}

using {
    setMaxLength,
    setVyperPath,
    setFilePath,
    assignSlot,
    compile,
    jsonPath,
    toJson
} for VyperStorage global;
