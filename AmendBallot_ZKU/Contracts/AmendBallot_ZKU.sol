// SPDX-License-Identifier: GPL-3.0
//written by Shreyas Vivek shreyasvivek01@gmail.com
//solidity version specifier
pragma solidity >=0.7.0 <0.9.0;

//contract named ballot 
contract Ballot {
//voter structure having weight, voted, delegate, vote
    struct Voter {
        uint weight; 
        bool voted;  
        address delegate; 
        uint vote;  
    }
//propasal structure having name and votecount
    struct Proposal {
        
        bytes32 name;   
        uint voteCount; 
    }

//public address havinf chairperson
    address public chairperson;

    mapping(address => Voter) public voters;

    Proposal[] public proposals;

//startTime and endTime declaration
    uint public startTime;

    uint public endTime;

   //constructor used 
    constructor(bytes32[] memory proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        
        startTime = block.timestamp;

        endTime = startTime+300;

        for (uint i = 0; i < proposalNames.length; i++) {
            
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
//modifier voteEnded used

    modifier voteEnded(){
        require(block.timestamp <= endTime);
        _;
    }
    //voting rights, giveRightToVote   
    function giveRightToVote(address voter) public {
        require(
            msg.sender == chairperson,
            "Only chairperson can give right to vote."
        );
        require(
            !voters[voter].voted,
            "The voter already voted."
        );
        require(voters[voter].weight == 0);
        voters[voter].weight = 1;
    }

//reference
    function delegate(address to) public {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted, "You already voted.");
        require(to != msg.sender, "Self-delegation is disallowed.");

        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

           
            require(to != msg.sender, "Found loop in delegation.");
        }
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted) {
            
            proposals[delegate_.vote].voteCount += sender.weight;
        } else {
            
            delegate_.weight += sender.weight;
        }
    }

//vote reference
    function vote(uint proposal) public {
        Voter storage sender = voters[msg.sender];
        require(sender.weight != 0, "Has no right to vote");
        require(!sender.voted, "Already voted.");
        sender.voted = true;
        sender.vote = proposal;

       
        proposals[proposal].voteCount += sender.weight;
    }

   //Function winning proposal
    function winningProposal() public view
            returns (uint winningProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal_ = p;
            }
        }
    }

   //winner name function
    function winnerName() public view
            returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}