import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, config } from 'hardhat';
import { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';
import { Contract, Result } from 'ethers';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import DAOSignEIP712ABI from './DAOSignEIP712ModifiedABI.json';
import {
  EIP712DomainStruct,
  ProofOfAuthorityStruct,
  ProofOfSignatureStruct,
  ProofOfAgreementStruct,
  MockDAOSignEIP712,
} from '../typechain-types/mocks/MockDAOSignEIP712';
import { cmp, signMessage } from './utils';

describe('DAOSignEIP712', function () {
  const ZEROADDR = '0x0000000000000000000000000000000000000000';

  const domain: EIP712DomainStruct = {
    name: 'daosign',
    version: '0.1.0',
    chainId: 0,
    verifyingContract: ZEROADDR,
  };

  let mocks: {
    privateKey: Buffer;
    signer: HardhatEthersSigner;
    proofs: MockDAOSignEIP712;
    mproofs: Contract;
  };

  async function deployProofsFixture() {
    const [[signer], DAOSignEIP712] = await Promise.all([
      ethers.getSigners(),
      ethers.getContractFactory('MockDAOSignEIP712'),
    ]);
    const daoSignEIP712 = await DAOSignEIP712.deploy(domain);

    const accounts = config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
    const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
    const privateKey = Buffer.from(wallet.privateKey.slice(2), 'hex');

    return {
      privateKey: privateKey,
      signer: signer,
      proofs: daoSignEIP712,
      mproofs: new ethers.Contract(await daoSignEIP712.getAddress(), DAOSignEIP712ABI, signer),
    };
  }

  before(async function () {
    mocks = await loadFixture(deployProofsFixture);
  });

  describe('EIP712 Messages', function () {
    it('EIP712ProofOfAuthority', async function () {
      const msg: ProofOfAuthorityStruct = {
        name: 'name',
        from: ZEROADDR,
        agreementCID: 'agreementCID',
        signers: [{ addr: ZEROADDR, metadata: 'metadata' }],
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = (await mocks.mproofs.getProofOfAuthorityMessage(msg)) as Result;

      expect(eip712msg.domain.name).eq(domain.name);
      expect(eip712msg.domain.version).eq(domain.version);
      cmp(eip712msg.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(eip712msg.types.Signer, [
        { name: 'addr', type: 'address' },
        { name: 'metadata', type: 'string' },
      ]);
      cmp(eip712msg.types.ProofOfAuthority, [
        { name: 'name', type: 'string' },
        { name: 'from', type: 'address' },
        { name: 'agreementCID', type: 'string' },
        { name: 'signers', type: 'Signer[]' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(eip712msg.primaryType).eq('ProofOfAuthority');
      expect(eip712msg.message.name).eq(msg.name);
      expect(eip712msg.message.from).eq(msg.from);
      expect(eip712msg.message.agreementCID).eq(msg.agreementCID);
      expect(eip712msg.message.signers.length).eq(msg.signers.length);
      expect(eip712msg.message.signers[0].addr).eq(msg.signers[0].addr);
      expect(eip712msg.message.signers[0].metadata).eq(msg.signers[0].metadata);
      expect(eip712msg.message.app).eq(msg.app);
      expect(eip712msg.message.timestamp).eq(msg.timestamp);
      expect(eip712msg.message.metadata).eq(msg.metadata);
    });

    it('EIP712ProofOfSignature', async function () {
      const msg: ProofOfSignatureStruct = {
        name: 'name',
        signer: ZEROADDR,
        agreementCID: 'agreementCID',
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = (await mocks.mproofs.getProofOfSignatureMessage(msg)) as Result;

      expect(eip712msg.domain.name).eq(domain.name);
      expect(eip712msg.domain.version).eq(domain.version);
      cmp(eip712msg.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(eip712msg.types.ProofOfSignature, [
        { name: 'name', type: 'string' },
        { name: 'signer', type: 'address' },
        { name: 'agreementCID', type: 'string' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(eip712msg.primaryType).eq('ProofOfSignature');
      expect(eip712msg.message.name).eq(msg.name);
      expect(eip712msg.message.signer).eq(msg.signer);
      expect(eip712msg.message.agreementCID).eq(msg.agreementCID);
      expect(eip712msg.message.app).eq(msg.app);
      expect(eip712msg.message.timestamp).eq(msg.timestamp);
      expect(eip712msg.message.metadata).eq(msg.metadata);
    });

    it('EIP712ProofOfAgreement', async function () {
      const msg: ProofOfAgreementStruct = {
        agreementCID: 'agreementCID',
        signatureCIDs: ['signatureCID0', 'signatureCID1'],
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = (await mocks.mproofs.getProofOfAgreementMessage(msg)) as Result;

      expect(eip712msg.domain.name).eq(domain.name);
      expect(eip712msg.domain.version).eq(domain.version);
      cmp(eip712msg.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(eip712msg.types.ProofOfAgreement, [
        { name: 'agreementCID', type: 'string' },
        { name: 'signatureCIDs', type: 'string[]' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(eip712msg.primaryType).eq('ProofOfAgreement');
      expect(eip712msg.message.agreementCID).eq(msg.agreementCID);
      expect(eip712msg.message.signatureCIDs.length).eq(msg.signatureCIDs.length);
      expect(eip712msg.message.signatureCIDs[0]).eq(msg.signatureCIDs[0]);
      expect(eip712msg.message.signatureCIDs[1]).eq(msg.signatureCIDs[1]);
      expect(eip712msg.message.app).eq(msg.app);
      expect(eip712msg.message.timestamp).eq(msg.timestamp);
      expect(eip712msg.message.metadata).eq(msg.metadata);
    });
  });

  describe('EIP712 Recover', function () {
    it('ProofOfAuthority', async function () {
      const { privateKey, signer, proofs } = mocks;
      const message: ProofOfAuthorityStruct = {
        name: 'Proof-of-Authority',
        from: signer.address,
        agreementCID: 'agreementCID',
        signers: [{ addr: signer.address, metadata: 'metadata' }],
        app: 'daosign',
        timestamp: (Date.now() / 1000) | 0,
        metadata: 'metadata',
      };
      const signature = signMessage(privateKey, 'ProofOfAuthority', message);
      const recovered = await proofs.recoverProofOfAuthority(message, signature);
      expect(recovered).eq(signer.address);
    });

    it('ProofOfSignature', async function () {
      const { privateKey, signer, proofs } = mocks;
      const message: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: signer.address,
        agreementCID: 'agreementCID',
        app: 'daosign',
        timestamp: (Date.now() / 1000) | 0,
        metadata: 'metadata',
      };
      const signature = signMessage(privateKey, 'ProofOfSignature', message);
      const recovered = await proofs.recoverProofOfSignature(message, signature);
      expect(recovered).eq(signer.address);
    });

    it('ProofOfAgreement', async function () {
      const { privateKey, signer, proofs } = mocks;
      const message: ProofOfAgreementStruct = {
        agreementCID: 'agreementCID',
        signatureCIDs: ['signatureCID0', 'signatureCID1'],
        app: 'daosign',
        timestamp: (Date.now() / 1000) | 0,
        metadata: 'metadata',
      };
      const signature = signMessage(privateKey, 'ProofOfAgreement', message);
      const recovered = await proofs.recoverProofOfAgreement(message, signature);
      expect(recovered).eq(signer.address);
    });
  });
});
