# @version 0.3.7

# @title ERC1967 Proxy Contract
# @author jtriley.eth
implementation: public(address)
admin: public(address)
beacon: public(address)

# @notice Emitted when the implementation is upgraded
# @param implementation the address of the new implementation
event UpgradeImplementation:
    implementation: indexed(address)

# @notice Emitted when the admin is changed
# @param admin the address of the new admin
event ChangeAdmin:
    admin: indexed(address)

# @notice Emitted when the beacon is changed
# @param beacon the address of the new beacon
event ChangeBeacon:
    beacon: indexed(address)

@external
def __init__(admin: address, implementation: address, beacon: address):
    self.admin = admin
    self.implementation = implementation
    self.beacon = beacon


# @notice Upgrades the implementation address
# @dev Throws if caller is not admin
# @param implementation the address of the new implementation
@external
def upgradeImplementation(implementation: address):
    assert msg.sender == self.admin, "unauthorized"
    self.implementation = implementation
    log UpgradeImplementation(implementation)


# @notice Changes the admin address
# @dev Throws if caller is not admin
# @param admin the address of the new admin
@external
def changeAdmin(admin: address):
    assert msg.sender == self.admin, "unauthorized"
    self.admin = admin
    log ChangeAdmin(admin)


# @notice Changes the beacon address
# @dev Throws if caller is not admin
# @param beacon the address of the new beacon
@external
def changeBeacon(beacon: address):
    assert msg.sender == self.admin, "unauthorized"
    self.beacon = beacon
    log ChangeBeacon(beacon)

