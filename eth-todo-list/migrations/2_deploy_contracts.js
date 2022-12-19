const TODOLIST = artifacts.require("./TODOLIST.sol");

module.exports = function (deployer) {
    deployer.deploy(TODOLIST);
};
