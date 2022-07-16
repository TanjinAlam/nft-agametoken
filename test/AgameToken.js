const {
    time,
    loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { expect } = require("chai");

describe ("AgameToken", function () {
    async function deployAgameToken() {
        
        // defining constants for the test
        // the upperlimit test uint
        const UPPERLIMIT = 3_333_333_333_333_333_300_000n; //1 million dollars in bnb
        const LOWERLIMIT = 16_666_666_666_660_000_000n; //5 thousand dollars in bnb

        const investorAmount = 16_000_000_000_000_000_000n;
        const partnerAmount = 20_000_000_000_000_000_000n;

        const LEVEL_1 = 10_000;
        const LEVEL_2 = 20_000;
        const LEVEL_3 = 30_000;
        const LEVEL_4 = 40_000;
        const LEVEL_5 = 50_000;
        const LEVEL_6 = 60_000;

        const [Admin, Other, Next] = await ethers.getSigners();

        const AgameToken = await ethers.getContractFactory("AgameToken");
        const agametoken = await AgameToken.deploy(Admin.address, LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5, LEVEL_6);

        return {Next, agametoken, LEVEL_1, LEVEL_2, LEVEL_3, LEVEL_4, LEVEL_5, LEVEL_6, Admin, UPPERLIMIT, LOWERLIMIT, investorAmount, partnerAmount, Other };
    }

    describe("Deployment", function () {
        it("Should set the right Admin", async function () {
            const { agametoken, Admin } = await loadFixture(deployAgameToken);
      
            expect(await agametoken.admin()).to.equal(Admin.address);
          });
    });

    describe("Token core functions", function () {
        it("Should show tokens have been minted", async function () {
            const { agametoken, Admin } = await loadFixture(deployAgameToken);
            
      
            expect(await agametoken.balanceOf(Admin.address)).to.be.greaterThan(0);
          });

        it("Should transfer succesfully", async function () {
            const { agametoken, Admin, Other } = await loadFixture(deployAgameToken);
            const TRANSFER_AMOUNT = 1_000_000_000_000_000_000n;
      
            await expect(agametoken.transfer(Admin.address, TRANSFER_AMOUNT)).not.to.be.reverted;
          });
        
        it("Should burn succesfully", async function () {
            const { agametoken, Admin } = await loadFixture(deployAgameToken);
            const BURN_AMOUNT = 1_000_000_000_000_000_000n;
      
            await expect(agametoken.burn(Admin.address, BURN_AMOUNT)).not.to.be.reverted;
          });
    
        it("Should approve succesfully", async function () {
            const { agametoken, Other} = await loadFixture(deployAgameToken);
            const APPROVE_AMOUNT = 1_000_000_000_000_000_000n;
      
            await expect(agametoken.approve(Other.address, APPROVE_AMOUNT)).not.to.be.reverted;
          });

        it("Should transferFrom succesfully", async function () {
            const { agametoken, Other, Next, Admin} = await loadFixture(deployAgameToken);
            const TRANSFER_AMOUNT = 1_000_000_000_000_000_000n;

            await agametoken.approve(Other.address, TRANSFER_AMOUNT);
            await agametoken.connect(Other).transferFrom(Admin.address, Next.address, TRANSFER_AMOUNT);
            expect(await agametoken.balanceOf(Next.address)).to.equal(TRANSFER_AMOUNT);
          });
    });










    describe("Special Token functions", function () {
        it("Should claim airdrop succesfully", async function () {
            const { agametoken, Other } = await loadFixture(deployAgameToken);
      
            await agametoken.connect(Other).RegisterWhitelist();
            await agametoken.connect(Other).ClaimAirdrop();
            expect (await agametoken.balanceOf(Other.address)).to.be.greaterThan(0);
          });

        it("Should buy investor tokens from contract succesfully", async function () {
            const { agametoken, Other, investorAmount} = await loadFixture(deployAgameToken);
            await agametoken.connect(Other).buyToken_Investors({ value: investorAmount });
      
            await expect(agametoken.withdraw(investorAmount)).not.to.be.reverted;
          });

        it("Should buy partners tokens from contract succesfully", async function () {
            const { agametoken, Other, partnerAmount} = await loadFixture(deployAgameToken);
            await agametoken.connect(Other).buyToken_Partners({ value: partnerAmount });
      
            await expect(agametoken.withdraw(partnerAmount)).not.to.be.reverted;
          });
        
        it("Should withdraw tokens succesfully", async function () {
            const { agametoken, Admin } = await loadFixture(deployAgameToken);
            const WITHDRAW_AMOUNT = 1_000_000_000_000_000_000n;
            
            await expect(agametoken.withdraw_token(WITHDRAW_AMOUNT, Admin.address)).not.to.be.reverted;
          });
    });
});