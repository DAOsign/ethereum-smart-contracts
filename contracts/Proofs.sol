// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

enum ProofKind {
    Authority,
    Signature,
    Agreement
}

struct EIP712Domain {
    string name;
    string version;
    uint256 chainId;
    address verifyingContract;
}

bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
    'EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'
);

/* * *
 * {
 *     "types": {
 *         "EIP712Domain": [
 *             { "name": "name", "type": "string" },
 *             { "name": "version", "type": "string" },
 *             { "name": "chainId", "type": "uint256" },
 *             { "name": "verifyingContract", "type": "address" }
 *         ],
 *         "Signer": [
 *             { "name": "addr", "type": "address" },
 *             { "name": "data", "type": "string" }
 *         ],
 *         "ProofOfAuthority": [
 *             { "name": "name", "type": "string" },
 *             { "name": "from", "type": "address" },
 *             { "name": "filecid", "type": "string" },
 *             { "name": "signers", "type": "Signer[]" },
 *             { "name": "app", "type": "string" },
 *             { "name": "timestamp", "type": "uint256" },
 *             { "name": "metadata", "type": "string" }
 *         ]
 *     },
 *     "domain": {
 *         "name": "daosign",
 *         "version": "0.1.0",
 *     },
 *     "primaryType": "ProofOfAuthority",
 *     "message": {
 *         "name": "Proof-of-Authority",
 *         "from": "<Creator"s address>",
 *         "filecid": "<Agreement File CID>",
 *         "signers": [
 *             { "addr": "<Signer 1 address>", "data": "{}" },
 *             { "addr": "<Signer 2 address>", "data": "{}" },
 *             { "addr": "<Signer 3 address>", "data": "{}" }
 *         ],
 *         "app": "daosign",
 *         "timestamp": <timestamp in seconds>,
 *         "metadata": "{}"
 *     }
 * }
 * */

struct Signer {
    address addr;
    string data;
}

bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string data)');

struct ProofOfAuthority {
    string name;
    address from;
    string filecid;
    Signer[] signers;
    string app;
    uint256 timestamp;
    string metadata;
}

bytes32 constant PROOF_AUTHORITY_TYPEHASH = keccak256(
    'ProofOfAuthority(string name,address from,string filecid,Signer[] signers,string app,uint256 timestamp,string metadata)Signer(address addr,string data)'
);

/* * *
 * {
 *     "types": {
 *         "EIP712Domain": [
 *             { "name": "name", "type": "string" },
 *             { "name": "version", "type": "string" },
 *             { "name": "chainId", "type": "uint256" },
 *             { "name": "verifyingContract", "type": "address" }
 *         ],
 *         "ProofOfSignature": [
 *             { "name": "name", "type": "string" },
 *             { "name": "signer", "type": "address" },
 *             { "name": "filecid", "type": "string" },
 *             { "name": "app", "type": "string" },
 *             { "name": "timestamp", "type": "uint256" },
 *             { "name": "metadata", "type": "string" }
 *         ]
 *     },
 *     "domain": {
 *         "name": "daosign",
 *         "version": "0.1.0"
 *     },
 *     "primaryType": "ProofOfSignature",
 *     "message": {
 *         "name": "Proof-of-Signature",
 *         "signer": "<signer"s address>",
 *         "filecid": "<Agreement File Proof CID>",
 *         "app": "daosign",
 *         "timestamp": <timestamp in seconds>,
 *         "metadata": "{}"
 *     }
 * }
 * */
struct ProofOfSignature {
    string name;
    address signer;
    string filecid;
    string app;
    uint256 timestamp;
    string metadata;
}

bytes32 constant PROOF_SIGNATURE_TYPEHASH = keccak256(
    'ProofOfSignature(string name,address signer,string filecid,string app,uint256 timestamp,string metadata)'
);

/* * *
 * {
 *     "types": {
 *         "EIP712Domain": [
 *             { "name": "name", "type": "string" },
 *             { "name": "version", "type": "string" },
 *             { "name": "chainId", "type": "uint256" },
 *             { "name": "verifyingContract", "type": "address" }
 *         ],
 *         "ProofOfAgreement": [
 *             { "name": "filecid", "type": "string" },
 *             { "name": "signcids", "type": "string[]" },
 *             { "name": "app", "type": "string" },
 *             { "name": "timestamp", "type": "uint256" },
 *             { "name": "metadata", "type": "string" }
 *         ],
 *     },
 *     "domain": {
 *         "name": "daosign",
 *         "version": "0.1.0",
 *     },
 *     "primaryType": "ProofOfAgreement",
 *     "message": {
 *         "filecid": "<Agreement File Proof CID>"
 *         "signcids": [
 *             "<Agreement Sign Proof CID>",
 *             "<Agreement Sign Proof CID>",
 *             "<Agreement Sign Proof CID>",
 *             "<Agreement Sign Proof CID>",
 *         ]
 *         "app": "daosign",
 *         "timestamp": <timestamp in seconds>,
 *         "metadata": "{}"
 *     }
 * }
 * */
struct Filecid {
    string addr;
    string data;
}

bytes32 constant FILECID_TYPEHASH = keccak256('Filecid(string addr,string data)');

struct ProofOfAgreement {
    string filecid;
    Filecid[] signcids;
    string app;
    uint256 timestamp;
    string metadata;
}

bytes32 constant PROOF_AGREEMENT_TYPEHASH = keccak256(
    'ProofOfAgreement(string filecid,Filecid[] signcids,string app,uint256 timestamp,string metadata)Filecid(string addr,string data)'
);

abstract contract Proofs {
    bytes32 DOMAIN_HASH;

    constructor() {
        DOMAIN_HASH = hash(
            EIP712Domain({
                name: 'daosign',
                version: '0.1.0',
                chainId: 0,
                verifyingContract: address(0)
            })
        );
    }

    function hash(EIP712Domain memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(_input.name)),
            keccak256(bytes(_input.version)),
            _input.chainId,
            _input.verifyingContract
        );
        return keccak256(encoded);
    }

    function hash(Signer memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            _input.addr,
            keccak256(bytes(_input.data))
        );
        return keccak256(encoded);
    }

    function hash(Signer[] memory _input) public pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAuthority memory _input) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AUTHORITY_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.from,
            keccak256(bytes(_input.filecid)),
            hash(_input.signers),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(ProofOfSignature memory _input) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_SIGNATURE_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.signer,
            keccak256(bytes(_input.filecid)),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function hash(Filecid memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            FILECID_TYPEHASH,
            keccak256(bytes(_input.addr)),
            keccak256(bytes(_input.data))
        );
        return keccak256(encoded);
    }

    function hash(Filecid[] memory _input) public pure returns (bytes32) {
        bytes memory encoded;
        for (uint i = 0; i < _input.length; i++) {
            encoded = abi.encodePacked(encoded, hash(_input[i]));
        }
        return keccak256(encoded);
    }

    function hash(ProofOfAgreement memory _input) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AGREEMENT_TYPEHASH,
            keccak256(bytes(_input.filecid)),
            hash(_input.signcids),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function recover(bytes32 message, bytes memory sig) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Check the signature length
        if (sig.length != 65) {
            return (address(0));
        }

        // Divide the signature in r, s and v variables
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
        // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
        if (v < 27) {
            v += 27;
        }

        // If the version is correct return the signer address
        if (v != 27 && v != 28) {
            return (address(0));
        } else {
            return ecrecover(message, v, r, s);
        }
    }

    function recover(
        ProofOfAuthority memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfSignature memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function recover(
        ProofOfAgreement memory message,
        bytes memory signature
    ) public view returns (address) {
        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return recover(digest, signature);
    }

    function store(ProofOfAuthority memory message, bytes memory signature) public {
        require(recover(message, signature) == message.from);
        require(validate(message));
        save(message);
    }

    function store(ProofOfSignature memory message, bytes memory signature) public {
        require(recover(message, signature) == message.signer);
        require(validate(message));
        save(message);
    }

    function store(ProofOfAgreement memory message, bytes memory signature) public {
        require(recover(message, signature) == msg.sender);
        require(validate(message));
        save(message);
    }

    function validate(ProofOfAuthority memory) internal view virtual returns (bool);

    function validate(ProofOfSignature memory) internal view virtual returns (bool);

    function validate(ProofOfAgreement memory) internal view virtual returns (bool);

    function save(ProofOfAuthority memory) internal virtual;

    function save(ProofOfSignature memory) internal virtual;

    function save(ProofOfAgreement memory) internal virtual;
}

contract DummyProofs is Proofs {
    mapping(bytes32 => bytes) data;

    function validate(ProofOfAuthority memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfSignature memory) internal pure override returns (bool) {
        return true;
    }

    function validate(ProofOfAgreement memory) internal pure override returns (bool) {
        return true;
    }

    function save(ProofOfAuthority memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfSignature memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }

    function save(ProofOfAgreement memory message) internal override {
        data[keccak256(abi.encode(message))] = abi.encode(message);
    }
}
