import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofs, deployProofsMetadata } from '../scripts/deployForTest';
import { proofOfAuthorityData } from './data/proofs';

describe('Proofs', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofs, proofsMetadata, strings } = await deployProofs();

    await proofsMetadata.addMetadata(
      'Proof-of-Authority',
      '0.1.0',
      JSON.stringify(proofOfAuthorityData).slice(0, -1)
    );

    return { proofs, strings, owner, creator, signer1, signer2, signer3, anyone };
  }

  describe('constructor', () => {
    it('error on non-IERC165 and non-IProofsMetadata input', async () => {
      const { proofs, strings, anyone } = await loadFixture(deployProofsFixture);

      // zero address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: { Strings: await strings.getAddress() },
          })
        ).deploy(ethers.ZeroAddress)
      ).revertedWith('Must support IProofsMetadata');
      // EOA (user address)
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: { Strings: await strings.getAddress() },
          })
        ).deploy(anyone.address)
      ).revertedWith('Must support IProofsMetadata');
      // ranom contract address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: { Strings: await strings.getAddress() },
          })
        ).deploy(await proofs.getAddress())
      ).revertedWith('Must support IProofsMetadata');
    });

    it('success', async () => {
      const { proofsMetadata, strings } = await deployProofsMetadata();

      const proofs = await (
        await ethers.getContractFactory('Proofs', {
          libraries: { Strings: await strings.getAddress() },
        })
      ).deploy(await proofsMetadata.getAddress());

      expect(await proofs.proofsMetadata()).equal(await proofsMetadata.getAddress());
    });
  });

  describe('getProofOfAuthorityData', () => {
    it('success', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const res = await proofs.getProofOfAuthorityData.staticCall(
        creator,
        signers,
        agreementFileCID,
        '0.1.0'
      );

      const expectedRes: any = proofOfAuthorityData;
      expectedRes.message = {
        from: '0x70997970c51812dc3a010c7d01b50e0d17dc79c8',
        agreementFileCID: 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
        signers: signers.map((signer) => ({ address: signer, metadata: {} })),
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);
    });
  });
});
