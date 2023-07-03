import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofsVerificationLibrary } from '../../scripts/deployForTest';
import { proofOfAuthorityData } from '../data/proofs';

describe.only('Proofs Verification', () => {
  async function deployProofsVerificationFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofsVerification } = await deployProofsVerificationLibrary();

    return { proofsVerification, owner, creator, signer1, signer2, signer3, anyone };
  }

  it('verify any signature', async () => {
    const { proofsVerification, signer1, signer2, anyone } = await loadFixture(
      deployProofsVerificationFixture
    );

    const message1 = ethers.solidityPackedKeccak256(['address', 'uint'], [anyone.address, 45]);
    const message2 = ethers.keccak256(ethers.toUtf8Bytes(JSON.stringify(proofOfAuthorityData)));
    const signature1 = await signer1.signMessage(ethers.getBytes(message1));
    const signature2 = await signer2.signMessage(ethers.getBytes(message2));

    // correct signer of message1
    expect(await proofsVerification.verify.staticCall(signer1.address, message1, signature1)).equal(
      true
    );
    // wrong signer of message1
    expect(await proofsVerification.verify.staticCall(signer2.address, message1, signature1)).equal(
      false
    );
    // correct signer of message2
    expect(await proofsVerification.verify.staticCall(signer2.address, message2, signature2)).equal(
      true
    );
    // wrong signer of message2
    expect(await proofsVerification.verify.staticCall(signer1.address, message2, signature2)).equal(
      false
    );
    // wrong signature of message2
    expect(await proofsVerification.verify.staticCall(signer1.address, message2, signature1)).equal(
      false
    );
  });

  it.only('verify Proof-of-Authority', async () => {
    const { proofsVerification, signer1, signer2, anyone } = await loadFixture(
      deployProofsVerificationFixture
    );
    const agreementFileProofCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';

    const data: any = proofOfAuthorityData;
    data.message = {
      signer: signer1.address,
      agreementFileProofCID,
      app: 'daosign',
      timestamp: await time.latest(),
      metadata: {},
    };
    const rawData = JSON.stringify(data);
    const dataHash = ethers.keccak256(ethers.toUtf8Bytes(rawData));
    const signature = await signer1.signMessage(ethers.getBytes(dataHash));

    expect(
      await proofsVerification.verifyProofOfAuthority(signer1.address, rawData, signature)
    ).equal(true);
  });
});
