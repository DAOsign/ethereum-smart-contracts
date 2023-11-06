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

    event NewProofOfAuthority(ProofOfAuthorityShrinked indexed proof);
    event NewProofOfSignature(ProofOfSignatureShrinked indexed proof);
    event NewProofOfAgreement(ProofOfAgreement indexed proof);

    event DomainHashUpdated(EIP712Domain indexed domain);
    event EIP712DomainTypeHashUpdated(string indexed eip712DomainTypeHash);
    event SignerTypeHashUpdated(string indexed signerTypeHash);
    event ProofAuthorityTypeHashUpdated(string indexed proofAuthorityTypeHash);
    event ProofSignatureTypeHashUpdated(string indexed proofSignatureTypeHash);
    event AgrSignProofTypeHashUpdated(string indexed agrSignProofTypeHash);
    event ProofAgreementTypeHashUpdated(string indexed proofAgreementTypeHash);

    function recover(
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) public view virtual returns (address);

    function recover(
        ProofOfSignatureMsg memory message,
        bytes memory signature
    ) public view virtual returns (address);

    function hash(EIP712Domain memory _input) internal view virtual returns (bytes32);

    function hash(Signer memory _input) internal view virtual returns (bytes32);

    function hash(Signer[] memory _input) internal view virtual returns (bytes32);

    function hash(ProofOfAuthorityMsg memory _input) internal view virtual returns (bytes32);

    function hash(ProofOfSignatureMsg memory _input) internal view virtual returns (bytes32);

    function hash(AgreementSignProof memory _input) internal view virtual returns (bytes32);

    function hash(AgreementSignProof[] memory _input) internal view virtual returns (bytes32);

    function hash(ProofOfAgreement memory _input) internal view virtual returns (bytes32);

    function _validate(ProofOfAuthorityShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfSignatureShrinked memory) internal view virtual returns (bool);

    function _validate(ProofOfAgreement memory) internal view virtual returns (bool);

    function _store(ProofOfAuthorityShrinked memory, string memory) internal virtual;

    function _store(ProofOfSignatureShrinked memory, string memory) internal virtual;

    function _store(ProofOfAgreement memory, string memory) internal virtual;
}
