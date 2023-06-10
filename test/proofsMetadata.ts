import { time, loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { anyValue } from '@nomicfoundation/hardhat-chai-matchers/withArgs';
import { expect } from 'chai';
import { ethers } from 'hardhat';

describe.only('Proofs Metadata', () => {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployProofsMetadataFixture() {
    const [owner, anyone] = await ethers.getSigners();
    const proofsMetadata = await (await ethers.getContractFactory('ProofsMetadata')).deploy();

    return { proofsMetadata, owner, anyone };
  }

  describe('addMetadata', () => {
    it('only owner', async () => {
      const { proofsMetadata, anyone, owner } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.connect(anyone).addMetadata('Proof-of-Authority', '0.1.0', '{}')
      ).revertedWith('Ownable: caller is not the owner');
      await proofsMetadata.connect(owner).addMetadata('Proof-of-Authority', '0.1.0', '{}');
    });

    it('empty input params', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(proofsMetadata.addMetadata('', '0.1.0', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(proofsMetadata.addMetadata('Proof-of-Authority', '', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '')).rejectedWith(
        'Input params cannot be empty'
      );
    });

    it('metadata already exists', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.2.0', '{ domain: "daosign" }');
      await expect(
        proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      ).revertedWith('Metadata already exists; update it');
    });

    it('success', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.2.0', '{ domain: "daosign" }');
    });
  });

  describe('updateMetadata', () => {
    it('only owner', async () => {
      const { proofsMetadata, anyone, owner } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.connect(owner).addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await expect(
        proofsMetadata
          .connect(anyone)
          .updateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      ).revertedWith('Ownable: caller is not the owner');
      await proofsMetadata
        .connect(owner)
        .updateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
    });

    it('empty input params', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await expect(proofsMetadata.updateMetadata('', '0.1.0', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(proofsMetadata.updateMetadata('Proof-of-Authority', '', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(proofsMetadata.updateMetadata('Proof-of-Authority', '0.1.0', '')).rejectedWith(
        'Input params cannot be empty'
      );
    });

    it('metadata does not exist', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.updateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      ).revertedWith('Metadata does not exist; add it first');
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');
      await proofsMetadata.updateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
    });

    it('success', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await proofsMetadata.updateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
      await proofsMetadata.updateMetadata('Proof-of-Authority', '0.1.0', '{ type: "contract" }');
    });
  });
});
