const { expect } = require("chai");

describe("BSCRelay", function() {

    describe("decodeRLPHeader", function () {
        it("Check method decodeRLPHeader", async function () {
            const bscRelayContractFactory = await ethers.getContractFactory("BSCRelay");
            const bscRelay = await bscRelayContractFactory.deploy();
            await bscRelay.deployed();

            const blockHeader = await bscRelay.decodeRLPHeader("0xf90403a01af4e70b0f0b53beca1a9245f9bdb019a1ab02ec9c4de37cee7df8a3b8f32dbba01dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d493479429a97c6effb8a411dabc6adeefaa84f5067c8bbea0b5418b7cc912f9bfd36eed2e75e64ef400504959cbd277cc486d4512b1b38b6ca0eb91b548f07b0253574f73222ea231bf51aeac360e2d23b2c7fa2fbf4274078fa0a9b58df78ab92faf24df066cfb315ee12a8d45618bef47ffc547c9e824881c19b90100f42bb78d4c7ef477bb7fc82dab8ea4ee6cd66b73f7d5f76f295a3ff2beb2d9167921653a70cb770afd49b8ff6a8d26029fef82eb32c0b1b1b5b77f8db36736bdd7fdf7461ad1acce1f3bb27d7c7f7def34d7f23bda646996b19caeaef25afaa57e5cb567ba07b7f2fd6cd36acf86fbb2aff57f7f82b947d2be70f4f3f9dcfe4d9eec66257ada93be1afffe889d7f7ecbd9f47fa7582ddbeeff3c756adfaafdffd3e541f7e16adb41fb96312dd7ae7c88bb3efdb132d42bb5fbb8932fdeeefad26fc3df0786ea546246d6ddf9fd5fdb696d571d1614bbd59cf1dc3bbfca38fcf62efbbdfbb7f9e3153332b2c11d0882b65c087fb8679afde9eeca035edeeb9c9702837fcd3084039387008401a6955a8460cb437fb90205d883010100846765746888676f312e31352e35856c696e7578000000fc3ca6b72465176c461afb316ebc773c61faee85a6515daa295e26495cef6f69dfa69911d9d8e4f3bbadb89b29a97c6effb8a411dabc6adeefaa84f5067c8bbe2d4c407bbe49438ed859fe965b140dcf1aab71a93f349bbafec1551819b8be1efea2fc46ca749aa14430b3230294d12c6ab2aac5c2cd68e80b16b581685b1ded8013785d6623cc18d214320b6bb6475970f657164e5b75689b64b7fd1fa275f334f28e187ae2f5b9e386cd1b50a4550696d957cb4900f03a8b6c8fd93d6f4cea42bbb345dbc6f0dfdb5bec739bb832254baf4e8b4cc26bd2b52b31389b56e98b9f8ccdafcc39f3c7d6ebf637c9151673cbc36b88a6f79b60359f141df90a0c745125b131caaffd12b218c5d6af1f979ac42bc68d98a5a0d796c6ab01b8f7166496996a7da21cf1f1b04d9b3e26a3d077be807dddb074639cd9fa61b47676c064fc50d62cce2fd7544e0b2cc94692d4a704debef7bcb61328e2d3a739effcd3a99387d015e260eefac72ebea1e9ae3261a475a27bb1028f140bc2a7c843318afdea0a6e3c511bbd10f4519ece37dc24887e11b55dee226379db83cffc681495730c11fdde79ba4c0c9a98e2f70f793acf0b59638046e90ad01a903e5fdfbd7c8e63c0d14dc59c7549094110bfb8bed3c61f7b022da8d0b5b318acbd894e0fdd9c0612304515e00e9301a00000000000000000000000000000000000000000000000000000000000000000880000000000000000");
            //console.log(blockHeader.blockNumber);

            expect(blockHeader.parentHash).to.equal("0x1af4e70b0f0b53beca1a9245f9bdb019a1ab02ec9c4de37cee7df8a3b8f32dbb");
            expect(blockHeader.uncleHash).to.equal("0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347");
            expect(blockHeader.miner).to.be.equal("0x29a97C6EfFB8A411DABc6aDEEfaa84f5067C8bbe");
            expect(blockHeader.stateRoot).to.equal("0xb5418b7cc912f9bfd36eed2e75e64ef400504959cbd277cc486d4512b1b38b6c");
            expect(blockHeader.transactionsRoot).to.equal("0xeb91b548f07b0253574f73222ea231bf51aeac360e2d23b2c7fa2fbf4274078f");
            expect(blockHeader.receiptsRoot).to.equal("0xa9b58df78ab92faf24df066cfb315ee12a8d45618bef47ffc547c9e824881c19");
            expect(blockHeader.difficulty).to.equal(2);
            expect(blockHeader.blockNumber).to.equal(8375600);
            expect(blockHeader.gasLimit).to.equal(60000000);
            expect(blockHeader.gasUsed).to.equal(27694426);
            expect(blockHeader.timestamp).to.equal(1623933823);
            expect(blockHeader.extraData).to.equal("0xd883010100846765746888676f312e31352e35856c696e7578000000fc3ca6b72465176c461afb316ebc773c61faee85a6515daa295e26495cef6f69dfa69911d9d8e4f3bbadb89b29a97c6effb8a411dabc6adeefaa84f5067c8bbe2d4c407bbe49438ed859fe965b140dcf1aab71a93f349bbafec1551819b8be1efea2fc46ca749aa14430b3230294d12c6ab2aac5c2cd68e80b16b581685b1ded8013785d6623cc18d214320b6bb6475970f657164e5b75689b64b7fd1fa275f334f28e187ae2f5b9e386cd1b50a4550696d957cb4900f03a8b6c8fd93d6f4cea42bbb345dbc6f0dfdb5bec739bb832254baf4e8b4cc26bd2b52b31389b56e98b9f8ccdafcc39f3c7d6ebf637c9151673cbc36b88a6f79b60359f141df90a0c745125b131caaffd12b218c5d6af1f979ac42bc68d98a5a0d796c6ab01b8f7166496996a7da21cf1f1b04d9b3e26a3d077be807dddb074639cd9fa61b47676c064fc50d62cce2fd7544e0b2cc94692d4a704debef7bcb61328e2d3a739effcd3a99387d015e260eefac72ebea1e9ae3261a475a27bb1028f140bc2a7c843318afdea0a6e3c511bbd10f4519ece37dc24887e11b55dee226379db83cffc681495730c11fdde79ba4c0c9a98e2f70f793acf0b59638046e90ad01a903e5fdfbd7c8e63c0d14dc59c7549094110bfb8bed3c61f7b022da8d0b5b318acbd894e0fdd9c0612304515e00e9301");
            expect(blockHeader.nonce).to.equal(0);

        });
    });

    describe("getValidatorSignature", function () {
        it("Check method getValidatorSignature", async function () {
            const bscRelayContractFactory = await ethers.getContractFactory("BSCRelay");
            const bscRelay = await bscRelayContractFactory.deploy();
            await bscRelay.deployed();

            const signature = await bscRelay.getValidatorSignature("0xd883010100846765746888676f312e31352e35856c696e7578000000fc3ca6b72465176c461afb316ebc773c61faee85a6515daa295e26495cef6f69dfa69911d9d8e4f3bbadb89b29a97c6effb8a411dabc6adeefaa84f5067c8bbe2d4c407bbe49438ed859fe965b140dcf1aab71a93f349bbafec1551819b8be1efea2fc46ca749aa14430b3230294d12c6ab2aac5c2cd68e80b16b581685b1ded8013785d6623cc18d214320b6bb6475970f657164e5b75689b64b7fd1fa275f334f28e187ae2f5b9e386cd1b50a4550696d957cb4900f03a8b6c8fd93d6f4cea42bbb345dbc6f0dfdb5bec739bb832254baf4e8b4cc26bd2b52b31389b56e98b9f8ccdafcc39f3c7d6ebf637c9151673cbc36b88a6f79b60359f141df90a0c745125b131caaffd12b218c5d6af1f979ac42bc68d98a5a0d796c6ab01b8f7166496996a7da21cf1f1b04d9b3e26a3d077be807dddb074639cd9fa61b47676c064fc50d62cce2fd7544e0b2cc94692d4a704debef7bcb61328e2d3a739effcd3a99387d015e260eefac72ebea1e9ae3261a475a27bb1028f140bc2a7c843318afdea0a6e3c511bbd10f4519ece37dc24887e11b55dee226379db83cffc681495730c11fdde79ba4c0c9a98e2f70f793acf0b59638046e90ad01a903e5fdfbd7c8e63c0d14dc59c7549094110bfb8bed3c61f7b022da8d0b5b318acbd894e0fdd9c0612304515e00e9301");
            expect(signature).to.equal("0x9a98e2f70f793acf0b59638046e90ad01a903e5fdfbd7c8e63c0d14dc59c7549094110bfb8bed3c61f7b022da8d0b5b318acbd894e0fdd9c0612304515e00e9301");

        });
    });

});

