import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { deployProofs, deployProofsMetadata } from '../scripts/deployForTest';
import { proofOfAuthorityData, proofOfSignatureData } from './data/proofs';
import { Proofs } from './common';

describe('Proofs', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofs, proofsMetadata, strings, proofsVerification } = await deployProofs();

    await proofsMetadata.addMetadata(
      Proofs.ProofOfAuthority,
      '0.1.0',
      JSON.stringify(proofOfAuthorityData).slice(0, -1)
    );
    await proofsMetadata.addMetadata(
      Proofs.ProofOfSignature,
      '0.1.0',
      JSON.stringify(proofOfSignatureData).slice(0, -1)
    );

    return {
      proofs,
      strings,
      proofsVerification,
      owner,
      creator,
      signer1,
      signer2,
      signer3,
      anyone,
    };
  }

  describe('constructor', () => {
    it('error on non-IERC165 and non-IProofsMetadata input', async () => {
      const { proofs, strings, proofsVerification, anyone } = await loadFixture(
        deployProofsFixture
      );

      // zero address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
            },
          })
        ).deploy(ethers.ZeroAddress)
      ).revertedWith('Must support IProofsMetadata');
      // EOA (user address)
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
            },
          })
        ).deploy(anyone.address)
      ).revertedWith('Must support IProofsMetadata');
      // ranom contract address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
            },
          })
        ).deploy(await proofs.getAddress())
      ).revertedWith('Must support IProofsMetadata');
    });

    it('success', async () => {
      const { strings, proofsVerification } = await loadFixture(deployProofsFixture);
      const { proofsMetadata } = await deployProofsMetadata();

      const proofs = await (
        await ethers.getContractFactory('Proofs', {
          libraries: {
            StringsExpanded: await strings.getAddress(),
            ProofsVerification: await proofsVerification.getAddress(),
          },
        })
      ).deploy(await proofsMetadata.getAddress());

      expect(await proofs.proofsMetadata()).equal(await proofsMetadata.getAddress());
    });
  });

  describe('Get Proof-of-Authority data', () => {
    it('no creator error', async () => {
      const { proofs, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfAuthorityData(
          /* creator */ ethers.ZeroAddress,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ '0.1.0'
        )
      ).revertedWith('No creator');
    });

    it('no signers error', async () => {
      const { proofs, creator } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ '0.1.0'
        )
      ).revertedWith('No signers');
    });

    it('no Agreement File CID error', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ '',
          /* version */ '0.1.0'
        )
      ).revertedWith('No Agreement File CID');
    });

    it('no version error', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ ''
        )
      ).revertedWith('No version');
    });

    it('success', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const version = '0.1.0';

      await proofs.getProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version
      );
      const res = await proofs.getProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version
      );

      const expectedRes: any = proofOfAuthorityData;
      expectedRes.message = {
        from: creator.address,
        agreementFileCID,
        signers: signers.map((signer) => ({ address: signer, metadata: {} })),
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.proofsData(agreementFileCID, Proofs.ProofOfAuthority, creator.address));
      // TODO: add the second execution of `getProofOfAuthorityData` and make sure that is uses less
      //       gas than before because now it returns cached data
    });
  });

  describe('Get Proof-of-Signature data', () => {
    const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const agreementFileProofCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';

    it('no signer error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfSignatureData.staticCall(
          ethers.ZeroAddress,
          agreementFileCID,
          agreementFileProofCID,
          '0.1.0'
        )
      ).revertedWith('No signer');
    });

    it('no Agreement File CID error', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfSignatureData.staticCall(
          signer1.address,
          '',
          agreementFileProofCID,
          '0.1.0'
        )
      ).revertedWith('No Agreement File CID');
    });

    it('no Proof-of-Authority CID error', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfSignatureData.staticCall(signer1.address, agreementFileCID, '', '0.1.0')
      ).revertedWith('No Proof-of-Authority CID');
    });

    it('no version error', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.getProofOfSignatureData.staticCall(
          signer1.address,
          agreementFileCID,
          agreementFileProofCID,
          ''
        )
      ).revertedWith('No version');
    });

    it('success', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);
      const res = await proofs.getProofOfSignatureData.staticCall(
        signer1.address,
        agreementFileCID,
        agreementFileProofCID,
        '0.1.0'
      );

      const expectedRes: any = proofOfSignatureData;
      expectedRes.message = {
        signer: signer1.address,
        agreementFileProofCID,
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      // TODO: add the second execution of `getProofOfSignatureData` and make sure that is uses less
      //       gas than before because now it returns cached data
    });
  });

  describe('Store Proof-of-Authority', () => {
    const agreementFileCID = 'QmRf22bZar3WKmojipms22PkXH1MZGmvsqzQtuSvQE3uhm';
    const proofCID = 'QmYAkbM4UCPDLBewYcjP57ZAZD2rY9oYQ1BJR1t8qt7XpF';
    const version = '0.1.0';
    let proof: unknown;
    let proofs: any;
    let creator: SignerWithAddress;
    let signer1: SignerWithAddress;
    let signer2: SignerWithAddress;
    let signer3: SignerWithAddress;
    let signature: string;
    let signatureSigner1: string;

    beforeEach(async () => {
      ({ proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture));
      const signers = [signer1.address, signer2.address, signer3.address];

      await proofs.getProofOfAuthorityData(creator.address, signers, agreementFileCID, version);
      const data = await proofs.getProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version
      );

      const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
      signature = await creator.signMessage(ethers.getBytes(dataHash));
      signatureSigner1 = await signer1.signMessage(ethers.getBytes(dataHash));
      proof = {
        address: creator.address.toLocaleLowerCase(),
        sig: signature,
        data: JSON.parse(data),
      };
    });

    it('error: Empty ProofCID', async () => {
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, '')
      ).revertedWith('Empty ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID);
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID)
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfAuthority(creator.address, signatureSigner1, agreementFileCID, proofCID)
      ).revertedWith('Invalid signature');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID)
      )
        .emit(proofs, 'ProofOfAuthority')
        .withArgs(creator.address, signature, agreementFileCID, proofCID, JSON.stringify(proof));

      // calculated & stored correctly
      expect(JSON.parse(await proofs.signedProofs(agreementFileCID, proofCID))).eql(proof);
    });
  });

  describe('Store Proof-of-Signature', () => {
    const agreementFileCID = 'QmRf22bZar3WKmojipms22PkXH1MZGmvsqzQtuSvQE3uhm';
    const proofOfAuthorityCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const proofOfSignatureCID = 'QmYAkbM4UCPDLBewYcjP57ZAZD2rY9oYQ1BJR1t8qt7XpF';
    const version = '0.1.0';
    let proof: unknown;
    let proofs: any;
    let signer1: SignerWithAddress;
    let signer2: SignerWithAddress;
    let signature: string;
    let signatureSigner2: string;

    beforeEach(async () => {
      ({ proofs, signer1, signer2 } = await loadFixture(deployProofsFixture));

      await proofs.getProofOfSignatureData(
        signer1.address,
        agreementFileCID,
        proofOfAuthorityCID,
        version
      );
      const data = await proofs.getProofOfSignatureData.staticCall(
        signer1.address,
        agreementFileCID,
        proofOfAuthorityCID,
        version
      );

      const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
      signature = await signer1.signMessage(ethers.getBytes(dataHash));
      signatureSigner2 = await signer2.signMessage(ethers.getBytes(dataHash));
      proof = {
        address: signer1.address.toLocaleLowerCase(),
        sig: signature,
        data: JSON.parse(data),
      };
    });

    it('error: Empty ProofCID', async () => {
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, agreementFileCID, '')
      ).revertedWith('Empty ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfSignature(
        signer1.address,
        signature,
        agreementFileCID,
        proofOfSignatureCID
      );
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID
        )
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signatureSigner2,
          agreementFileCID,
          proofOfSignatureCID
        )
      ).revertedWith('Invalid signature');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID
        )
      )
        .emit(proofs, 'ProofOfSignature')
        .withArgs(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID,
          JSON.stringify(proof)
        );

      // calculated & stored correctly
      expect(JSON.parse(await proofs.signedProofs(agreementFileCID, proofOfSignatureCID))).eql(
        proof
      );
    });
  });
});
