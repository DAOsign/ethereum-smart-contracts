const ProofOfSignature = {
  domain: {
    name: "daosign",
    version: "0.1.0",
  },
  primaryType: "ProofOfSignature",
  types: {
    EIP712Domain: [
      { name: "name", type: "string" },
      { name: "version", type: "string" },
      { name: "chainId", type: "uint256" },
      { name: "verifyingContract", type: "address" },
    ],
    ProofOfSignature: [
      { "name": "name", "type": "string" },
      { "name": "signer", "type": "address" },
      { "name": "filecid", "type": "string" },
      { "name": "app", "type": "string" },
      { "name": "timestamp", "type": "uint256" },
      { "name": "metadata", "type": "string" }
    ],
  },
};

module.exports = ProofOfSignature;