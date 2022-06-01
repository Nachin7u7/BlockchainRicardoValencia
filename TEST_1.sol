// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

// Ricardo Ignacio Valencia Sauma
// Codigo: 51231
// Examen B

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

    mapping(uint256 => Account) public accounts;

    function createAccount(Account memory data)
        public
        onlyOwner(msg.sender)
        closedBank
    {
        require(
            bytes(data.name).length > 5,
            "Nombre muy corto, el nombre debe ser mayor a 5"
        );

        accounts[data.id] = Account(true, data.id, data.name, 0);
    }

    function deposit(uint256 id) public payable closedBank {
        Account memory data = accounts[id];
        uint256 mount = convertWeiToEther(msg.value);
        accounts[id].balance += mount;
        require(!data.enable, "Cuenta no valida, su cuenta esta desactivada");
        require(mount > 2, "El deposito minimo es de 2 ETH");
        emit clientDeposit(data.id, mount, data.name);
        if (mount > 10) payable(msg.sender).transfer(1);
    }

    function redrawMoney(uint256 id, uint256 mount) public payable closedBank {
        Account memory data = accounts[id];
        require(!data.enable, "Cuenta no valida, su cuenta esta desactivada");
        require(mount <= data.balance, "No tiene suficiente dinero");
        accounts[id].balance -= mount;
        payable(msg.sender).transfer(mount);
    }

    function openCloseBank(bool value) public onlyOwner(msg.sender) {
        isClosed = value;
    }

    function blockAccount(uint256 id) public onlyOwner(msg.sender) closedBank {
        accounts[id].enable = false;
    }

    function withdrawAllMoney() public onlyOwner(msg.sender) {
        payable(msg.sender).transfer(address(this).balance);
    }

    function convertWeiToEther(uint256 amount) private pure returns (uint256) {
        return amount / 1 ether;
    }

    modifier onlyOwner(address wallet) {
        require(owner == wallet, "Usted no es el owner");
        _;
    }
    modifier closedBank() {
        require(!isClosed, "El banco esta cerrado");
        _;
    }
}
