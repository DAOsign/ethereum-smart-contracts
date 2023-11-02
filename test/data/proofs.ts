export const proofOfAuthorityData = {
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
};

export const proofOfSignatureData = {
  types: {
    EIP712Domain: [
      { name: 'name', type: 'string' },
      { name: 'version', type: 'string' },
      { name: 'chainId', type: 'uint64' },
      { name: 'verifyingContract', type: 'address' },
    ],
    ProofOfSignature: [
      { name: 'signer', type: 'address' },
      { name: 'agreementFileProofCID', type: 'string' },
      { name: 'app', type: 'string' },
      { name: 'timestamp', type: 'uint64' },
      { name: 'metadata', type: 'string' },
    ],
  },
  domain: {
    name: 'daosign',
    version: '0.1.0',
  },
  primaryType: 'ProofOfSignature',
};
