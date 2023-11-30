import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, config } from 'hardhat';
import { HardhatEthersSigner } from '@nomicfoundation/hardhat-ethers/signers';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import {
  EIP712DomainStruct,
  ProofOfAuthorityStruct,
  ProofOfSignatureStruct,
  ProofOfAgreementStruct,
  MockDAOSignEIP712,
} from '../typechain-types/mocks/MockDAOSignEIP712';
import { cmp, signMessage } from './utils';

describe('DAOSignEIP712', () => {
  const domain: EIP712DomainStruct = {
    name: 'daosign',
    version: '0.1.0',
    chainId: 0,
    verifyingContract: ethers.ZeroAddress,
  };

  let mocks: {
    privateKey: Buffer;
    signer: HardhatEthersSigner;
    app: MockDAOSignEIP712;
  };

  async function deployProofsFixture() {
    const [[signer], DAOSignEIP712] = await Promise.all([
      ethers.getSigners(),
      ethers.getContractFactory('MockDAOSignEIP712'),
    ]);

    const accounts = config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
    const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
    const privateKey = Buffer.from(wallet.privateKey.slice(2), 'hex');

    return {
      privateKey,
      signer,
      app: await DAOSignEIP712.deploy(domain),
    };
  }

  before(async () => {
    mocks = await loadFixture(deployProofsFixture);
  });

  it.only('test initialization', async () => {
    console.log({ EIP712DOMAIN_TYPEHASH: await mocks.app.EIP712DOMAIN_TYPEHASH() });
    console.log({ SIGNER_TYPEHASH: await mocks.app.SIGNER_TYPEHASH() });
    console.log({ PROOF_OF_AUTHORITY_TYPEHASH: await mocks.app.PROOF_OF_AUTHORITY_TYPEHASH() });
    console.log({ PROOF_OF_SIGNATURE_TYPEHASH: await mocks.app.PROOF_OF_SIGNATURE_TYPEHASH() });
    console.log({ PROOF_OF_AGREEMENT_TYPEHASH: await mocks.app.PROOF_OF_AGREEMENT_TYPEHASH() });
  });

  describe('EIP712 Messages', () => {
    it('EIP712ProofOfAuthority', async () => {
      const msg: ProofOfAuthorityStruct = {
        name: 'name',
        from: ethers.ZeroAddress,
        agreementCID: 'agreementCID',
        signers: [{ addr: ethers.ZeroAddress, metadata: 'metadata' }],
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = await mocks.app.getProofOfAuthorityMessage(msg);

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

    it('EIP712ProofOfSignature', async () => {
      const msg: ProofOfSignatureStruct = {
        name: 'name',
        signer: ethers.ZeroAddress,
        agreementCID: 'agreementCID',
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = await mocks.app.getProofOfSignatureMessage(msg);

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

    it('EIP712ProofOfAgreement', async () => {
      const msg: ProofOfAgreementStruct = {
        agreementCID: 'agreementCID',
        signatureCIDs: ['signatureCID0', 'signatureCID1'],
        app: 'daosign',
        timestamp: 123,
        metadata: 'metadata',
      };

      const eip712msg = await mocks.app.getProofOfAgreementMessage(msg);

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

  describe('EIP712 Recover', () => {
    it('ProofOfAuthority', async () => {
      const { privateKey, signer, app } = mocks;
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
      const recovered = await app.recoverProofOfAuthority(message, signature);
      expect(recovered).eq(signer.address);
    });

    it('ProofOfSignature', async () => {
      const { privateKey, signer, app } = mocks;
      const message: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: signer.address,
        agreementCID: 'agreementCID',
        app: 'daosign',
        timestamp: (Date.now() / 1000) | 0,
        metadata: 'metadata',
      };
      const signature = signMessage(privateKey, 'ProofOfSignature', message);
      const recovered = await app.recoverProofOfSignature(message, signature);
      expect(recovered).eq(signer.address);
    });

    it('ProofOfAgreement', async () => {
      const { privateKey, signer, app } = mocks;
      const message: ProofOfAgreementStruct = {
        agreementCID: 'agreementCID',
        signatureCIDs: ['signatureCID0', 'signatureCID1'],
        app: 'daosign',
        timestamp: (Date.now() / 1000) | 0,
        metadata: 'metadata',
      };
      const signature = signMessage(privateKey, 'ProofOfAgreement', message);
      const recovered = await app.recoverProofOfAgreement(message, signature);
      expect(recovered).eq(signer.address);
    });
  });
});
