import { loadFixture, time } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import * as hre from 'hardhat';
import { SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { SignTypedDataVersion, signTypedData } from '@metamask/eth-sig-util';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import { deployAll, deployProofsMetadata } from '../scripts/deploy';
import { proofOfAuthorityData, proofOfSignatureData } from './data/proofs';
import { Proofs } from './common';
import { proofJSONtoBytes } from './utils';

const { ethers } = hre;

describe('Proofs', () => {
  async function deployProofsFixture() {
    const [owner, creator, signer1, signer2, signer3, anyone] = await ethers.getSigners();
    // Note: `hre` is passed here as the same deployment scripts are used in both tests and in
    //       hardhat tasks for real deployment. However, in hardhat tasks you much pass `hre` as a
    //       parameter, so it was decided to pass `hre` parameter in tests as well to use the same
    //       deployment functions.
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

  const storeProofOfAuthority = async (fileCID: string, poaCID: string) => {
    const version = '0.1.0';

    const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
    const signers = [signer1.address, signer2.address, signer3.address];
    const dataSig = await creator.signMessage(
      ethers.getBytes(
        ethers.keccak256(
          ethers.solidityPacked(
            ['address', 'address[]', 'string', 'string'],
            [creator.address, signers, fileCID, version],
          ),
        ),
      ),
    );

    await proofs.fetchProofOfAuthorityData(creator.address, signers, fileCID, version, dataSig);
    const data = await proofs.fetchProofOfAuthorityData.staticCall(
      creator.address,
      signers,
      fileCID,
      version,
      dataSig,
    );

    const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
    const signature = await creator.signMessage(ethers.getBytes(dataHash));
    await proofs.storeProofOfAuthority(
      creator.address,
      signers,
      version,
      signature,
      fileCID,
      poaCID,
    );
  };

  const storeProofOfSignature = async (
    fileCID: string,
    poaCID: string,
    posCID: string,
    proofs: any,
    signer1: SignerWithAddress,
  ) => {
    const version = '0.1.0';
    const dataSig = await signer1.signMessage(
      ethers.getBytes(
        ethers.keccak256(
          ethers.solidityPacked(
            ['address', 'string', 'string', 'string'],
            [signer1.address, fileCID, poaCID, version],
          ),
        ),
      ),
    );

    await proofs.fetchProofOfSignatureData(signer1.address, fileCID, poaCID, version, dataSig);
    const data = await proofs.fetchProofOfSignatureData.staticCall(
      signer1.address,
      fileCID,
      poaCID,
      version,
      dataSig,
    );

    const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
    const signature = await signer1.signMessage(ethers.getBytes(dataHash));
    await proofs.storeProofOfSignature(
      signer1.address,
      signature,
      fileCID,
      posCID,
      poaCID,
      version,
    );
  };

  describe('constructor', () => {
    it('error on non-IERC165 and non-IProofsMetadata input', async () => {
      const { proofs, strings, proofsVerification, proofsHelper, anyone, owner } =
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
        ).deploy(ethers.ZeroAddress, owner.address),
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
        ).deploy(anyone.address, owner.address),
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
        ).deploy(await proofs.getAddress(), owner.address),
      ).revertedWith('Must support IProofsMetadata');
    });

    it('success', async () => {
      const { strings, proofsVerification, proofsHelper, owner } =
        await loadFixture(deployProofsFixture);
      const { proofsMetadata } = await deployProofsMetadata(hre, await strings.getAddress());

      const proofs = await (
        await ethers.getContractFactory('Proofs', {
          libraries: {
            StringsExpanded: await strings.getAddress(),
            ProofsVerification: await proofsVerification.getAddress(),
            ProofsHelper: await proofsHelper.getAddress(),
          },
        })
      ).deploy(await proofsMetadata.getAddress(), owner.address);

      expect(await proofs.proofsMetadata()).equal(await proofsMetadata.getAddress());
    });
  });

  describe('Fetch Proof-of-Authority data', () => {
    it('caller is not the owner', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const fileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const version = '0.1.0';
      const dataSig = await creator.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'address[]', 'string', 'string'],
              [creator.address, signers, fileCID, version],
            ),
          ),
        ),
      );

      await expect(
        proofs
          .connect(creator)
          .fetchProofOfAuthorityData(creator.address, signers, fileCID, version, dataSig),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('invalid data signature', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const fileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const version = '0.1.0';
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'address[]', 'string', 'string'],
              [signer1.address, signers, fileCID, version],
            ),
          ),
        ),
      );

      await expect(
        proofs.fetchProofOfAuthorityData(creator.address, signers, fileCID, version, dataSig),
      ).revertedWith('Invalid data signature');

      await expect(
        proofs.fetchProofOfAuthorityData(signer1.address, signers, fileCID, version, dataSig),
      ).not.reverted;
    });

    it('success', async () => {
      const { proofs, creator, signer1, signer2, signer3 } = await loadFixture(deployProofsFixture);
      const signers = [signer1.address, signer2.address, signer3.address];
      const fileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
      const version = '0.1.0';
      const dataSig = await creator.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'address[]', 'string', 'string'],
              [creator.address, signers, fileCID, version],
            ),
          ),
        ),
      );

      let res = await proofs.fetchProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        fileCID,
        version,
        dataSig,
      );

      let expectedRes: any = JSON.parse(JSON.stringify(proofOfAuthorityData));
      expectedRes.message = {
        from: creator.address.toLowerCase(),
        agreementFileCID: fileCID,
        signers: signers.map((signer) => ({ address: signer.toLowerCase(), metadata: {} })),
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
        fileCID,
        version,
        dataSig,
      );
      const proofTime = await time.latest();
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.message.timestamp = await time.latest();
      expect(
        JSON.parse(await proofs.getPoAData(creator.address, signers, fileCID, version)),
      ).to.deep.equal(expectedRes);

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfAuthorityData(
        creator.address,
        signers,
        fileCID,
        version,
        dataSig,
      );
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfAuthorityData.staticCall(
        creator.address,
        signers,
        fileCID,
        version,
        dataSig,
      );

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expectedRes = proofOfAuthorityData;
      expectedRes.message = {
        from: creator.address,
        agreementFileCID: fileCID,
        signers: signers.map((signer) => ({ address: signer, metadata: {} })),
        app: 'daosign',
        timestamp: proofTime,
        metadata: {},
      };
      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.getPoAData(creator.address, signers, fileCID, version));
    });
  });

  describe('Fetch Proof-of-Signature data', () => {
    const fileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const poaCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    let proofs: any;
    let signer1: SignerWithAddress;
    let signer2: SignerWithAddress;
    const version = '0.1.0';

    beforeEach(async () => {
      ({ proofs, signer1, signer2 } = await loadFixture(deployProofsFixture));
      await storeProofOfAuthority(fileCID, poaCID);
    });

    it('caller is not the owner', async () => {
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, fileCID, poaCID, version],
            ),
          ),
        ),
      );
      await expect(
        proofs
          .connect(signer1)
          .fetchProofOfSignatureData.staticCall(signer1.address, '', poaCID, version, dataSig),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('no Agreement File CID error', async () => {
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, '', poaCID, version],
            ),
          ),
        ),
      );
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(signer1.address, '', poaCID, version, dataSig),
      ).revertedWith('No Agreement File CID');
    });

    it('no Proof-of-Authority CID error', async () => {
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, fileCID, '', version],
            ),
          ),
        ),
      );
      await expect(
        proofs.fetchProofOfSignatureData.staticCall(signer1.address, fileCID, '', version, dataSig),
      ).revertedWith('No Proof-of-Authority');
    });

    it('invalid data signature', async () => {
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, fileCID, poaCID, version],
            ),
          ),
        ),
      );

      await expect(
        proofs.fetchProofOfSignatureData(signer2.address, fileCID, poaCID, version, dataSig),
      ).revertedWith('Invalid data signature');

      await expect(
        proofs.fetchProofOfSignatureData(signer1.address, fileCID, poaCID, version, dataSig),
      ).not.reverted;
    });

    it('success', async () => {
      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, fileCID, poaCID, version],
            ),
          ),
        ),
      );

      let res = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        fileCID,
        poaCID,
        version,
        dataSig,
      );

      let expectedRes: any = JSON.parse(JSON.stringify(proofOfSignatureData));
      expectedRes.message = {
        signer: signer1.address,
        agreementFileProofCID: poaCID,
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
        fileCID,
        poaCID,
        version,
        dataSig,
      );
      const proofTime = await time.latest();
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.message.timestamp = await time.latest();
      expect(
        JSON.parse(await proofs.getPoSData(signer1.address, fileCID, poaCID, version)),
      ).to.deep.equal(expectedRes);

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfSignatureData(
        signer1.address,
        fileCID,
        poaCID,
        version,
        dataSig,
      );
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        fileCID,
        poaCID,
        version,
        dataSig,
      );

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expectedRes = JSON.parse(JSON.stringify(proofOfSignatureData));
      expectedRes.message = {
        signer: signer1.address.toLowerCase(),
        agreementFileProofCID: poaCID,
        app: 'daosign',
        timestamp: proofTime,
        metadata: {},
      };

      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.getPoSData(signer1.address, fileCID, poaCID, version));
    });
  });

  describe('Fetch Proof-of-Agreement data', () => {
    const fileCID = 'QmP4EKzg4ba8U3vmuJjJSRifvPqTasYvdfea4ZgYK3dXXp';
    const poaCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const posCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];

    it('caller is not the owner', async () => {
      const { proofs, creator } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.connect(creator).fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('no Agreement File CID error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);

      await expect(proofs.fetchProofOfAgreementData.staticCall('', poaCID, posCIDs)).revertedWith(
        'No Agreement File CID',
      );
    });

    it('no Proof-of-Authority error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);

      await expect(
        proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs),
      ).revertedWith('No Proof-of-Authority');
    });

    it('no Proof-of-Signature error', async () => {
      const { proofs } = await loadFixture(deployProofsFixture);
      await storeProofOfAuthority(fileCID, poaCID);

      await expect(
        proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs),
      ).revertedWith('No Proof-of-Signature');
    });

    it('success', async () => {
      const { proofs, signer1 } = await loadFixture(deployProofsFixture);

      // Store Proof-of-Authority & Proofs-of-Agreement
      await storeProofOfAuthority(fileCID, poaCID);
      await Promise.all(
        posCIDs.map((posCID) => storeProofOfSignature(fileCID, poaCID, posCID, proofs, signer1)),
      );

      let res = await proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs);

      const timestamp = await time.latest();
      const expectedRes = {
        agreementFileProofCID: poaCID,
        agreementSignProofs: posCIDs.map((cid) => ({
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
      const tx1 = await proofs.fetchProofOfAgreementData(fileCID, poaCID, posCIDs);
      const gasUsedTx1 = (await tx1.wait())?.gasUsed ?? 0n;

      expectedRes.timestamp = await time.latest();
      expect(JSON.parse(await proofs.getPoAgData(fileCID, poaCID, posCIDs))).to.deep.equal(
        expectedRes,
      );

      // second real function execution (less gas)
      const tx2 = await proofs.fetchProofOfAgreementData(fileCID, poaCID, posCIDs);
      const gasUsedTx2 = (await tx2.wait())?.gasUsed ?? 0n;

      res = await proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs);

      expect(gasUsedTx1).greaterThan(gasUsedTx2 * 5n);

      // check that the result of the third function execution is still the same
      expect(JSON.parse(res)).to.deep.equal(expectedRes);
      expect(proofs.getPoAgData(fileCID, poaCID, posCIDs));
    });
  });

  describe.only('Store Proof-of-Authority', () => {
    const fileCID = 'QmRf22bZar3WKmojipms22PkXH1MZGmvsqzQtuSvQE3uhm';
    const proofCID = 'QmYAkbM4UCPDLBewYcjP57ZAZD2rY9oYQ1BJR1t8qt7XpF';
    const version = '0.1.0';
    let proof: unknown;
    let proofs: any;
    let creator: SignerWithAddress;
    let owner: SignerWithAddress;
    let signer1: SignerWithAddress;
    let signer2: SignerWithAddress;
    let signer3: SignerWithAddress;
    let signers: string[];
    let signature: string;
    let signatureSigner1: string;

    const poaData = {
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
        ],
        Signer: [
          { name: 'addr', type: 'address' },
          { name: 'metadata', type: 'string' },
        ],
        ProofOfAuthorityMsg: [
          { name: 'name', type: 'string' },
          { name: 'from', type: 'address' },
          { name: 'agreementFileCID', type: 'string' },
          { name: 'signers', type: 'Signer[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint64' },
          { name: 'metadata', type: 'string' },
        ],
      },
      primaryType: 'ProofOfAuthorityMsg',
      domain: {
        name: 'daosign',
        version: '0.1.0',
      },
      message: {
        name: 'Proof-of-Authority',
        from: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266',
        agreementFileCID: '<Agreement File CID>',
        signers: [{ addr: '0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', metadata: '{}' }],
        app: 'daosign',
        timestamp: 12345,
        metadata: '{}',
      },
    };

    beforeEach(async () => {
      ({ proofs, creator, signer1, signer2, signer3, owner } =
        await loadFixture(deployProofsFixture));
      signers = [signer1.address, signer2.address, signer3.address];

      creator = owner;

      // const dataSig = await creator.signMessage(
      //   ethers.getBytes(
      //     ethers.keccak256(
      //       ethers.solidityPacked(
      //         ['address', 'address[]', 'string', 'string'],
      //         [creator.address, signers, fileCID, version],
      //       ),
      //     ),
      //   ),
      // );

      // await proofs.fetchProofOfAuthorityData(creator.address, signers, fileCID, version, dataSig);
      // const data = await proofs.fetchProofOfAuthorityData.staticCall(
      //   creator.address,
      //   signers,
      //   fileCID,
      //   version,
      //   dataSig,
      // );

      // console.log(util.inspect(JSON.parse(data), false, null, true));

      const accounts = hre.config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
      const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
      const privateKey = Buffer.from(wallet.privateKey.slice(2), 'hex');
      console.log({
        owner: owner.address,
        creator: creator.address,
        wallet: wallet.address,
        privateKey,
      });

      const res = signTypedData({
        privateKey,
        version: SignTypedDataVersion.V4,
        data: poaData, // JSON.parse(data), // poaData,
      });
      console.log({ res });

      // const dataHash = ethers.keccak256(ethers.toUtf8Bytes(data));
      signature = res;
      // signature = await creator.signMessage(ethers.getBytes(dataHash));
      // console.log(signature);
      // signatureSigner1 = await signer1.signMessage(ethers.getBytes(dataHash));
      proof = {
        // address: creator.address.toLocaleLowerCase(),
        // sig: signature,
        // data: JSON.parse(data),
      };
    });

    it('caller is not the owner', async () => {
      await expect(
        proofs
          .connect(creator)
          .storeProofOfAuthority(creator.address, signers, version, signature, fileCID, proofCID),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('error: No ProofCID', async () => {
      await expect(
        proofs.storeProofOfAuthority(creator.address, signers, version, signature, fileCID, ''),
      ).revertedWith('No ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfAuthority(
        creator.address,
        signers,
        version,
        signature,
        fileCID,
        proofCID,
      );
      await expect(
        proofs.storeProofOfAuthority(
          creator.address,
          signers,
          version,
          signature,
          fileCID,
          proofCID,
        ),
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfAuthority(
          creator.address,
          signers,
          version,
          signatureSigner1,
          fileCID,
          proofCID,
        ),
      ).revertedWith('Invalid signature');
      await expect(
        proofs.storeProofOfAuthority(creator.address, signers, version, signature, '', proofCID),
      ).revertedWith('Invalid signature');
    });

    it.only('success', async () => {
      // calculated & emited correctly

      console.log({
        message: poaData.message,
        signature,
      });
      const res = await proofs.recoverPoA(poaData.message, signature);
      expect(res).equal(creator.address);

      // await expect(
      //   proofs.storeProofOfAuthority(
      //     creator.address,
      //     signers,
      //     version,
      //     signature,
      //     fileCID,
      //     proofCID,
      //   ),
      // )
      //   .emit(proofs, 'ProofOfAuthority')
      //   .withArgs(creator.address, signature, fileCID, proofCID, JSON.stringify(proof));

      // // calculated & stored correctly
      // expect(JSON.parse(await proofs.finalProofs(fileCID, proofCID))).eql(proof);
    });
  });

  describe('Store Proof-of-Signature', () => {
    const fileCID = 'QmRf22bZar3WKmojipms22PkXH1MZGmvsqzQtuSvQE3uhm';
    const poaCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    const posCID = 'QmYAkbM4UCPDLBewYcjP57ZAZD2rY9oYQ1BJR1t8qt7XpF';
    const version = '0.1.0';
    let proof: unknown;
    let proofs: any;
    let signer1: SignerWithAddress;
    let signer2: SignerWithAddress;
    let signature: string;
    let signatureSigner2: string;

    beforeEach(async () => {
      ({ proofs, signer1, signer2 } = await loadFixture(deployProofsFixture));

      const dataSig = await signer1.signMessage(
        ethers.getBytes(
          ethers.keccak256(
            ethers.solidityPacked(
              ['address', 'string', 'string', 'string'],
              [signer1.address, fileCID, poaCID, version],
            ),
          ),
        ),
      );

      await storeProofOfAuthority(fileCID, poaCID);

      await proofs.fetchProofOfSignatureData(signer1.address, fileCID, poaCID, version, dataSig);
      const data = await proofs.fetchProofOfSignatureData.staticCall(
        signer1.address,
        fileCID,
        poaCID,
        version,
        dataSig,
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

    it('caller is not the owner', async () => {
      await expect(
        proofs
          .connect(signer1)
          .storeProofOfSignature(signer1.address, signature, fileCID, posCID, poaCID, version),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('error: No ProofCID', async () => {
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, fileCID, '', poaCID, version),
      ).revertedWith('No ProofCID');
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfSignature(
        signer1.address,
        signature,
        fileCID,
        posCID,
        poaCID,
        version,
      );
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, fileCID, posCID, poaCID, version),
      ).revertedWith('Proof already stored');
    });

    it('error: Invalid signature', async () => {
      await expect(
        proofs.storeProofOfSignature(
          signer1.address,
          signatureSigner2,
          fileCID,
          posCID,
          poaCID,
          version,
        ),
      ).revertedWith('Invalid signature');
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, '', posCID, poaCID, version),
      ).revertedWith('Invalid signature');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfSignature(signer1.address, signature, fileCID, posCID, poaCID, version),
      )
        .emit(proofs, 'ProofOfSignature')
        .withArgs(signer1.address, signature, fileCID, posCID, JSON.stringify(proof));

      // calculated & stored correctly
      expect(JSON.parse(await proofs.finalProofs(fileCID, posCID))).eql(proof);
    });
  });

  describe('Store Proof-of-Agreement', () => {
    const fileCID = 'QmfVd78Pns7Gd5ijurJo3vi892DmuPpz6eP5YsuSCsBoyD';
    const poaCID = 'QmRr3f12HHGSBYk3hpFuuAweKfcStQ16Vej81gr4GLbKU3';
    const posCIDs = [
      'QmUDLEHaLsr5wq7mnZTPMWQmre6Pa1Dd2hQx2kdcwXY7nU',
      'QmfSEEuZBsSgh3hLB8BU4ApNepDpaUWFCw9KqB7DxLbSV2',
      'QmVMLPjLnT7PVQvZstd6DmL8K1VGHHypbYyG2HHSzN8BTK',
    ];
    const poagCID = 'QmQY5XFRomrnAD3o3yMWkTz1HWcCfZYuE87Gbwe7SjV1kk';
    let proof: string;
    let proofs: any;
    let signer1: SignerWithAddress;

    beforeEach(async () => {
      ({ proofs, signer1 } = await loadFixture(deployProofsFixture));

      await storeProofOfAuthority(fileCID, poaCID);
      await Promise.all(
        posCIDs.map((posCID) => storeProofOfSignature(fileCID, poaCID, posCID, proofs, signer1)),
      );

      await proofs.fetchProofOfAgreementData(fileCID, poaCID, posCIDs);
      proof = await proofs.fetchProofOfAgreementData.staticCall(fileCID, poaCID, posCIDs);
    });

    it('caller is not the owner', async () => {
      await expect(
        proofs.connect(signer1).storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID),
      ).revertedWith('Ownable: caller is not the owner');
    });

    it('error: No ProofCID', async () => {
      await expect(proofs.storeProofOfAgreement(fileCID, poaCID, posCIDs, '')).revertedWith(
        'No ProofCID',
      );
    });

    it('error: No Agreement File CID', async () => {
      await expect(proofs.storeProofOfAgreement('', poaCID, posCIDs, poagCID)).revertedWith(
        'No Agreement File CID',
      );
    });

    it('error: Proof already stored', async () => {
      await proofs.storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID);
      await expect(proofs.storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID)).revertedWith(
        'Proof already stored',
      );
    });

    it('error: Invalid input data', async () => {
      const { proofs: proofsLocal } = await loadFixture(deployProofsFixture);

      await expect(
        proofsLocal.storeProofOfAgreement(fileCID, poaCID, posCIDs, poagCID),
      ).revertedWith('Invalid input data');
    });

    it('success', async () => {
      // calculated & emited correctly
      await expect(
        proofs.storeProofOfAgreement(
          fileCID,
          poaCID,
          posCIDs,
          poagCID,
          // proof
        ),
      )
        .emit(proofs, 'ProofOfAgreement')
        .withArgs(fileCID, poaCID, poagCID, proof);

      // calculated & stored correctly
      expect(await proofs.finalProofs(fileCID, poagCID)).eql(proof);
    });
  });
});
