// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "lib/forge-std/src/Vm.sol";
import "src/String.sol";

using { toString } for uint256;

Vm constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

// Variable Declaration
struct Variable {
    string name;
    string typ;
    bytes32 slot;
}

// Vyper Storage
struct VyperStorage {
    string vyperPath;
    string filePath;
    Variable[] variables;
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

using { compile, jsonPath, toJson } for VyperStorage global;
