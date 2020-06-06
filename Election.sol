pragma solidity ^0.5.2;

contract Election{
    mapping(address => bool) public voters;
    mapping(uint => Candidate) public candidates;
    uint candidatesCount;

    struct Candidate{
        string name;
        string partie;
        address owner;
        uint ID;
        uint votes;
    }

    function addCandidates(string memory _name, string memory _partie) public {
        require(bytes(_name).length != 0 || bytes(_partie).length != 0);
        candidates[candidatesCount] = Candidate(_name, _partie, msg.sender, candidatesCount, 0);
        candidatesCount++;
    }

    function isCandidate(uint256 _ID) public view returns(bool){
        if (_ID>= candidatesCount){
            return false;
        }
        else {
            return true;
        }
    }

    modifier voteOnlyOnce(address _address){
        require(voters[_address] == false);
        _;
    }
    
    modifier onlyCandidate(uint256 _ID){
        require (candidates[_ID].owner == msg.sender);
        _;
    }

    function vote(uint _ID) public payable voteOnlyOnce(msg.sender){
        require(isCandidate(_ID) && msg.value >= 0.01 ether);
        candidates[_ID].votes++;
        voters[msg.sender] = true;
    }
    
    function modifyPartie(uint _ID, string memory _partie) public onlyCandidate(_ID){
        candidates[_ID].partie = _partie;
    }
}
