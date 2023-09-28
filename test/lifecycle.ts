import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { deployProofs, deployProofsMetadata } from '../scripts/deployForTest';
import { proofOfAuthorityData, proofOfSignatureData } from './data/proofs';
import { Proofs } from './common';

describe('Lifecycle Tests of the Platform', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofs, proofsMetadata, strings, proofsVerification, proofsHelper } =
      await deployProofs();

    await proofsMetadata.addMetadata(
      Proofs.ProofOfAuthority,
      '0.1.0',
      JSON.stringify(proofOfAuthorityData).slice(0, -1),
    );
    await proofsMetadata.addMetadata(
      Proofs.ProofOfSignature,
      '0.1.0',
      JSON.stringify(proofOfSignatureData).slice(0, -1),
    );

    return {
      proofs,
      strings,
      proofsVerification,
      proofsHelper,
      owner,
      creator,
      signer1,
      signer2,
      signer3,
      anyone,
    };
  }

  const storeProofOfAuthority = async (agreementFileCID: string, poaCID: string) => {
    const version = '0.1.0';

    const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
    const signers = [signer1.address, signer2.address, signer3.address];

    await proofs.fetchProofOfAuthorityData(creator.address, signers, agreementFileCID, version);
    const data = await proofs.fetchProofOfAuthorityData.staticCall(
      creator.address,
      signers,
      agreementFileCID,
      version,
    );

    const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
    const signature = await creator.signMessage(ethers.getBytes(dataHash));
    await proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, poaCID);
  };

  const storeProofOfSignature = async (
    fileCID: string,
    poaCID: string,
    posCID: string,
    proofs: any,
    signer1: SignerWithAddress,
  ) => {
    const version = '0.1.0';

    await proofs.fetchProofOfSignatureData(signer1.address, fileCID, poaCID, version);
    const data = await proofs.fetchProofOfSignatureData.staticCall(
      signer1.address,
      fileCID,
      poaCID,
      version,
    );

    const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
    const signature = await signer1.signMessage(ethers.getBytes(dataHash));
    await proofs.storeProofOfSignature(signer1.address, signature, fileCID, posCID);
  };

  it.only('#1', async () => {
    const agreementFileCID = 'QmfVd78Pns7Gd5ijurJo3vi892DmuPpz6eP5YsuSCsBoyD';
    const proofOfAuthorityCID = 'QmRr3f12HHGSBYk3hpFuuAweKfcStQ16Vej81gr4GLbKU3';
    const proofOfSignatureCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const proofOfAgreementCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';

    const { proofs, signer1 } = await loadFixture(deployProofsFixture);

    await storeProofOfAuthority(agreementFileCID, proofOfAuthorityCID);
    await Promise.all(
      proofOfSignatureCIDs.map((posCID) =>
        storeProofOfSignature(agreementFileCID, proofOfAuthorityCID, posCID, proofs, signer1),
      ),
    );

    await proofs.fetchProofOfAgreementData(
      agreementFileCID,
      proofOfAuthorityCID,
      proofOfSignatureCIDs,
    );
    const proof = await proofs.fetchProofOfAgreementData.staticCall(
      agreementFileCID,
      proofOfAuthorityCID,
      proofOfSignatureCIDs,
    );

    // calculated & emited correctly
    await expect(
      proofs.storeProofOfAgreement(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfAgreementCID,
        // proof
      ),
    )
      .emit(proofs, 'ProofOfAgreement')
      .withArgs(agreementFileCID, proofOfAuthorityCID, proofOfAgreementCID, proof);

    // calculated & stored correctly
    expect(await proofs.finalProofs(agreementFileCID, proofOfAgreementCID)).eql(proof);
  });
});
