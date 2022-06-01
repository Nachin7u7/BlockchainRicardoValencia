// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract TEST_1 {
    address private owner;
    bool private isClosed = false;
    event clientDeposit(uint256 id, uint256 amount, string name);
    struct Account {
        bool enable;
        uint256 id;
        string name;
        uint256 balance;
    }

    constructor() {
        owner = msg.sender;
    }

    mapping(uint256 => Account) public listAccounts;

    function createAccount(Account memory accountData)
        public
        onlyOwner(msg.sender)
        closedBank
    {
        require(
            bytes(accountData.name).length > 5,
            "Nombre muy corto, el nombre debe ser mayor a 5"
        );
        listAccounts[accountData.id] = Account(
            accountData.id,
            accountData.name,
            0,
            true
        );
    }
}
