const ProofOfAgreement = {
  domain: {
    name: "daosign",
    version: "0.1.0",
  },
  primaryType: "ProofOfAgreement",
  types: {
    EIP712Domain: [
      { name: "name", type: "string" },
      { name: "version", type: "string" },
      { name: "chainId", type: "uint256" },
      { name: "verifyingContract", type: "address" },
    ],
    Filecid: [
      { name: "addr", type: "string" },
      { name: "data", type: "string" },
    ],
    ProofOfAgreement: [
      { "name": "filecid", "type": "string" },
      { "name": "signcids", "type": "Filecid[]" },
      { "name": "app", "type": "string" },
      { "name": "timestamp", "type": "uint256" },
      { "name": "metadata", "type": "string" }
    ],
  },
};

module.exports = ProofOfAgreement;