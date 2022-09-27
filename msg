"use strict";

var web3 = new Web3(new Web3.providers.WebsocketProvider("ws://localhost:8545"));
var abi = [{ "constant": true, "inputs": [{ "name": "userAddress", "type": "address" }], "name": "userExists", "outputs": [{ "name": "", "type": "bool" }], "payable": false, "stateMutability": "view", "type": "function", "signature": "0x0e666e49" }, { "constant": true, "inputs": [], "name": "messageCount", "outputs": [{ "name": "", "type": "uint8" }], "payable": false, "stateMutability": "view", "type": "function", "signature": "0x3dbcc8d1" }, { "constant": false, "inputs": [{ "name": "text", "type": "string" }], "name": "sendMessage", "outputs": [{ "name": "", "type": "bool" }], "payable": false, "stateMutability": "nonpayable", "type": "function", "signature": "0x469c8110" }, { "constant": false, "inputs": [{ "name": "name", "type": "string" }], "name": "setUsername", "outputs": [{ "name": "", "type": "bool" }], "payable": false, "stateMutability": "nonpayable", "type": "function", "signature": "0xed59313a" }, { "inputs": [], "payable": false, "stateMutability": "nonpayable", "type": "constructor", "signature": "constructor" }, { "anonymous": false, "inputs": [{ "components": [{ "name": "text", "type": "string" }, { "components": [{ "name": "_address", "type": "address" }, { "name": "name", "type": "string" }, { "name": "isValue", "type": "bool" }], "name": "_user", "type": "tuple" }], "indexed": false, "name": "message", "type": "tuple" }], "name": "MessageCreated", "type": "event", "signature": "0xbC05c9feb6Ea967A7041536E9f572Ed138eeed0B" }]
var $page = {};

//Use the address you've copied before, e.g newContractInstance.options.address

$page.user_address = '0xd43c85773274dad673ae2e34c94423199a920efb'
$page.contract_address = '0xbC05c9feb6Ea967A7041536E9f572Ed138eeed0B'

var MessageContract = new web3.eth.Contract(abi, $page.contract_address, {
    from: $page.user_address,
    gasPrice:  4700
});

$page.sendMessage = function () {
    var message = $("#message").val()
    $("#message").val('')
    return MessageContract.methods.sendMessage(message).send()
}

$page.writeName = function (name) {
    return MessageContract.methods.setUsername(name).send()
}

$(document).ready(function () {
    $("#login_button").click(function(){
        $page.writeName($("#name").val()).then(function(){
            $("#login-area").hide();
            $("#message-area").show();
        })
    })

    $("#send_button").click(function () {
        $page.sendMessage().then((x)=>{
            console.log(x)
        })
    })
    
    MessageContract.events.MessageCreated({
        filter: {},
        fromBlock: 0,
        toBlock: 'latest'
    }).on("data", (message) => {
        $("#message-list").append(
            `<li>
                ${message.args.message.text}
            </li>`
        )
    })
})
