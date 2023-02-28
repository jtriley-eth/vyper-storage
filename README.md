# Vyper Storage

## Showcase

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "vyper-storage/Lib.sol";

// -- snip --

bytes32 implSlot = bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1);

bytes memory initCode = newVyperStorage()
    .filePath("src/ERC1967Proxy")
    .assignSlot("implementation", "address", implSlot)
    .compile();
```

## About

This is a library for Vyper storage slot overrides as specified in the
[Vyper docs](https://docs.vyperlang.org/en/stable/compiling-a-contract.html#storage-layout).

Overriding storage slots allows for custom storage layouts and storage-dependent ERC stanadards,
for example [ERC-1967](https://eips.ethereum.org/EIPS/eip-1967).

## Installation and Importing

The respository can be installed as follows using Foundry.

```bash
forge install jtriley-eth/vyper-storage
```

The library includes a single prelude-like file to import everything necessary.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "vyper-storage/Lib.sol";
```

## API Documentation

### `VyperStorage`

#### Declaration

The `VyperStorage` struct is defined as follows.

> NOTE: To get the current length of vyper storage slot overrides, `vyperStorage.variablesLength`
> should be used rather than `vyperStorage.variables.length`, as the former tracks the current
> length and the latter simply maintains a buffer for future storage overrides.

```solidity
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
```

#### Methods

The `VyperStorage` implements the following methods. Those that manipulate the state of the struct
also return the updated struct, so methods may be chained together.

```solidity
// Create new Vyper Storage
function newVyperStorage() pure returns (VyperStorage memory);

// Set Max Length (default is 10)
function setMaxLength(
    VyperStorage memory vyperStorage,
    uint32 length
) pure returns (VyperStorage memory);

// Set Vyper Path (default is "vyper")
function setVyperPath(
    VyperStorage memory vyperStorage,
    string memory path
) pure returns (VyperStorage memory);

// Set File Path (default is "")
function setFilePath(
    VyperStorage memory vyperStorage,
    string memory path
) pure returns (VyperStorage memory);

// Assign Variable Name and Slot
function assignSlot(
    VyperStorage memory vyperStorage,
    string memory variableName,
    string memory typ,
    bytes32 slot
) pure returns (VyperStorage memory);

// Create Storage Layout and Compile
//
// Note: creates, writes, and deletes a temp file named `./.temp_vyper_storage.json`
function compile(VyperStorage memory vyperStorage) returns (bytes memory initCode);

// Convert Vyper Storage to JSON
function toJson(VyperStorage memory vyperStorage) pure returns (string memory json);
```
