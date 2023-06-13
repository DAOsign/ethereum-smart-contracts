import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofs } from '../scripts/deploy';

describe('Proofs', () => {
  async function deployProofsFixture() {
    const [owner, anyone] = await ethers.getSigners();
    const proofs = await deployProofs();

    return { proofs, owner, anyone };
  }

  describe('constructor', () => {
    it('error on non-IERC165 and non-IProofsMetadata input', async () => {
      const { proofs, anyone } = await loadFixture(deployProofsFixture);

      // zero address
      await expect(
        (await ethers.getContractFactory('Proofs')).deploy(ethers.ZeroAddress)
      ).revertedWith('Must support IProofsMetadata');
      // EOA (user address)
      await expect((await ethers.getContractFactory('Proofs')).deploy(anyone.address)).revertedWith(
        'Must support IProofsMetadata'
      );
      // ranom contract address
      await expect(
        (await ethers.getContractFactory('Proofs')).deploy(await proofs.getAddress())
      ).revertedWith('Must support IProofsMetadata');
    });
  });
});
