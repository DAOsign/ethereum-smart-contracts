import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { deployProofs, deployProofsMetadata } from '../scripts/deploy';
import { proofOfAuthorityData, proofOfSignatureData } from './data/proofs';
import { Proofs } from './common';
import { proofJSONtoBytes } from './utils';

describe('Proofs', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    const { proofs, proofsMetadata, strings, proofsVerification, proofsHelper } =
      await deployProofs();

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

  describe('constructor', () => {
    it('error on non-IERC165 and non-IProofsMetadata input', async () => {
      const { proofs, strings, proofsVerification, proofsHelper, anyone } =
        await loadFixture(deployProofsFixture);

      // zero address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
              ProofsHelper: await proofsHelper.getAddress(),
            },
          })
        ).deploy(ethers.ZeroAddress),
      ).revertedWith('Must support IProofsMetadata');
      // EOA (user address)
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
              ProofsHelper: await proofsHelper.getAddress(),
            },
          })
        ).deploy(anyone.address),
      ).revertedWith('Must support IProofsMetadata');
      // ranom contract address
      await expect(
        (
          await ethers.getContractFactory('Proofs', {
            libraries: {
              StringsExpanded: await strings.getAddress(),
              ProofsVerification: await proofsVerification.getAddress(),
              ProofsHelper: await proofsHelper.getAddress(),
            },
          })
        ).deploy(await proofs.getAddress()),
      ).revertedWith('Must support IProofsMetadata');
    });

    it('success', async () => {
      const { strings, proofsVerification, proofsHelper } = await loadFixture(deployProofsFixture);
      const { proofsMetadata } = await deployProofsMetadata();

      const proofs = await (
        await ethers.getContractFactory('Proofs', {
          libraries: {
            StringsExpanded: await strings.getAddress(),
            ProofsVerification: await proofsVerification.getAddress(),
            ProofsHelper: await proofsHelper.getAddress(),
          },
        })
      ).deploy(await proofsMetadata.getAddress());

      expect(await proofs.proofsMetadata()).equal(await proofsMetadata.getAddress());
    });
  });

  describe('Fetch Proof-of-Authority data', () => {
    it('no creator error', async () => {
      const { proofs, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAuthorityData(
          /* creator */ ethers.ZeroAddress,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ '0.1.0',
        ),
      ).revertedWith('No creator');
    });

    it('no signers error', async () => {
      const { proofs, creator } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ '0.1.0',
        ),
      ).revertedWith('No signers');
    });

    it('no Agreement File CID error', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ '',
          /* version */ '0.1.0',
        ),
      ).revertedWith('No Agreement File CID');
    });

    it('no version error', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAuthorityData(
          /* creator */ creator.address,
          /* signers */ [signer1.address, signer2.address, signer3.address],
          /* agreementFileCID */ 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp',
          /* version */ '',
        ),
      ).revertedWith('No version');
    });

    it('success', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const version = '0.1.0';

      let res = await proofs.fetchProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version,
      );

      let expectedRes: any = JSON.parse(JSON.stringify(proofOfAuthorityData));
      expectedRes.message = {
        from: creator.address,
        agreementFileCID,
        signers: signers.map((signer) => ({ address: signer, metadata: {} })),
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);

      /**
       * the second execution of `fetchProofOfAuthorityData` uses less
       * gas than before because now it returns a cached data
       */
      // first real function execution (more gas)
      const tx1 = await proofs.fetchProofOfAuthorityData(
        creator.address,
        signers,
        agreementFileCID,
        version,
      );
      const proofTime = await time.latest();
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.message.timestamp = await time.latest();
      expect(
        JSON.parse(
          await proofs.proofsData(agreementFileCID, Proofs.ProofOfAuthority, creator.address),
        ),
      ).to.deep.equal(expectedRes);

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfAuthorityData(
        creator.address,
        signers,
        agreementFileCID,
        version,
      );
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version,
      );

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expectedRes = proofOfAuthorityData;
      expectedRes.message = {
        from: creator.address,
        agreementFileCID,
        signers: signers.map((signer) => ({ address: signer, metadata: {} })),
        app: 'daosign',
        timestamp: proofTime,
        metadata: {},
      };
      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.proofsData(agreementFileCID, Proofs.ProofOfAuthority, creator.address));
    });
  });

  describe('Fetch Proof-of-Signature data', () => {
    const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const agreementFileProofCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    let proofs: any;
    let signer1: SignerWithAddress;
    const version = '0.1.0';

    beforeEach(async () => {
      ({ proofs, signer1 } = await loadFixture(deployProofsFixture));
      await storeProofOfAuthority(agreementFileCID, agreementFileProofCID);
    });

    it('no signer error', async () => {
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(
          ethers.ZeroAddress,
          agreementFileCID,
          agreementFileProofCID,
          version,
        ),
      ).revertedWith('No signer');
    });

    it('no Agreement File CID error', async () => {
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(
          signer1.address,
          '',
          agreementFileProofCID,
          version,
        ),
      ).revertedWith('No Agreement File CID');
    });

    it('no Proof-of-Authority CID error', async () => {
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(signer1.address, agreementFileCID, '', version),
      ).revertedWith('No Proof-of-Authority');
    });

    it('no version error', async () => {
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(
          signer1.address,
          agreementFileCID,
          agreementFileProofCID,
          '',
        ),
      ).revertedWith('No version');
    });

    it('success', async () => {
      let res = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        agreementFileCID,
        agreementFileProofCID,
        '0.1.0',
      );

      let expectedRes: any = JSON.parse(JSON.stringify(proofOfSignatureData));
      expectedRes.message = {
        signer: signer1.address,
        agreementFileProofCID,
        app: 'daosign',
        timestamp: await time.latest(),
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);

      /**
       * the second execution of `fetchProofOfSignatureData` uses less
       * gas than before because now it returns a cached data
       */
      // first real function execution (more gas)
      const tx1 = await proofs.fetchProofOfSignatureData(
        signer1.address,
        agreementFileCID,
        agreementFileProofCID,
        '0.1.0',
      );
      const proofTime = await time.latest();
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.message.timestamp = await time.latest();
      expect(
        JSON.parse(
          await proofs.proofsData(agreementFileCID, Proofs.ProofOfSignature, signer1.address),
        ),
      ).to.deep.equal(expectedRes);

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfSignatureData(
        signer1.address,
        agreementFileCID,
        agreementFileProofCID,
        '0.1.0',
      );
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        agreementFileCID,
        agreementFileProofCID,
        '0.1.0',
      );

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expectedRes = JSON.parse(JSON.stringify(proofOfSignatureData));
      expectedRes.message = {
        signer: signer1.address,
        agreementFileProofCID,
        app: 'daosign',
        timestamp: proofTime,
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.proofsData(agreementFileCID, Proofs.ProofOfAuthority, signer1.address));
    });
  });

  describe('Fetch Proof-of-Agreement data', () => {
    const agreementFileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const proofOfAuthorityCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const proofOfSignatureCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];

    it('no Agreement File CID error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAgreementData.staticCall('', proofOfAuthorityCID, proofOfSignatureCIDs),
      ).revertedWith('No Agreement File CID');
    });

    it('no Proof-of-Authority error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAgreementData.staticCall(
          agreementFileCID,
          proofOfAuthorityCID,
          proofOfSignatureCIDs,
        ),
      ).revertedWith('No Proof-of-Authority');
    });

    it('no Proof-of-Signature error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);
      await storeProofOfAuthority(agreementFileCID, proofOfAuthorityCID);

      await expect(
        proofs.fetchProofOfAgreementData.staticCall(
          agreementFileCID,
          proofOfAuthorityCID,
          proofOfSignatureCIDs,
        ),
      ).revertedWith('No Proof-of-Signature');
    });

    it('success', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);

      // Store Proof-of-Authority & Proofs-of-Agreement
      await storeProofOfAuthority(agreementFileCID, proofOfAuthorityCID);
      await Promise.all(
        proofOfSignatureCIDs.map((posCID) =>
          storeProofOfSignature(agreementFileCID, proofOfAuthorityCID, posCID, proofs, signer1),
        ),
      );

      let res = await proofs.fetchProofOfAgreementData.staticCall(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfSignatureCIDs,
      );

      const timestamp = await time.latest();
      const expectedRes = {
        agreementFileProofCID: proofOfAuthorityCID,
        agreementSignProofs: proofOfSignatureCIDs.map((cid) => ({
          proofCID: cid,
        })),

        timestamp,
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);

      /**
       * the second execution of `fetchProofOfAgreementData` uses less
       * gas than before because now it returns a cached data
       */
      // first real function execution (more gas)
      const tx1 = await proofs.fetchProofOfAgreementData(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfSignatureCIDs,
      );
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.timestamp = await time.latest();
      expect(
        JSON.parse(
          await proofs.proofsData(agreementFileCID, Proofs.ProofOfAgreement, ethers.ZeroAddress),
        ),
      ).to.deep.equal(expectedRes);

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfAgreementData(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfSignatureCIDs,
      );
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfAgreementData.staticCall(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfSignatureCIDs,
      );

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.proofsData(agreementFileCID, Proofs.ProofOfAgreement, ethers.ZeroAddress));
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

      await proofs.fetchProofOfAuthorityData(creator.address, signers, agreementFileCID, version);
      const data = await proofs.fetchProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        agreementFileCID,
        version,
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

    it('error: No ProofCID', async () => {
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, ''),
      ).revertedWith('No ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID);
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID),
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfAuthority(creator.address, signatureSigner1, agreementFileCID, proofCID),
      ).revertedWith('Invalid signature');
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, '', proofCID),
      ).revertedWith('Invalid signature');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfAuthority(creator.address, signature, agreementFileCID, proofCID),
      )
        .emit(proofs, 'ProofOfAuthority')
        .withArgs(creator.address, signature, agreementFileCID, proofCID, JSON.stringify(proof));

      // calculated & stored correctly
      expect(JSON.parse(await proofs.finalProofs(agreementFileCID, proofCID))).eql(proof);
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

      await storeProofOfAuthority(agreementFileCID, proofOfAuthorityCID);

      await proofs.fetchProofOfSignatureData(
        signer1.address,
        agreementFileCID,
        proofOfAuthorityCID,
        version,
      );
      const data = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        agreementFileCID,
        proofOfAuthorityCID,
        version,
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

    it('error: No ProofCID', async () => {
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, agreementFileCID, ''),
      ).revertedWith('No ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfSignature(
        signer1.address,
        signature,
        agreementFileCID,
        proofOfSignatureCID,
      );
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID,
        ),
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signatureSigner2,
          agreementFileCID,
          proofOfSignatureCID,
        ),
      ).revertedWith('Invalid signature');
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, '', proofOfSignatureCID),
      ).revertedWith('Invalid signature');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID,
        ),
      )
        .emit(proofs, 'ProofOfSignature')
        .withArgs(
          signer1.address,
          signature,
          agreementFileCID,
          proofOfSignatureCID,
          JSON.stringify(proof),
        );

      // calculated & stored correctly
      expect(JSON.parse(await proofs.finalProofs(agreementFileCID, proofOfSignatureCID))).eql(
        proof,
      );
    });
  });

  describe('Store Proof-of-Agreement', () => {
    const agreementFileCID = 'QmfVd78Pns7Gd5ijurJo3vi892DmuPpz6eP5YsuSCsBoyD';
    const proofOfAuthorityCID = 'QmRr3f12HHGSBYk3hpFuuAweKfcStQ16Vej81gr4GLbKU3';
    const proofOfSignatureCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const proofOfAgreementCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    let proof: string;
    let proofs: any;
    let signer1: SignerWithAddress;

    beforeEach(async () => {
      ({ proofs, signer1 } = await loadFixture(deployProofsFixture));

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
      proof = await proofs.fetchProofOfAgreementData.staticCall(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfSignatureCIDs,
      );
    });

    it('error: No ProofCID', async () => {
      await expect(
        proofs.storeProofOfAgreement(agreementFileCID, proofOfAuthorityCID, ''),
      ).revertedWith('No ProofCID');
    });

    it('error: No Agreement File CID', async () => {
      await expect(
        proofs.storeProofOfAgreement('', proofOfAuthorityCID, proofOfAgreementCID),
      ).revertedWith('No Agreement File CID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfAgreement(
        agreementFileCID,
        proofOfAuthorityCID,
        proofOfAgreementCID,
      );
      await expect(
        proofs.storeProofOfAgreement(agreementFileCID, proofOfAuthorityCID, proofOfAgreementCID),
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid input data', async () => {
      const { proofs: proofsLocal } = await loadFixture(deployProofsFixture);

      await expect(
        proofsLocal.storeProofOfAgreement(
          agreementFileCID,
          proofOfAuthorityCID,
          proofOfAgreementCID,
        ),
      ).revertedWith('Invalid input data');
    });

    it('success', async () => {
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
});
