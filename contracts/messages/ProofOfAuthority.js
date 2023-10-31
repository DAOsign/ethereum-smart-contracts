const ProofOfAuthority = {
  domain: {
    name: "daosign",
    version: "0.1.0",
  },
  primaryType: "ProofOfAuthority",
  types: {
    EIP712Domain: [
      { name: "name", type: "string" },
      { name: "version", type: "string" },
      { name: "chainId", type: "uint256" },
      { name: "verifyingContract", type: "address" },
    ],
    Signer: [
      { name: "addr", type: "address" },
      { name: "data", type: "string" },
    ],
    ProofOfAuthority: [
      { name: "name", type: "string" },
      { name: "from", type: "address" },
      { name: "filecid", type: "string" },
      { name: "signers", type: "Signer[]" },
      { name: "app", type: "string" },
      { name: "timestamp", type: "uint256" },
      { name: "metadata", type: "string" },
    ],
  },
};

module.exports = ProofOfAuthority;