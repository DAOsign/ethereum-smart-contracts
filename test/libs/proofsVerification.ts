import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofsVerificationLibrary } from '../../scripts/deployForTest';
import { proofOfAuthorityData, proofOfSignatureData } from '../data/proofs';

describe('Proofs Verification', () => {
  async function deployProofsVerificationFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofsVerification } = await deployProofsVerificationLibrary();

    return { proofsVerification, owner, creator, signer1, signer2, signer3, anyone };
  }

  it('verify any signature', async () => {
    const { proofsVerification, signer1, signer2, anyone } = await loadFixture(
      deployProofsVerificationFixture,
    );

    const message1 = ethers.solidityPackedKeccak256(['address', 'uint'], [anyone.address, 45]);
    const message2 = ethers.keccak256(ethers.toUtf8Bytes(JSON.stringify(proofOfAuthorityData)));
    const signature1 = await signer1.signMessage(ethers.getBytes(message1));
    const signature2 = await signer2.signMessage(ethers.getBytes(message2));

    // correct signer of message1
    expect(await proofsVerification.verify.staticCall(signer1.address, message1, signature1)).equal(
      true,
    );
    // wrong signer of message1
    expect(await proofsVerification.verify.staticCall(signer2.address, message1, signature1)).equal(
      false,
    );
    // correct signer of message2
    expect(await proofsVerification.verify.staticCall(signer2.address, message2, signature2)).equal(
      true,
    );
    // wrong signer of message2
    expect(await proofsVerification.verify.staticCall(signer1.address, message2, signature2)).equal(
      false,
    );
    // wrong signature of message2
    expect(await proofsVerification.verify.staticCall(signer1.address, message2, signature1)).equal(
      false,
    );
  });

  it('verify signed proof', async () => {
    const { proofsVerification, creator, signer1, signer2, signer3 } = await loadFixture(
      deployProofsVerificationFixture,
    );
    const agreementFileCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const agreementFileProofCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const signers = [signer1.address, signer2.address, signer3.address];

    /**
     * Proof-of-Authority
     */
    // poa - Proof-of-Authority
    // pos - Proof-of-Signature
    let poaData: any = proofOfAuthorityData;
    poaData = {
      ...poaData,
      message: {
        from: creator.address,
        agreementFileCID,
        signers,
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      },
    };
    const rawPoaData = JSON.stringify(poaData);
    const poaDataHash = ethers.keccak256(ethers.toUtf8Bytes(rawPoaData));
    const poaSignature1 = await signer1.signMessage(ethers.getBytes(poaDataHash));
    const poaSignature2 = await signer2.signMessage(ethers.getBytes(poaDataHash));

    // correct signer of the proof
    expect(
      await proofsVerification.verifySignedProof(signer1.address, rawPoaData, poaSignature1),
    ).equal(true);
    expect(
      await proofsVerification.verifySignedProof(signer2.address, rawPoaData, poaSignature2),
    ).equal(true);
    // wrong signer of the proof
    expect(
      await proofsVerification.verifySignedProof(signer2.address, rawPoaData, poaSignature1),
    ).equal(false);
    // wrong signature
    expect(
      await proofsVerification.verifySignedProof(signer1.address, rawPoaData, poaSignature2),
    ).equal(false);

    /**
     * Proof-of-Signature
     */
    let posData: any = proofOfSignatureData;
    posData = {
      ...posData,
      message: {
        signer: signer1.address,
        agreementFileProofCID,
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      },
    };
    const rawPosData = JSON.stringify(posData);
    const posDataHash = ethers.keccak256(ethers.toUtf8Bytes(rawPosData));
    const posSignature1 = await signer1.signMessage(ethers.getBytes(posDataHash));
    const posSignature2 = await signer2.signMessage(ethers.getBytes(posDataHash));

    // correct signer of the proof
    expect(
      await proofsVerification.verifySignedProof(signer1.address, rawPosData, posSignature1),
    ).equal(true);
    expect(
      await proofsVerification.verifySignedProof(signer2.address, rawPosData, posSignature2),
    ).equal(true);
    // wrong signer of the proof
    expect(
      await proofsVerification.verifySignedProof(signer2.address, rawPosData, posSignature1),
    ).equal(false);
    // wrong signature
    expect(
      await proofsVerification.verifySignedProof(signer1.address, rawPosData, posSignature2),
    ).equal(false);
  });
});
