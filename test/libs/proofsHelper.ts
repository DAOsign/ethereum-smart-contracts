import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofsHelperLibrary } from '../../scripts/deployForTest';

describe('Proofs Helper', () => {
  async function deployProofsHelperFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofsHelper } = await deployProofsHelperLibrary();

    return { proofsHelper, owner, creator, signer1, signer2, signer3, anyone };
  }

  describe('Get Proof-of-Agreement Data', () => {
    const proofOfAuthorityCID = 'QmRr3f12HHGSBYk3hpFuuAweKfcStQ16Vej81gr4GLbKU3';
    const proofOfSignatureCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const timestamp = 123456;

    it('no Proof-of-Authority CID error', async () => {
      const { proofsHelper } = await loadFixture(deployProofsHelperFixture);

      await expect(
        proofsHelper.getProofOfAgreementData.staticCall('', proofOfSignatureCIDs, timestamp),
      ).revertedWith('No Proof-of-Authority CID');
    });

    it('no Proof-of-Signature CID error', async () => {
      const { proofsHelper } = await loadFixture(deployProofsHelperFixture);

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
      // TODO
    });
  });

  // TODO: test other functions
});
