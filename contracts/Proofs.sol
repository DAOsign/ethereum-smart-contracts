// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

abstract contract Proofs {
    struct EIP712Domain {
        string name;
        string version;
    }

    struct Signer {
        address addr;
        string metadata;
    }

    struct ProofOfAuthorityMsg {
        string name;
        address from;
        string agreementFileCID;
        Signer[] signers;
        string app;
        uint64 timestamp;
        string metadata;
    }

    struct ProofOfAuthorityShrinked {
        bytes sig;
        string version;
        ProofOfAuthorityMsg message;
    }

    struct ProofOfSignatureMsg {
        string name;
        address signer;
        string agreementFileProofCID;
        string app;
        uint64 timestamp;
        string metadata;
    }

    struct ProofOfSignatureShrinked {
        bytes sig;
        string version;
        ProofOfSignatureMsg message;
    }

    struct AgreementSignProof {
        string proofCID;
    }

    struct ProofOfAgreement {
        string agreementFileProofCID;
        AgreementSignProof[] agreementSignProofs;
        uint64 timestamp;
        string metadata;
    }

    event NewProofOfAuthority(ProofOfAuthorityShrinked indexed proof, string indexed proofCID);
    event NewProofOfSignature(ProofOfSignatureShrinked indexed proof, string indexed proofCID);
    event NewProofOfAgreement(ProofOfAgreement indexed proof, string indexed proofCID);

    event DomainHashUpdated(EIP712Domain indexed domain);
    event EIP712DomainTypeHashUpdated(string indexed eip712DomainTypeHash);
    event SignerTypeHashUpdated(string indexed signerTypeHash);
    event ProofAuthorityTypeHashUpdated(string indexed proofAuthorityTypeHash);
    event ProofSignatureTypeHashUpdated(string indexed proofSignatureTypeHash);
    event AgrSignProofTypeHashUpdated(string indexed agrSignProofTypeHash);
    event ProofAgreementTypeHashUpdated(string indexed proofAgreementTypeHash);

    function _recover(
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) public view virtual returns (address);

    function _recover(
        ProofOfSignatureMsg memory message,
        bytes memory signature
    ) public view virtual returns (address);

    function _hash(EIP712Domain memory _input) internal view virtual returns (bytes32);

    function _hash(Signer memory _input) internal view virtual returns (bytes32);

    function _hash(Signer[] memory _input) internal view virtual returns (bytes32);

    function _hash(ProofOfAuthorityMsg memory _input) internal view virtual returns (bytes32);

    function _hash(ProofOfSignatureMsg memory _input) internal view virtual returns (bytes32);

    function _hash(AgreementSignProof memory _input) internal view virtual returns (bytes32);

    function _hash(AgreementSignProof[] memory _input) internal view virtual returns (bytes32);

    function _hash(ProofOfAgreement memory _input) internal view virtual returns (bytes32);

    function _validate(ProofOfAuthorityShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfSignatureShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfAgreement memory) internal view virtual returns (bool);

    function _store(ProofOfAuthorityShrinked memory, string memory) internal virtual;

    function _store(ProofOfSignatureShrinked memory, string memory) internal virtual;

    function _store(ProofOfAgreement memory, string memory) internal virtual;
}
