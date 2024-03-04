// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartBet {
    address public admin;
    uint256 public totalMatches;
    uint256 public totalPrizePool;

    struct Match {
        uint256 matchId;
        string homeTeam;
        string awayTeam;
        uint256 homeScore;
        uint256 awayScore;
        bool settled;
        uint256 totalBetAmount;
    }

    struct Bet {
        uint256 homeScorePrediction;
        uint256 awayScorePrediction;
        uint256 amountBet;
    }

    struct Participant {
        bool isRegistered;
        mapping(uint256 => Bet) bets; // Mapping from matchId to Bet
    }

    mapping(uint256 => Match) public matches;
    mapping(address => Participant) private participants;
    mapping(uint256 => address[]) private matchParticipants; // Mapping from matchId to participant addresses

    event UserRegistered(address indexed user);
    event BetPlaced(address indexed user, uint256 matchId, uint256 homeScorePrediction, uint256 awayScorePrediction, uint256 amountBet);
    event MatchCreated(uint256 matchId, string homeTeam, string awayTeam);
    event MatchSettled(uint256 matchId, uint256 homeScore, uint256 awayScore);
    event WinnersAnnounced(uint256 matchId, address[] winners, uint256 prizePerWinner);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function register() external {
        require(!participants[msg.sender].isRegistered, "User already registered.");
        participants[msg.sender].isRegistered = true;
        emit UserRegistered(msg.sender);
    }

    function placeBet(uint256 matchId, uint256 homeScorePrediction, uint256 awayScorePrediction) external payable {
        require(participants[msg.sender].isRegistered, "User not registered.");
        require(msg.value > 0, "Bet amount must be greater than 0.");
        require(matches[matchId].matchId != 0, "Match does not exist.");
        require(!matches[matchId].settled, "Match already settled.");

        participants[msg.sender].bets[matchId] = Bet(homeScorePrediction, awayScorePrediction, msg.value);
        matchParticipants[matchId].push(msg.sender);
        matches[matchId].totalBetAmount += msg.value;
        totalPrizePool += msg.value;

        emit BetPlaced(msg.sender, matchId, homeScorePrediction, awayScorePrediction, msg.value);
    }

    function createMatch(string memory homeTeam, string memory awayTeam) external onlyAdmin {
        totalMatches += 1;
        uint256 matchId = totalMatches;
        matches[matchId] = Match(matchId, homeTeam, awayTeam, 0, 0, false, 0);
        emit MatchCreated(matchId, homeTeam, awayTeam);
    }

    function settleMatch(uint256 matchId, uint256 homeScore, uint256 awayScore) external onlyAdmin {
        require(matches[matchId].matchId != 0, "Match does not exist.");
        require(!matches[matchId].settled, "Match already settled.");
        
        Match storage matchInfo = matches[matchId];
        matchInfo.homeScore = homeScore;
        matchInfo.awayScore = awayScore;
        matchInfo.settled = true;

        uint256 totalCorrectBets = 0;
        address[] storage participantsForMatch = matchParticipants[matchId];
        for(uint256 i = 0; i < participantsForMatch.length; i++) {
            Bet storage bet = participants[participantsForMatch[i]].bets[matchId];
            if(bet.homeScorePrediction == homeScore && bet.awayScorePrediction == awayScore) {
                totalCorrectBets += bet.amountBet;
            }
        }

        if(totalCorrectBets > 0) {
            uint256 prizePerWinner = matchInfo.totalBetAmount / totalCorrectBets;
            for(uint256 i = 0; i < participantsForMatch.length; i++) {
                Bet storage bet = participants[participantsForMatch[i]].bets[matchId];
                if(bet.homeScorePrediction == homeScore && bet.awayScorePrediction == awayScore) {
                    payable(participantsForMatch[i]).transfer(prizePerWinner * bet.amountBet);
                }
            }
            emit WinnersAnnounced(matchId, participantsForMatch, prizePerWinner);
        }

        emit MatchSettled(matchId, homeScore, awayScore);
    }
}
