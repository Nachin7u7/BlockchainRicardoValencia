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
            true,
            accountData.id,
            0,
            accountData.name
        );
    }

    function deposit(uint256 id) public payable closedBank {
        Account memory data = listAccounts[id];
        uint256 mount = convertWeiToEther(msg.value);
        listAccounts[id].balance += mount;
        require(!data.enable, "Cuenta no valida, su cuenta esta desactivada");
        require(mount > 2, "El deposito minimo es de 2 ETH");
        emit clientDeposit(data.id, data.name, mount);
        if (mount > 10) payable(msg.sender).transfer(1);
    }

    function redrawMoney(uint256 id, uint256 mount) public payable closedBank {
        Account memory data = listAccounts[id];
        require(!data.enable, "Cuenta no valida, su cuenta esta desactivada");
        require(mount <= data.balance, "No tiene suficiente dinero");
        listAccounts[id].balance -= mount;
        payable(msg.sender).transfer(mount);
    }
}
