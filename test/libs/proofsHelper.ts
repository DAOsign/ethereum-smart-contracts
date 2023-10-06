import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import * as hre from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import {
  deployProofsHelper,
  deployProofsMetadata,
  deployStringsExpanded,
} from '../../scripts/deploy';
import { proofOfAuthorityData, proofOfSignatureData } from '../data/proofs';
import { Proofs } from '../common';
import { proofJSONtoBytes } from '../utils';
import { ProofsHelper, ProofsMetadata } from '../../typechain-types';

const { ethers } = hre;

describe('Proofs Helper', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { strings } = await deployStringsExpanded(hre);
    const stringsAddr = await strings.getAddress();
    const { proofsHelper } = await deployProofsHelper(hre, stringsAddr);
    const { proofsMetadata } = await deployProofsMetadata(hre, stringsAddr);

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
      proofsMetadata,
      proofsHelper,
      owner,
      creator,
      signer1,
      signer2,
      signer3,
      anyone,
    };
  }

  describe('Get Proof-of-Authority or Proof-of-Signature', () => {
    const signature = '0x123456';
    const data = JSON.stringify({ name: 'DAOsign' });

    it('no creator error', async () => {
      const { proofsHelper } = await loadFixture(deployProofsFixture);

      await expect(
        proofsHelper.getProofOfAuthorityOrSignature.staticCall(ethers.ZeroAddress, signature, data),
      ).revertedWith('No creator');
    });

    it('no signature error', async () => {
      const { proofsHelper, creator } = await loadFixture(deployProofsFixture);

      await expect(
        proofsHelper.getProofOfAuthorityOrSignature.staticCall(creator.address, '0x', data),
      ).revertedWith('No signature');
    });

    it('no data error', async () => {
      const { proofsHelper, creator } = await loadFixture(deployProofsFixture);

      await expect(
        proofsHelper.getProofOfAuthorityOrSignature.staticCall(creator.address, signature, ''),
      ).revertedWith('No data');
    });

    it('success', async () => {
      const { proofsHelper, creator } = await loadFixture(deployProofsFixture);

      expect(
        await proofsHelper.getProofOfAuthorityOrSignature.staticCall(
          creator.address,
          signature,
          data,
        ),
      ).equal(
        JSON.stringify({
          address: creator.address.toLowerCase(),
          sig: signature,
          data: { name: 'DAOsign' },
        }),
      );
    });
  });

  describe('Get Proof-of-Authority Data', () => {
    const agreementFileCID = 'QmWNiSjX22J3mYrJfBwxuVghcvyMEJa8dGkyvngf81Q4Gr';
    const version = '0.1.0';

    let creator: SignerWithAddress;
    let creatorAddr: string;
    let signersAddr: string[];
    let proofsHelper: ProofsHelper;
    let proofsMetadata: ProofsMetadata;

    beforeEach(async () => {
      let signer1: SignerWithAddress;
      let signer2: SignerWithAddress;
      ({ proofsHelper, proofsMetadata, creator, signer1, signer2 } =
        await loadFixture(deployProofsFixture));

      creatorAddr = creator.address;
      signersAddr = [signer1.address, signer2.address];
    });

    it('no creator error', async () => {
      await expect(
        proofsHelper.getProofOfAuthorityData.staticCall(
          proofsMetadata.getAddress(),
          ethers.ZeroAddress,
          signersAddr,
          agreementFileCID,
          version,
          await time.latest(),
        ),
      ).revertedWith('No creator');
    });

    it('no signers error', async () => {
      await expect(
        proofsHelper.getProofOfAuthorityData.staticCall(
          proofsMetadata.getAddress(),
          creatorAddr,
          [],
          agreementFileCID,
          version,
          await time.latest(),
        ),
      ).revertedWith('No signers');
    });

    it('no Agreement File CID error', async () => {
      await expect(
        proofsHelper.getProofOfAuthorityData.staticCall(
          proofsMetadata.getAddress(),
          creatorAddr,
          signersAddr,
          '',
          version,
          await time.latest(),
        ),
      ).revertedWith('No Agreement File CID');
    });

    it('no version error', async () => {
      await expect(
        proofsHelper.getProofOfAuthorityData.staticCall(
          proofsMetadata.getAddress(),
          creatorAddr,
          signersAddr,
          agreementFileCID,
          '',
          await time.latest(),
        ),
      ).revertedWith('No version');
    });

    it('success', async () => {
      const expectedRes: any = JSON.parse(JSON.stringify(proofOfAuthorityData));
      expectedRes.message = {
        from: creatorAddr.toLowerCase(),
        agreementFileCID,
        signers: signersAddr.map((signer) => ({ address: signer.toLowerCase(), metadata: {} })),
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(
        await proofsHelper.getProofOfAuthorityData.staticCall(
          proofsMetadata.getAddress(),
          creator.address,
          signersAddr,
          agreementFileCID,
          version,
          await time.latest(),
        ),
      ).equal(JSON.stringify(expectedRes));
    });
  });

  describe('Get Proof-of-Signature Data', () => {
    const poaCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const version = '0.1.0';

    let signer1: SignerWithAddress;
    let proofsHelper: ProofsHelper;
    let proofsMetadata: ProofsMetadata;

    beforeEach(async () => {
      ({ proofsHelper, proofsMetadata, signer1 } = await loadFixture(deployProofsFixture));
    });

    it('no signer error', async () => {
      await expect(
        proofsHelper.getProofOfSignatureData.staticCall(
          proofsMetadata.getAddress(),
          ethers.ZeroAddress,
          poaCID,
          version,
          await time.latest(),
        ),
      ).revertedWith('No signer');
    });

    it('no Proof-of-Authority CID error', async () => {
      await expect(
        proofsHelper.getProofOfSignatureData.staticCall(
          proofsMetadata.getAddress(),
          signer1.address,
          '',
          version,
          await time.latest(),
        ),
      ).revertedWith('No Proof-of-Authority CID');
    });

    it('no version error', async () => {
      await expect(
        proofsHelper.getProofOfSignatureData.staticCall(
          proofsMetadata.getAddress(),
          signer1.address,
          poaCID,
          '',
          await time.latest(),
        ),
      ).revertedWith('No version');
    });

    it('success', async () => {
      const expectedRes: any = JSON.parse(JSON.stringify(proofOfSignatureData));
      expectedRes.message = {
        signer: signer1.address.toLowerCase(),
        agreementFileProofCID: poaCID,
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(
        await proofsHelper.getProofOfSignatureData.staticCall(
          proofsMetadata.getAddress(),
          signer1.address,
          poaCID,
          version,
          await time.latest(),
        ),
      ).equal(JSON.stringify(expectedRes));
    });
  });

  describe('Get Proof-of-Agreement Data', () => {
    const proofOfAuthorityCID = 'QmeqpeRuuddxCZcgbSVNkHN1w7kGKBEAKWJSvsfDefeLMb';
    const proofOfSignatureCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const timestamp = 123456;
    const expectedProofOfAgreement = {
      agreementFileProofCID: proofOfAuthorityCID,
      agreementSignProofs: proofOfSignatureCIDs.map((proofCID) => ({ proofCID })),
      timestamp,
    };

    it('no Proof-of-Authority CID error', async () => {
      const { proofsHelper } = await loadFixture(deployProofsFixture);

      await expect(
        proofsHelper.getProofOfAgreementData.staticCall('', proofOfSignatureCIDs, timestamp),
      ).revertedWith('No Proof-of-Authority CID');
    });

    it('no Proof-of-Signature CID error', async () => {
      const { proofsHelper } = await loadFixture(deployProofsFixture);

      await expect(
        proofsHelper.getProofOfAgreementData.staticCall(
          proofOfAuthorityCID,
          [
            '',
            'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
            'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
          ],
          timestamp,
        ),
      ).revertedWith('No Proof-of-Signature CID');
      await expect(
        proofsHelper.getProofOfAgreementData.staticCall(
          proofOfAuthorityCID,
          [
            'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
            '',
            'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
          ],
          timestamp,
        ),
      ).revertedWith('No Proof-of-Signature CID');
      await expect(
        proofsHelper.getProofOfAgreementData.staticCall(
          proofOfAuthorityCID,
          [
            'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
            'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
            '',
          ],
          timestamp,
        ),
      ).revertedWith('No Proof-of-Signature CID');
    });

    it('success', async () => {
      const { proofsHelper } = await loadFixture(deployProofsFixture);

      expect(
        await proofsHelper.getProofOfAgreementData.staticCall(
          proofOfAuthorityCID,
          proofOfSignatureCIDs,
          timestamp,
        ),
      ).equal(JSON.stringify(expectedProofOfAgreement));
    });
  });
});
