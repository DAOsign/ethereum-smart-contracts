import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofsMetadata } from '../scripts/deployForTest';
import { ProofsMetadata } from '../typechain-types';

describe('Proofs Metadata', () => {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployProofsMetadataFixture() {
    const [owner, anyone] = await ethers.getSigners();
    const { proofsMetadata } = await deployProofsMetadata();

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
      ).revertedWith('Metadata already exists');
    });

    it('success, emits an event', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}'))
        .emit(proofsMetadata, 'MetadataAdded')
        .withArgs('Proof-of-Authority', '0.1.0', '{}');
      await expect(
        proofsMetadata.addMetadata('Proof-of-Authority', '0.2.0', '{ domain: "daosign" }')
      )
        .emit(proofsMetadata, 'MetadataAdded')
        .withArgs('Proof-of-Authority', '0.2.0', '{ domain: "daosign" }');
    });
  });

  describe('forceUpdateMetadata', () => {
    it('only owner', async () => {
      const { proofsMetadata, anyone, owner } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.connect(owner).addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await expect(
        proofsMetadata
          .connect(anyone)
          .forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      ).revertedWith('Ownable: caller is not the owner');
      await proofsMetadata
        .connect(owner)
        .forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
    });

    it('empty input params', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await expect(proofsMetadata.forceUpdateMetadata('', '0.1.0', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '', '{}')).rejectedWith(
        'Input params cannot be empty'
      );
      await expect(
        proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '0.1.0', '')
      ).rejectedWith('Input params cannot be empty');
    });

    it('metadata does not exist', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      ).revertedWith('Metadata does not exist');
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');
      await proofsMetadata.forceUpdateMetadata(
        'Proof-of-Authority',
        '0.1.0',
        '{ domain: "daosign" }'
      );
    });

    it('success, emits an event', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{}');

      await expect(
        proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }')
      )
        .emit(proofsMetadata, 'MetadataUpdated')
        .withArgs('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
      await expect(
        proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{ type: "contract" }')
      )
        .emit(proofsMetadata, 'MetadataUpdated')
        .withArgs('Proof-of-Authority', '0.1.0', '{ type: "contract" }');
    });
  });

  describe('get metadata', () => {
    let proofsMetadata: ProofsMetadata;

    before(async () => {
      ({ proofsMetadata } = await loadFixture(deployProofsMetadataFixture));
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.1.0', '{ domain: "daosign" }');
      await proofsMetadata.addMetadata('Proof-of-Signature', '0.1.0', '{ signer: 0x12345 }');
      await proofsMetadata.addMetadata('Proof-of-Authority', '0.2.0', '{ domain: "DAOsign" }');
    });

    it('get proofsMetadata', async () => {
      expect(await proofsMetadata.proofsMetadata('Proof-of-Authority', '0.3.0')).equal('');
      expect(await proofsMetadata.proofsMetadata('Proof-of-Authority', '0.1.0')).equal(
        '{ domain: "daosign" }'
      );
      expect(await proofsMetadata.proofsMetadata('Proof-of-Signature', '0.1.0')).equal(
        '{ signer: 0x12345 }'
      );
      expect(await proofsMetadata.proofsMetadata('Proof-of-Authority', '0.2.0')).equal(
        '{ domain: "DAOsign" }'
      );

      await proofsMetadata.forceUpdateMetadata('Proof-of-Authority', '0.1.0', '{}');

      expect(await proofsMetadata.proofsMetadata('Proof-of-Authority', '0.1.0')).equal('{}');
    });

    it('getMetadataNumOfVersions', async () => {
      expect(await proofsMetadata.getMetadataNumOfVersions('Proof-of-Authority')).equal(2);
      expect(await proofsMetadata.getMetadataNumOfVersions('Proof-of-Signature')).equal(1);
      expect(await proofsMetadata.getMetadataNumOfVersions('Proof-of-Agreement')).equal(0);
    });

    it('get metadataVersions', async () => {
      expect(await proofsMetadata.metadataVersions('Proof-of-Authority', 0)).equal('0.1.0');
      expect(await proofsMetadata.metadataVersions('Proof-of-Authority', 1)).equal('0.2.0');
      expect(await proofsMetadata.metadataVersions('Proof-of-Signature', 0)).equal('0.1.0');
    });
  });
});
