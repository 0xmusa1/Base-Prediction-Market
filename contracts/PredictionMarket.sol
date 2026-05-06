// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PredictionMarket is Ownable {

    uint256 public constant ENTRY_FEE = 0.00001 ether;

    struct Prediction {
        uint256 predictedPrice;
        uint256 timestamp;
        address user;
    }

    mapping(uint256 => Prediction[]) public dailyPredictions;
    mapping(uint256 => mapping(address => bool)) public hasPredicted;

    event PredictionSubmitted(
        address indexed user,
        uint256 indexed day,
        uint256 price
    );

    constructor() Ownable(msg.sender) {}

    function getCurrentDay() public view returns (uint256) {
        return block.timestamp / 1 days;
    }

    function submitPrediction(uint256 _price) external payable {

        require(msg.value == ENTRY_FEE, "Wrong fee");

        uint256 currentDay = getCurrentDay();

        require(
            !hasPredicted[currentDay][msg.sender],
            "Already predicted today"
        );

        Prediction memory newPrediction = Prediction({
            predictedPrice: _price,
            timestamp: block.timestamp,
            user: msg.sender
        });

        dailyPredictions[currentDay].push(newPrediction);

        hasPredicted[currentDay][msg.sender] = true;

        emit PredictionSubmitted(
            msg.sender,
            currentDay,
            _price
        );
    }

    function getPredictions(
        uint256 _day
    ) external view returns (Prediction[] memory) {

        return dailyPredictions[_day];
    }

    function withdraw() external onlyOwner {

        uint256 balance = address(this).balance;

        require(balance > 0, "No balance");

        payable(owner()).transfer(balance);
    }
}
