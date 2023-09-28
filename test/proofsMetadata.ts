import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployProofsMetadata } from '../scripts/deployForTest';
import { Proofs } from './common';
import { ProofsMetadata } from '../typechain-types';
import { proofJSONtoBytes } from './utils';

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
        proofsMetadata
          .connect(anyone)
          .addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({})),
      ).revertedWith('Ownable: caller is not the owner');
      await proofsMetadata
        .connect(owner)
        .addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));
    });

    it('empty input params', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '', proofJSONtoBytes({})),
      ).rejectedWith('Input params cannot be empty');
      await expect(proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', '0x')).rejectedWith(
        'Input params cannot be empty',
      );
    });

    it('metadata already exists', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));
      await proofsMetadata.addMetadata(
        Proofs.ProofOfAuthority,
        '0.2.0',
        proofJSONtoBytes({ domain: 'daosign' }),
      );
      await expect(
        proofsMetadata.addMetadata(
          Proofs.ProofOfAuthority,
          '0.1.0',
          proofJSONtoBytes({ domain: 'daosign' }),
        ),
      ).revertedWith('Metadata already exists');
    });

    it('success, emits an event', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({})),
      )
        .emit(proofsMetadata, 'MetadataAdded')
        .withArgs(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));
      await expect(
        proofsMetadata.addMetadata(
          Proofs.ProofOfAuthority,
          '0.2.0',
          proofJSONtoBytes({ domain: 'daosign' }),
        ),
      )
        .emit(proofsMetadata, 'MetadataAdded')
        .withArgs(Proofs.ProofOfAuthority, '0.2.0', proofJSONtoBytes({ domain: 'daosign' }));
    });
  });

  describe('forceUpdateMetadata', () => {
    it('only owner', async () => {
      const { proofsMetadata, anyone, owner } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata
        .connect(owner)
        .addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));

      await expect(
        proofsMetadata
          .connect(anyone)
          .forceUpdateMetadata(
            Proofs.ProofOfAuthority,
            '0.1.0',
            proofJSONtoBytes({ domain: 'daosign' }),
          ),
      ).revertedWith('Ownable: caller is not the owner');
      await proofsMetadata
        .connect(owner)
        .forceUpdateMetadata(
          Proofs.ProofOfAuthority,
          '0.1.0',
          proofJSONtoBytes({ domain: 'daosign' }),
        );
    });

    it('empty input params', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));

      await expect(
        proofsMetadata.forceUpdateMetadata(Proofs.ProofOfAuthority, '', proofJSONtoBytes({})),
      ).rejectedWith('Input params cannot be empty');
      await expect(
        proofsMetadata.forceUpdateMetadata(Proofs.ProofOfAuthority, '0.1.0', '0x'),
      ).rejectedWith('Input params cannot be empty');
    });

    it('metadata does not exist', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);

      await expect(
        proofsMetadata.forceUpdateMetadata(
          Proofs.ProofOfAuthority,
          '0.1.0',
          proofJSONtoBytes({ domain: 'daosign' }),
        ),
      ).revertedWith('Metadata does not exist');
      await proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));
      await proofsMetadata.forceUpdateMetadata(
        Proofs.ProofOfAuthority,
        '0.1.0',
        proofJSONtoBytes({ domain: 'daosign' }),
      );
    });

    it('success, emits an event', async () => {
      const { proofsMetadata } = await loadFixture(deployProofsMetadataFixture);
      await proofsMetadata.addMetadata(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({}));

      await expect(
        proofsMetadata.forceUpdateMetadata(
          Proofs.ProofOfAuthority,
          '0.1.0',
          proofJSONtoBytes({ domain: 'daosign' }),
        ),
      )
        .emit(proofsMetadata, 'MetadataUpdated')
        .withArgs(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({ domain: 'daosign' }));
      await expect(
        proofsMetadata.forceUpdateMetadata(
          Proofs.ProofOfAuthority,
          '0.1.0',
          proofJSONtoBytes({ type: 'contract' }),
        ),
      )
        .emit(proofsMetadata, 'MetadataUpdated')
        .withArgs(Proofs.ProofOfAuthority, '0.1.0', proofJSONtoBytes({ type: 'contract' }));
    });
  });

  describe('get metadata', () => {
    let proofsMetadata: ProofsMetadata;

    before(async () => {
      ({ proofsMetadata } = await loadFixture(deployProofsMetadataFixture));
      await proofsMetadata.addMetadata(
        Proofs.ProofOfAuthority,
        '0.1.0',
        proofJSONtoBytes({ domain: 'daosign' }),
      );
      await proofsMetadata.addMetadata(
        Proofs.ProofOfSignature,
        '0.1.0',
        proofJSONtoBytes({ signer: 0x12345 }),
      );
      await proofsMetadata.addMetadata(
        Proofs.ProofOfAuthority,
        '0.2.0',
        proofJSONtoBytes({ domain: 'daosign' }),
      );
    });

    it('get proofsMetadata', async () => {
      expect(await proofsMetadata.proofsMetadata(Proofs.ProofOfAuthority, '0.3.0')).equal('0x');
      expect(await proofsMetadata.proofsMetadata(Proofs.ProofOfAuthority, '0.1.0')).equal(
        proofJSONtoBytes({ domain: 'daosign' }),
      );
      expect(await proofsMetadata.proofsMetadata(Proofs.ProofOfSignature, '0.1.0')).equal(
        proofJSONtoBytes({ signer: 0x12345 }),
      );
      expect(await proofsMetadata.proofsMetadata(Proofs.ProofOfAuthority, '0.2.0')).equal(
        proofJSONtoBytes({ domain: 'daosign' }),
      );

      await proofsMetadata.forceUpdateMetadata(
        Proofs.ProofOfAuthority,
        '0.1.0',
        proofJSONtoBytes({}),
      );

      expect(await proofsMetadata.proofsMetadata(Proofs.ProofOfAuthority, '0.1.0')).equal(
        proofJSONtoBytes({}),
      );
    });

    it('getMetadataNumOfVersions', async () => {
      expect(await proofsMetadata.getMetadataNumOfVersions(Proofs.ProofOfAuthority)).equal(2);
      expect(await proofsMetadata.getMetadataNumOfVersions(Proofs.ProofOfSignature)).equal(1);
      expect(await proofsMetadata.getMetadataNumOfVersions(Proofs.ProofOfAgreement)).equal(0);
    });

    it('get metadataVersions', async () => {
      expect(await proofsMetadata.metadataVersions(Proofs.ProofOfAuthority, 0)).equal('0.1.0');
      expect(await proofsMetadata.metadataVersions(Proofs.ProofOfAuthority, 1)).equal('0.2.0');
      expect(await proofsMetadata.metadataVersions(Proofs.ProofOfSignature, 0)).equal('0.1.0');
    });
  });
});
