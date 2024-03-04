const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SmartBet Contract", function () {
  let smartBet;
  let owner;
  let addr1;
  let addr2;
  let addr3;

  beforeEach(async function () {
    const SmartBet = await ethers.getContractFactory("SmartBet");
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
    smartBet = await SmartBet.deploy();
  });

  describe("User Registration", function () {
    it("Should allow a new user to register", async function () {
      await expect(smartBet.connect(addr1).register())
        .to.emit(smartBet, "UserRegistered")
        .withArgs(addr1.address);
    });

    it("Should not allow a user to register more than once", async function () {
      await smartBet.connect(addr1).register();
      await expect(smartBet.connect(addr1).register()).to.be.revertedWith("User already registered.");
    });
  });

  describe("Match Management", function () {
    it("Should allow admin to create a match", async function () {
      await expect(smartBet.connect(owner).createMatch("Team A", "Team B"))
        .to.emit(smartBet, "MatchCreated")
        .withArgs(1, "Team A", "Team B"); // Assuming this is the first match created and thus has ID 1
    });
  });

  describe("Betting", function () {
    beforeEach(async function () {
      // Register users and create a match before each betting test
      await smartBet.connect(addr1).register();
      await smartBet.connect(addr2).register();
      await smartBet.connect(owner).createMatch("Team A", "Team B");
    });

    it("Should allow a registered user to place a bet", async function () {
      await expect(smartBet.connect(addr1).placeBet(1, 1, 0, { value: ethers.parseEther("1") }))
        .to.emit(smartBet, "BetPlaced")
        .withArgs(addr1.address, 1, 1, 0, ethers.parseEther("1"));
    });

    it("Should not allow an unregistered user to place a bet", async function () {
      await expect(smartBet.connect(addr3).placeBet(1, 1, 0, { value: ethers.parseEther("1") }))
        .to.be.revertedWith("User not registered.");
    });
  });

  describe("Settling Matches", function () {
    beforeEach(async function () {
      // Setup for settling match
      await smartBet.connect(addr1).register();
      await smartBet.connect(owner).createMatch("Team A", "Team B");
      await smartBet.connect(addr1).placeBet(1, 2, 1, { value: ethers.parseEther("1") });
    });

    it("Should allow admin to settle a match", async function () {
      await expect(smartBet.connect(owner).settleMatch(1, 2, 1))
        .to.emit(smartBet, "MatchSettled")
        .withArgs(1, 2, 1); 
    });
  });
});
