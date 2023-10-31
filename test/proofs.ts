import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { HDNodeWallet, ZeroAddress } from 'ethers';
import { expect } from 'chai';
import { ethers, config } from 'hardhat';
import { MessageTypeProperty, SignTypedDataVersion, signTypedData } from '@metamask/eth-sig-util';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import {
  ProofOfAgreementStruct,
  ProofOfAuthorityStruct,
  ProofOfSignatureStruct,
} from '../typechain-types/Proofs';

const ProofOfAuthority = {
  EIP712Domain: [
    { name: 'name', type: 'string' },
    { name: 'version', type: 'string' },
    { name: 'chainId', type: 'uint256' },
    { name: 'verifyingContract', type: 'address' },
  ],
  Signer: [
    { name: 'addr', type: 'address' },
    { name: 'data', type: 'string' },
  ],
  ProofOfAuthority: [
    { name: 'name', type: 'string' },
    { name: 'from', type: 'address' },
    { name: 'filecid', type: 'string' },
    { name: 'signers', type: 'Signer[]' },
    { name: 'app', type: 'string' },
    { name: 'timestamp', type: 'uint256' },
    { name: 'metadata', type: 'string' },
  ],
};

function signProofOfAuthority(pkey: Buffer, message: ProofOfAuthorityStruct): string {
  return signTypedData({
    privateKey: pkey,
    version: SignTypedDataVersion.V4,
    data: {
      domain: {
        name: 'daosign',
        version: '0.1.0',
        chainId: 0,
        verifyingContract: ZeroAddress,
      },
      primaryType: 'ProofOfAuthority',
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
          { name: 'chainId', type: 'uint256' },
          { name: 'verifyingContract', type: 'address' },
        ],
        Signer: [
          { name: 'addr', type: 'address' },
          { name: 'data', type: 'string' },
        ],
        ProofOfAuthority: [
          { name: 'name', type: 'string' },
          { name: 'from', type: 'address' },
          { name: 'filecid', type: 'string' },
          { name: 'signers', type: 'Signer[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
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
        chainId: 0,
        verifyingContract: ZeroAddress,
      },
      primaryType: 'ProofOfSignature',
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
          { name: 'chainId', type: 'uint256' },
          { name: 'verifyingContract', type: 'address' },
        ],
        ProofOfSignature: [
          { name: 'name', type: 'string' },
          { name: 'signer', type: 'address' },
          { name: 'filecid', type: 'string' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
          { name: 'metadata', type: 'string' },
        ],
      },
      message,
    },
  });
}

function signProofOfAgreement(pkey: Buffer, message: ProofOfAgreementStruct): string {
  return signTypedData({
    privateKey: pkey,
    version: SignTypedDataVersion.V4,
    data: {
      domain: {
        name: 'daosign',
        version: '0.1.0',
        chainId: 0,
        verifyingContract: ZeroAddress,
      },
      primaryType: 'ProofOfAgreement',
      types: {
        EIP712Domain: [
          { name: 'name', type: 'string' },
          { name: 'version', type: 'string' },
          { name: 'chainId', type: 'uint256' },
          { name: 'verifyingContract', type: 'address' },
        ],
        Filecid: [
          { name: 'addr', type: 'string' },
          { name: 'data', type: 'string' },
        ],
        ProofOfAgreement: [
          { name: 'filecid', type: 'string' },
          { name: 'signcids', type: 'Filecid[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
          { name: 'metadata', type: 'string' },
        ],
      },
      message,
    },
  });
}

describe('Proofs', () => {
  async function deployProofsFixture() {
    const Proofs = await ethers.getContractFactory('DummyProofs');

    const [[signer], proofs] = await Promise.all([ethers.getSigners(), Proofs.deploy()]);

    const accounts = config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
    const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
    const pkey = Buffer.from(wallet.privateKey.slice(2), 'hex');

    return { pkey, signer, proofs };
  }

  describe('ProofOfAuthority', () => {
    it('recover', async () => {
      const { pkey, signer, proofs } = await loadFixture(deployProofsFixture);
      const recover =
        proofs['recover((string,address,string,(address,string)[],string,uint256,string),bytes)'];
      const message: ProofOfAuthorityStruct = {
        name: 'Proof-of-Authority',
        from: signer.address,
        filecid: 'some file cid',
        signers: [
          { addr: signer.address, data: 'data 1' },
          { addr: signer.address, data: 'data 2' },
        ],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const signature = signProofOfAuthority(pkey, message);
      const recovered = await recover(message, signature);
      expect(recovered).eq(signer.address);
    });
  });

  describe('ProofOfSignature', () => {
    it('recover', async () => {
      const { pkey, signer, proofs } = await loadFixture(deployProofsFixture);
      const recover = proofs['recover((string,address,string,string,uint256,string),bytes)'];
      const message: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: signer.address,
        filecid: 'some file cid',
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const signature = signProofOfSignature(pkey, message);
      const recovered = await recover(message, signature);
      expect(recovered).eq(signer.address);
    });
  });

  describe('ProofOfAgreement', () => {
    // TODO
  });
});
