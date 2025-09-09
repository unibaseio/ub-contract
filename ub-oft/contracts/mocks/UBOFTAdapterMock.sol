// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

import { UBOFTAdapter } from "../UBOFTAdapter.sol";

// @dev WARNING: This is for testing purposes only
contract MyOFTAdapterMock is UBOFTAdapter {
    constructor(address _token, address _lzEndpoint, address _delegate) UBOFTAdapter(_token, _lzEndpoint, _delegate) {}
}
