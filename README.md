# Vyper Storage

## Showcase

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "vyper-storage/Lib.sol";

// -- snip --

bytes32 adminSlot = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

bytes memory initCode = newVyperStorageBuilder()
    .filePath("src/ERC1967Proxy")
    .assignSlot("implementation", "address", implSlot)
    .build()
    .compile();
```

## About

This is a library for Vyper storage slot overrides as specified in the
[Vyper docs](https://docs.vyperlang.org/en/stable/compiling-a-contract.html#storage-layout).

Overriding storage slots allows for custom storage layouts and storage-dependent ERC stanadards,
for example [ERC-1967](https://eips.ethereum.org/EIPS/eip-1967).

We implement the rust-like
[builder pattern](https://rust-unofficial.github.io/patterns/patterns/creational/builder.html) for
creating the storage layout strucutre and we implement global functions for both the `VyperStorage`
and `VyperStorageBuilder` strucutres for a more ergonomic API.

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

### `VyperStorageBuilder`

The `VyperStorageBuilder` implements the following methods.

```solidity
// creates a new builder
VyperStorageBuilder memory builder = newVyperStorageBuilder();

// sets the max length of the number variables (default 10)
builder.maxLength(maxLength);

// sets the vyper compiler path (default "vyper")
builder.vyperPath(vyperPath);

// sets the file path (default "")
builder.filePath(filePath);

// assigns a new storage slot
builder.assignStorageSlot(variableName, variableType, slot);

// builds the `VyperStorage` struct
VyperStorage memory vyperStorage = builder.build();
```

### `VyperStorage`

The `VyperStorage` implements the following methods.

```solidity
VyperStorage memory vyperStorage = newVyperStorageBuilder()
    .filePath("MyContract.vy")
    .assignStorageSlot("counter", "uint256", 0x45)
    .build();

// compiles the contract (this is the only required method)
bytes memory initCode = vyperStorage.compile();

// shows the json path
string memory path = vyperStorage.jsonPath();

// converts the VyperStorage to json string
string memory json = vyperStorage.toJson();
```
