import { expect } from 'chai';
import { SignTypedDataVersion, signTypedData } from '@metamask/eth-sig-util';
import { ethers } from 'hardhat';
import {
  EIP712PropertyTypeStructOutput,
  ProofOfAuthorityStruct,
  ProofOfSignatureStruct,
  ProofOfAgreementStruct,
} from '../typechain-types/DAOSignApp.sol/DAOSignApp';

export function paddRigthStr(value: string, ln: number = 46): string {
  if (value.length > ln) {
    return value.slice(0, ln);
  }
  return (
    value +
    Array(ln - value.length)
      .fill(' ')
      .join('')
  );
}

export function cmp(
  act: Array<EIP712PropertyTypeStructOutput>,
  exp: Array<{ name: string; type: string }>,
) {
  expect(act.length).eq(exp.length);
  for (let i = 0; i < exp.length; i++) {
    expect(exp[i].name).eq(act[i].name);
    expect(exp[i].type).eq(act[i].type);
  }
}

export function signMessage(
  pkey: Buffer,
  primaryType: 'ProofOfAuthority' | 'ProofOfSignature' | 'ProofOfAgreement',
  message: ProofOfAuthorityStruct | ProofOfSignatureStruct | ProofOfAgreementStruct,
): string {
  return signTypedData({
    privateKey: pkey,
    version: SignTypedDataVersion.V4,
    data: {
      domain: {
        name: 'daosign',
        version: '0.1.0',
      },
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
          { name: 'agreementCID', type: 'string' },
          { name: 'signers', type: 'Signer[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
          { name: 'metadata', type: 'string' },
        ],
        ProofOfSignature: [
          { name: 'name', type: 'string' },
          { name: 'signer', type: 'address' },
          { name: 'authorityCID', type: 'string' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
          { name: 'metadata', type: 'string' },
        ],
        ProofOfAgreement: [
          { name: 'authorityCID', type: 'string' },
          { name: 'signatureCIDs', type: 'string[]' },
          { name: 'app', type: 'string' },
          { name: 'timestamp', type: 'uint256' },
          { name: 'metadata', type: 'string' },
        ],
      },
      primaryType,
      message,
    },
  });
}
