// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleEscrow {

    address public payer;
    address public payee;
    address public owner;

    uint public amount;

    constructor(address _payee) payable {
        payer = msg.sender;
        payee = _payee;
        owner = msg.sender;
        amount = msg.value;
    }

    modifier onlyPayer() {
        require(msg.sender == payer, "Not payer");
        _;
    }

    modifier onlyPayee() {
        require(msg.sender == payee, "Not payee");
        _;
    }

   // Release funds to payee
function releasePayment() public onlyPayer {
    (bool success, ) = payable(payee).call{value: amount}("");
    require(success, "Transfer to payee failed");
    amount = 0;
}

// Refund payer
function refund() public onlyPayee {
    (bool success, ) = payable(payer).call{value: amount}("");
    require(success, "Refund to payer failed");
    amount = 0;
  }
}
