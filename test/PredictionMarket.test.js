const { expect } = require("chai");

describe("PredictionMarket", function () {

  it("Should submit prediction", async function () {

    const PredictionMarket = await ethers.getContractFactory(
      "PredictionMarket"
    );

    const contract = await PredictionMarket.deploy();

    await contract.waitForDeployment();

    await contract.submitPrediction(
      3000,
      {
        value: ethers.parseEther("0.00001")
      }
    );

    const day = await contract.getCurrentDay();

    const predictions = await contract.getPredictions(day);

    expect(predictions.length).to.equal(1);
  });

});
