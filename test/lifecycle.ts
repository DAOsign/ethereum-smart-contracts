import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import * as hre from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { deployAll } from '../scripts/deploy';
import { proofOfAuthorityData, proofOfSignatureData } from './data/proofs';
import { Proofs } from './common';
import { proofJSONtoBytes } from './utils';

const { ethers } = hre;

describe('Lifecycle Tests of the Platform', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofs, proofsMetadata, strings, proofsVerification, proofsHelper } = await deployAll(
      hre,
      owner.address,
    );

    await proofsMetadata.addMetadata(
      Proofs.ProofOfAuthority,
      '0.1.0',
      proofJSONtoBytes(proofOfAuthorityData),
    );
    await proofsMetadata.addMetadata(
      Proofs.ProofOfSignature,
      '0.1.0',
      proofJSONtoBytes(proofOfSignatureData),
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

  const storeProofOfAuthority = async (
    fileCID: string,
    poaCID: string,
    creator: SignerWithAddress,
    proofs: any,
    signers: SignerWithAddress[],
    version: string,
  ) => {
    const dataSig = await creator.signMessage(
      ethers.getBytes(
        ethers.keccak256(
          ethers.solidityPacked(
            ['address', 'address[]', 'string', 'string'],
            [creator.address, signers.map((x) => x.address), fileCID, version],
          ),
        ),
      ),
    );

    // Fetch proof data
    await proofs.fetchProofOfAuthorityData(
      creator.address,
      signers.map((x) => x.address),
      fileCID,
      version,
      dataSig,
    );
    const proofData = await proofs.fetchProofOfAuthorityData.staticCall(
      creator.address,
      signers,
      fileCID,
      version,
      dataSig,
    );

    // Sign proof data & generate Proof-of-Authority
    const proofDataHash = ethers.keccak256(ethers.toUtf8Bytes(proofData));
    const signature = await creator.signMessage(ethers.getBytes(proofDataHash));

    const proof = {
      address: creator.address.toLowerCase(),
      sig: signature,
      data: JSON.parse(proofData),
    };

    // calculated & emited correctly
    await expect(
      proofs.storeProofOfAuthority(creator.address, signers, version, signature, fileCID, poaCID),
    )
      .emit(proofs, 'ProofOfAuthority')
      .withArgs(creator.address, signature, fileCID, poaCID, JSON.stringify(proof, null));

    // calculated & stored correctly
    expect(await proofs.finalProofs(fileCID, poaCID)).eql(JSON.stringify(proof, null));
  };

  const storeProofOfSignature = async (
    fileCID: string,
    poaCID: string,
    posCID: string,
    proofs: any,
    version: string,
    signer: SignerWithAddress,
  ) => {
    const dataSig = await signer.signMessage(
      ethers.getBytes(
        ethers.keccak256(
          ethers.solidityPacked(
            ['address', 'string', 'string', 'string'],
            [signer.address, fileCID, poaCID, version],
          ),
        ),
      ),
    );

    // Fetch proof data
    await proofs.fetchProofOfSignatureData(signer, fileCID, poaCID, version, dataSig);
    const proofData = await proofs.fetchProofOfSignatureData.staticCall(
      signer,
      fileCID,
      poaCID,
      version,
      dataSig,
    );

    // Sign proof data & generate Proof-of-Signature
    const proofDataHash = ethers.keccak256(ethers.toUtf8Bytes(proofData));
    const signature = await signer.signMessage(ethers.getBytes(proofDataHash));

    const proof = {
      address: signer.address.toLowerCase(),
      sig: signature,
      data: JSON.parse(proofData),
    };

    // calculated & emited correctly
    await expect(
      proofs.storeProofOfSignature(signer.address, signature, fileCID, posCID, poaCID, version),
    )
      .emit(proofs, 'ProofOfSignature')
      .withArgs(signer.address, signature, fileCID, posCID, JSON.stringify(proof, null));

    // calculated & stored correctly
    expect(await proofs.finalProofs(fileCID, posCID)).eql(JSON.stringify(proof, null));
  };

  const storeProofOfAgreement = async (
    fileCID: string,
    poaCID: string,
    posCIDs: string[],
    poagCID: string,
    proofs: any,
  ) => {
    await proofs.fetchProofOfAgreementData(fileCID, poaCID, posCIDs);
    const proof = await proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs);

    // calculated & emited correctly
    await expect(proofs.storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID))
      .emit(proofs, 'ProofOfAgreement')
      .withArgs(fileCID, poaCID, poagCID, proof);

    // calculated & stored correctly
    expect(await proofs.finalProofs(fileCID, poagCID)).eql(proof);
  };

  it('3 signers', async () => {
    const fileCID = 'QmfVd78Pns7Gd5ijurJo3vi892DmuPpz6eP5YsuSCsBoyD';
    const poaCID = 'QmRr3f12HHGSBYk3hpFuuAweKfcStQ16Vej81gr4GLbKU3';
    const posCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const poagCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const version = '0.1.0';
    const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
    const signers = [signer1, signer2, signer3];

    await storeProofOfAuthority(fileCID, poaCID, creator, proofs, signers, version);
    await Promise.all(
      posCIDs.map((posCID, i) =>
        storeProofOfSignature(fileCID, poaCID, posCID, proofs, version, signers[i]),
      ),
    );
    await storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID, proofs);
  });

  it('1 signer, same as creator', async () => {
    const fileCID = 'QmVXk8pWLEa2hXEdqkeHDkqrnZqq5XHMniFzeoJc2dQx73';
    const poaCID = 'QmW4GUkS3MKNJMvJH8AJQNcXPYDbBWe7NwUiCZzVwLQrYD';
    const posCIDs = ['QmYZnzmLLoK86x9DXnoNX8NLhVALdmtkuhNnFzTmwmecSz'];
    const poagCID = 'QmRBvTnJcpGSwGULVS6D8Pq39tQHQpM5nFdCMnbVrVEDpJ';
    const version = '0.1.0';
    const { proofs, creator } = await loadFixture(deployProofsFixture);
    const signers = [creator];

    await storeProofOfAuthority(fileCID, poaCID, creator, proofs, signers, version);
    await Promise.all(
      posCIDs.map((posCID) =>
        storeProofOfSignature(fileCID, poaCID, posCID, proofs, version, creator),
      ),
    );
    await storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID, proofs);
  });
});
