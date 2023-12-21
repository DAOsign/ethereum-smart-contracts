import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers, config } from 'hardhat';
import { HardhatEthersSigner, SignerWithAddress } from '@nomicfoundation/hardhat-ethers/signers';
import { HardhatNetworkHDAccountsConfig } from 'hardhat/types';
import util from 'util';
import {
  ProofOfAuthorityStruct,
  ProofOfSignatureStruct,
  ProofOfAgreementStruct,
  SignedProofOfAuthority,
} from '../typechain-types/DAOSignApp.sol/DAOSignApp';
import { cmp, paddRigthStr, signMessage } from './utils';
import { MockDAOSignApp } from '../typechain-types';

describe('Polkadot DAOSignApp', () => {
  let mocks: {
    privateKey: Buffer;
    signer: HardhatEthersSigner;
    app: MockDAOSignApp;
  };

  async function deployProofsFixture() {
    const [[signer, signer2, someone], MockDAOSignAppFactory] = await Promise.all([
      ethers.getSigners(),
      ethers.getContractFactory('MockDAOSignApp'),
    ]);
    const accounts = config.networks.hardhat.accounts as HardhatNetworkHDAccountsConfig;
    const wallet = ethers.Wallet.fromPhrase(accounts.mnemonic);
    const privateKey = Buffer.from(wallet.privateKey.slice(2), 'hex');

    return {
      privateKey,
      signer,
      signer2,
      someone,
      app: await MockDAOSignAppFactory.deploy(),
    };
  }

  describe.only('Store Proofs', () => {
    // TODO: before -> beforeEach & fix errors
    before(async () => {
      mocks = await loadFixture(deployProofsFixture);
    });

    it('ProofOfAuthority', async () => {
      const msg: ProofOfAuthorityStruct = {
        name: 'Proof-of-Authority',
        from: mocks.signer.address,
        agreementCID: paddRigthStr('agreement file cid'),
        signers: [{ addr: mocks.signer.address, metadata: 'some metadata' }],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const sig = signMessage(mocks.privateKey, 'ProofOfAuthority', msg);
      console.log(
        util.inspect(
          {
            message: msg,
            signature: sig,
            proofCID: paddRigthStr('ProofOfAuthority proof cid'),
          },
          true,
          null,
          true,
        ),
      );

      const tx = mocks.app.storeProofOfAuthority({
        message: msg,
        signature: sig,
        proofCID: paddRigthStr('ProofOfAuthority proof cid'),
      });
      await expect(tx).emit(mocks.app, 'NewProofOfAuthority');

      const msgdoc = await mocks.app.getProofOfAuthority(
        paddRigthStr('ProofOfAuthority proof cid'),
      );
      expect(msgdoc.signature).eq(sig);
      expect(msgdoc.message.domain.name).eq('daosign');
      expect(msgdoc.message.domain.version).eq('0.1.0');
      cmp(msgdoc.message.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(msgdoc.message.types.Signer, [
        { name: 'addr', type: 'address' },
        { name: 'metadata', type: 'string' },
      ]);
      cmp(msgdoc.message.types.ProofOfAuthority, [
        { name: 'name', type: 'string' },
        { name: 'from', type: 'address' },
        { name: 'agreementCID', type: 'string' },
        { name: 'signers', type: 'Signer[]' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(msgdoc.message.primaryType).eq('ProofOfAuthority');
      expect(msgdoc.message.message.name).eq(msg.name);
      expect(msgdoc.message.message.from).eq(msg.from);
      expect(msgdoc.message.message.agreementCID).eq(msg.agreementCID);
      expect(msgdoc.message.message.signers.length).eq(msg.signers.length);
      expect(msgdoc.message.message.signers[0].addr).eq(msg.signers[0].addr);
      expect(msgdoc.message.message.app).eq(msg.app);
      expect(msgdoc.message.message.timestamp).eq(msg.timestamp);
      expect(msgdoc.message.message.metadata).eq(msg.metadata);
    });

    it('ProofOfSignature', async () => {
      const msg: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: mocks.signer.address,
        agreementCID: paddRigthStr('ProofOfAuthority proof cid'),
        app: 'daosign',
        timestamp: 1702609048, // Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const sig = signMessage(mocks.privateKey, 'ProofOfSignature', msg);

      console.log(
        util.inspect(
          {
            message: msg,
            signature: sig,
            proofCID: paddRigthStr('ProofOfSignature proof cid'),
          },
          true,
          null,
          true,
        ),
      );
      const tx = mocks.app.storeProofOfSignature({
        message: msg,
        signature: sig,
        proofCID: paddRigthStr('ProofOfSignature proof cid'),
      });
      await expect(tx).emit(mocks.app, 'NewProofOfSignature');

      const msgdoc = await mocks.app.getProofOfSignature(
        paddRigthStr('ProofOfSignature proof cid'),
      );
      expect(msgdoc.signature).eq(sig);
      expect(msgdoc.message.domain.name).eq('daosign');
      expect(msgdoc.message.domain.version).eq('0.1.0');
      cmp(msgdoc.message.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(msgdoc.message.types.ProofOfSignature, [
        { name: 'name', type: 'string' },
        { name: 'signer', type: 'address' },
        { name: 'agreementCID', type: 'string' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(msgdoc.message.primaryType).eq('ProofOfSignature');
      expect(msgdoc.message.message.name).eq(msg.name);
      expect(msgdoc.message.message.signer).eq(msg.signer);
      expect(msgdoc.message.message.agreementCID).eq(msg.agreementCID);
      expect(msgdoc.message.message.app).eq(msg.app);
      expect(msgdoc.message.message.timestamp).eq(msg.timestamp);
      expect(msgdoc.message.message.metadata).eq(msg.metadata);
    });

    it('ProofOfAgreement', async () => {
      const msg: ProofOfAgreementStruct = {
        agreementCID: paddRigthStr('ProofOfAuthority proof cid'),
        signatureCIDs: [paddRigthStr('ProofOfSignature proof cid')],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'proof metadata',
      };
      const sig = signMessage(mocks.privateKey, 'ProofOfAgreement', msg);
      console.log(
        util.inspect(
          {
            message: msg,
            signature: sig,
            proofCID: paddRigthStr('ProofOfAgreement proof cid'),
          },
          true,
          null,
          true,
        ),
      );

      const tx = mocks.app.storeProofOfAgreement({
        message: msg,
        signature: sig,
        proofCID: paddRigthStr('ProofOfAgreement proof cid'),
      });
      await expect(tx).emit(mocks.app, 'NewProofOfAgreement');

      const msgdoc = await mocks.app.getProofOfAgreement(
        paddRigthStr('ProofOfAgreement proof cid'),
      );
      expect(msgdoc.signature).eq(sig);
      expect(msgdoc.message.domain.name).eq('daosign');
      expect(msgdoc.message.domain.version).eq('0.1.0');
      cmp(msgdoc.message.types.EIP712Domain, [
        { name: 'name', type: 'string' },
        { name: 'version', type: 'string' },
        { name: 'chainId', type: 'uint256' },
        { name: 'verifyingContract', type: 'address' },
      ]);
      cmp(msgdoc.message.types.ProofOfAgreement, [
        { name: 'agreementCID', type: 'string' },
        { name: 'signatureCIDs', type: 'string[]' },
        { name: 'app', type: 'string' },
        { name: 'timestamp', type: 'uint256' },
        { name: 'metadata', type: 'string' },
      ]);
      expect(msgdoc.message.message.agreementCID).eq(msg.agreementCID);
      expect(msgdoc.message.message.signatureCIDs.length).eq(msg.signatureCIDs.length);
      expect(msgdoc.message.message.signatureCIDs[0]).eq(msg.signatureCIDs[0]);
      expect(msgdoc.message.message.app).eq(msg.app);
      expect(msgdoc.message.message.timestamp).eq(msg.timestamp);
      expect(msgdoc.message.message.metadata).eq(msg.metadata);
    });
  });
});
