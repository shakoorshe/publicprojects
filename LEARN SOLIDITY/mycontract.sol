pragma solidity ^0.4.24;

contract myContract {
    string value;

    function get() public view returns (string) {
        return value;
    }

    function set(string _value) public {
        value = _value;
    }
}
