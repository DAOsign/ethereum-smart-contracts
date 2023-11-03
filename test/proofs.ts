import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, config } from 'hardhat';
import { SignTypedDataVersion, signTypedData } from '@metamask/eth-sig-util';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import { ProofOfAuthorityStruct, ProofOfSignatureStruct } from '../typechain-types/Proofs';

function signProofOfAuthority(pkey: Buffer, message: ProofOfAuthorityStruct): string {
  return signTypedData({
    privateKey: pkey,
    version: SignTypedDataVersion.V4,
    data: {
      domain: {
        name: 'daosign',
        version: '0.1.0',
      },
      primaryType: 'ProofOfAuthority',
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
        ],
        Signer: [
          { name: 'addr', type: 'address' },
          { name: 'metadata', type: 'string' },
        ],
        ProofOfAuthority: [
          { name: 'name', type: 'string' },
          { name: 'from', type: 'address' },
          { name: 'agreementFileCID', type: 'string' },
          { name: 'signers', type: 'Signer[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint64' },
          { name: 'metadata', type: 'string' },
        ],
      },
      message,
    },
  });
}

function signProofOfSignature(pkey: Buffer, message: ProofOfSignatureStruct): string {
  return signTypedData({
    privateKey: pkey,
    version: SignTypedDataVersion.V4,
    data: {
      domain: {
        name: 'daosign',
        version: '0.1.0',
      },
      primaryType: 'ProofOfSignature',
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
        ],
        ProofOfSignature: [
          { name: 'name', type: 'string' },
          { name: 'signer', type: 'address' },
          { name: 'agreementFileProofCID', type: 'string' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint64' },
          { name: 'metadata', type: 'string' },
        ],
      },
      message,
    },
  });
}

describe('Proofs', () => {
  async function deployProofsFixture() {
    const StringUtils = await (await ethers.getContractFactory('StringUtils')).deploy();
    const Proofs = await ethers.getContractFactory('DAOsignProofs', {
      libraries: { StringUtils: await StringUtils.getAddress() },
    });

    const [[signer], proofs] = await Promise.all([ethers.getSigners(), Proofs.deploy()]);

    const accounts = config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
    const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
    const privateKey = Buffer.from(wallet.privateKey.slice(2), 'hex');

    return { privateKey, signer, proofs };
  }

  describe('ProofOfAuthority', () => {
    it.only('recover', async () => {
      const { privateKey, signer, proofs } = await loadFixture(deployProofsFixture);
      const recover =
        proofs['recover((string,address,string,(address,string)[],string,uint64,string),bytes)'];
      const message: ProofOfAuthorityStruct = {
        name: 'Proof-of-Authority',
        from: signer.address,
        agreementFileCID: 'some file cid',
        signers: [
          { addr: signer.address, metadata: 'data 1' },
          { addr: signer.address, metadata: 'data 2' },
        ],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const signature = signProofOfAuthority(privateKey, message);
      const recovered = await recover(message, signature);
      console.log({ recovered, signer: signer.address });
      expect(recovered).eq(signer.address);
    });

    it.only('store', async () => {
      const { privateKey, signer, proofs } = await loadFixture(deployProofsFixture);
      const message = {
        name: 'Proof-of-Authority',
        from: signer.address,
        agreementFileCID: 'Qmeura2H46RCpDRHDHgnQ5QVk7iKnZANDhfLmSKCkDr5vv',
        signers: [
          { addr: signer.address, metadata: '{}' },
          { addr: signer.address, metadata: '{}' },
        ],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: '{}',
      };
      const sig = signProofOfAuthority(privateKey, message);

      const poaShrinked = {
        sig,
        version: '0.1.0',
        message,
      };
      await proofs.storeProofOfAuthority(poaShrinked);
    });
  });

  describe('ProofOfSignature', () => {
    it('recover', async () => {
      const { privateKey, signer, proofs } = await loadFixture(deployProofsFixture);
      const recover = proofs['recover((string,address,string,string,uint64,string),bytes)'];
      const message: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: signer.address,
        agreementFileProofCID: 'some file cid',
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const signature = signProofOfSignature(privateKey, message);
      const recovered = await recover(message, signature);
      expect(recovered).eq(signer.address);
    });
  });

  describe('ProofOfAgreement', () => {
    // TODO
  });
});
