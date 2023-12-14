import util from 'util';
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
  MockPolkadotDAOSignEIP712,
} from '../typechain-types/mocks/MockPolkadotDAOSignEIP712';
import { paddRigthStr, signMessage } from './utils';

describe('Polkadot EIP712', () => {
  const domain: EIP712DomainStruct = {
    name: 'daosign',
    version: '0.1.0',
    chainId: 0,
    verifyingContract: ethers.ZeroAddress,
  };

  let mocks: {
    privateKey: Buffer;
    signer: HardhatEthersSigner;
    app: MockPolkadotDAOSignEIP712;
  };

  async function deployProofsFixture() {
    const [[signer], DAOSignEIP712] = await Promise.all([
      ethers.getSigners(),
      ethers.getContractFactory('MockPolkadotDAOSignEIP712'),
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

  describe('EIP712 Recover', () => {
    it('ProofOfAuthority', async () => {
      const { privateKey, signer, app } = mocks;
      const message: ProofOfAuthorityStruct = {
        name: 'Proof-of-Authority',
        from: signer.address,
        agreementCID: paddRigthStr('agreementCID'),
        signers: [{ addr: signer.address, metadata: 'metadata' }],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'metadatas',
      };
      console.log();
      console.log(util.inspect({ message }, true, null, true));
      const signature = signMessage(privateKey, 'ProofOfAuthority', message);
      console.log({ signature });
      const recovered = await app.recoverProofOfAuthority(message, signature);
      console.log({ recovered });
      expect(recovered).eq(signer.address);
    });

    it('ProofOfSignature', async () => {
      const { privateKey, signer, app } = mocks;
      const message: ProofOfSignatureStruct = {
        name: 'Proof-of-Signature',
        signer: signer.address,
        agreementCID: paddRigthStr('agreementCID'),
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'metadata',
      };
      console.log();
      console.log(util.inspect({ message }, true, null, true));
      const signature = signMessage(privateKey, 'ProofOfSignature', message);
      console.log({ signature });
      const recovered = await app.recoverProofOfSignature(message, signature);
      console.log({ recovered });
      expect(recovered).eq(signer.address);
    });

    it('ProofOfAgreement', async () => {
      const { privateKey, signer, app } = mocks;
      const message: ProofOfAgreementStruct = {
        agreementCID: paddRigthStr('agreementCID'),
        signatureCIDs: [paddRigthStr('signatureCID0'), paddRigthStr('signatureCID1')],
        app: 'daosign',
        timestamp: Math.floor(Date.now() / 1000),
        metadata: 'metadata',
      };
      console.log();
      console.log(util.inspect({ message }, true, null, true));
      const signature = signMessage(privateKey, 'ProofOfAgreement', message);
      console.log({ signature });
      const recovered = await app.recoverProofOfAgreement(message, signature);
      console.log({ recovered });
      expect(recovered).eq(signer.address);
    });
  });
});
