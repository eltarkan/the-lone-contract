// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract Coin is IERC20 {
    using SafeMath for uint256;

    string public constant name = "Elder Coin";
    string public constant symbol = "EC";
    uint8 public constant decimals = 2;

    mapping(string => uint256) public collaborations;
    mapping(string => uint256) public collaborationStash;

    mapping(address => uint256) balances;
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;
    uint256 remainingSupply;

    constructor() {
        uint256 total;
        total = 25 * 10 ** 12;
        totalSupply_ = total;
        balances[msg.sender] = totalSupply_;
        remainingSupply = totalSupply_;
    }

    // Collaboration section //

    function collaborationCreate(string memory _name, uint256 _requiredBudget) public {
        require(_requiredBudget <= remainingSupply);
        remainingSupply = remainingSupply - _requiredBudget;
        collaborations[_name] = _requiredBudget;
        collaborationStash[_name] = _requiredBudget;
    }

    function collaborationShowStash(string memory _name) public view returns (uint) {
        return collaborations[_name];
    }

    function collaborationShowTotalSupply(string memory _name) public view returns (uint) {
        return collaborationStash[_name];
    }

    function collaborationDepositToStash(address _account, string memory _collaborationName, uint _amount) public returns (bool) {
        require(_amount <= balances[_account]);
        balances[_account] = balances[_account].sub(_amount);
        collaborationStash[_collaborationName] = collaborationStash[_collaborationName].add(_amount);
        return true;
    }

    function collaborationWithdrawalFromStash(address _account, string memory _collaborationName, uint _amount) public returns (bool) {
        require(_amount <= collaborationStash[_collaborationName]);
        collaborationStash[_collaborationName] = collaborationStash[_collaborationName].sub(_amount);
        balances[_account] = balances[_account].add(_amount);
        return true;
    }

    // Collaboration section //


    function totalSupply() public override view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }
    function approve(address delegate, uint256 numTokens) public override returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public override view returns (uint) {
        return allowed[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }
}

library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        assert(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        assert(c >= a);
        return c;
    }
}