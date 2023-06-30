export const proofOfAuthorityData = {
  types: {
    EIP712Domain: [
      { name: 'name', type: 'string' },
      { name: 'version', type: 'string' },
      { name: 'chainId', type: 'uint64' },
      { name: 'verifyingContract', type: 'address' },
    ],
    Agreement: [
      { name: 'from', type: 'address' },
      { name: 'agreementFileCID', type: 'string' },
      { name: 'signers', type: 'Signers' },
      { name: 'app', type: 'string' },
      { name: 'timestamp', type: 'uint64' },
      { name: 'metadata', type: 'string' },
    ],
    Signers: [
      { name: 'address', type: 'string' },
      { name: 'metadata', type: 'string' },
    ],
  },
  domain: {
    name: 'daosign',
    version: '0.1.0',
  },
  primaryType: 'Agreement',
};

export const proofOfSignatureData = {
  types: {
    EIP712Domain: [
      { name: 'name', type: 'string' },
      { name: 'version', type: 'string' },
      { name: 'chainId', type: 'uint64' },
      { name: 'verifyingContract', type: 'address' },
    ],
    Agreement: [
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
  primaryType: 'Agreement',
};
