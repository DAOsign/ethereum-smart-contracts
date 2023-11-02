// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { ERC165Checker } from '@openzeppelin/contracts/utils/introspection/ERC165Checker.sol';
import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { IProofsMetadata } from './interfaces/IProofsMetadata.sol';
import { IProofs } from './interfaces/IProofs.sol';
import { StringsExpanded } from './libs/StringsExpanded.sol';
import { ProofsVerification } from './libs/ProofsVerification.sol';
import { ProofsHelper } from './libs/ProofsHelper.sol';
import { ProofTypes } from './libs/common/ProofTypes.sol';
import { ECDSA } from '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

/**
 * Stores DAOsign proofs.
 *
 * Note
 * Proof-of-Authority = PoA
 * Proof-of-Signature = PoS
 * Proof-of-Agreement = PoAg
 */
contract Proofs is Ownable, IProofs {
    using StringsExpanded for string;
    using ECDSA for bytes32;

    address public proofsMetadata;

    // Agreement File CID -> proof CID -> proof data
    mapping(string => mapping(string => string)) public finalProofs;

    // hashed proof params -> proof data
    mapping(bytes32 => string) public poaData;
    mapping(bytes32 => string) public posData;
    mapping(bytes32 => string) public poagData;

    constructor(address _proofsMetadata, address _admin) {
        require(
            ERC165Checker.supportsERC165(_proofsMetadata) &&
                IERC165(_proofsMetadata).supportsInterface(type(IProofsMetadata).interfaceId),
            'Must support IProofsMetadata'
        );
        proofsMetadata = _proofsMetadata;
        _transferOwnership(_admin);
    }

    /**
     * Stores Proof-of-Authority after verifying the correctness of the signature
     * @param _creator Agreement creator address
     * @param _signers List of signer addresses
     * @param _signature Signature of Proof-of-Authority data
     * @param _fileCID IPFS CID of the agreement file
     * @param _proofCID IPFS CID of Proof-of-Authority
     */
    function storeProofOfAuthority(
        address _creator,
        address[] calldata _signers,
        string calldata _version,
        bytes calldata _signature,
        string calldata _fileCID,
        string calldata _proofCID
    ) external onlyOwner {
        require(_proofCID.length() > 0, 'No ProofCID');
        require(finalProofs[_fileCID][_proofCID].length() == 0, 'Proof already stored');
        string memory _poaData = getPoAData(_creator, _signers, _fileCID, _version);
        require(
            ProofsVerification.verifySignedProof(_creator, _poaData, _signature),
            'Invalid signature'
        );

        string memory proof = ProofsHelper.getProofOfAuthorityOrSignature(
            _creator,
            _signature,
            _poaData
        );
        finalProofs[_fileCID][_proofCID] = proof;

        emit ProofOfAuthorityEvent(_creator, _signature, _fileCID, _proofCID, proof);
    }

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
    struct ProofOfAuthority {
        address addr;
        bytes sig;
        string version;
        ProofOfAuthorityMsg message;
    }

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256('EIP712Domain(string name,string version)');
    bytes32 constant PROOF_AUTHORITY_TYPEHASH =
        keccak256(
            'ProofOfAuthorityMsg(string name,address from,string agreementFileCID,Signer[] signers,string app,uint64 timestamp,string metadata)Signer(address addr,string metadata)'
        );
    bytes32 constant SIGNER_TYPEHASH = keccak256('Signer(address addr,string metadata)');

    function hash(EIP712Domain memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(_input.name)),
            keccak256(bytes(_input.version))
        );
        return keccak256(encoded);
    }

    function hash(Signer memory _input) internal pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            SIGNER_TYPEHASH,
            _input.addr,
            keccak256(bytes(_input.metadata))
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

    function hash(ProofOfAuthorityMsg memory _input) public pure returns (bytes32) {
        bytes memory encoded = abi.encode(
            PROOF_AUTHORITY_TYPEHASH,
            keccak256(bytes(_input.name)),
            _input.from,
            keccak256(bytes(_input.agreementFileCID)),
            hash(_input.signers),
            keccak256(bytes(_input.app)),
            _input.timestamp,
            keccak256(bytes(_input.metadata))
        );
        return keccak256(encoded);
    }

    function store(ProofOfAuthority memory poa, bytes memory signature) public {
        require(recover(poa.message, signature) == poa.message.from, 'Invalid signature');
        // require(validate(message));
        // save(message);
    }

    function recover(
        ProofOfAuthorityMsg memory message,
        bytes memory signature
    ) public pure returns (address) {
        bytes32 DOMAIN_HASH = hash(EIP712Domain({ name: 'daosign', version: '0.1.0' }));

        bytes32 packetHash = hash(message);
        bytes32 digest = keccak256(abi.encodePacked('\x19\x01', DOMAIN_HASH, packetHash));
        return digest.recover(signature);
    }

    /**
     * Stores Proof-of-Signature after verifying the correctness of the signature
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _signature Signature of Proof-of-Signature data
     * @param _fileCID IPFS CID of the agreement file
     * @param _posCID IPFS CID of Proof-of-Signature
     */
    function storeProofOfSignature(
        address _signer,
        bytes calldata _signature,
        string calldata _fileCID,
        string calldata _posCID,
        string calldata _poaCID,
        string calldata _version
    ) external onlyOwner {
        require(_posCID.length() > 0, 'No ProofCID');
        require(finalProofs[_fileCID][_posCID].length() == 0, 'Proof already stored');
        string memory _posData = getPoSData(_signer, _fileCID, _poaCID, _version);
        require(
            ProofsVerification.verifySignedProof(_signer, _posData, _signature),
            'Invalid signature'
        );

        string memory proof = ProofsHelper.getProofOfAuthorityOrSignature(
            _signer,
            _signature,
            _posData
        );
        finalProofs[_fileCID][_posCID] = proof;

        emit ProofOfSignatureEvent(_signer, _signature, _fileCID, _posCID, proof);
    }

    /**
     * Stores Proof-of-Agreement
     * @param _fileCID IPFS CID of the agreement file
     * @param _poaCID IPFS CID of Proof-of-Authority
     * @param _posCIDs IPFS CIDs of Proof-of-Signature
     * @param _poagCID IPFS CID of Proof-of-Agreement
     */
    function storeProofOfAgreement(
        string calldata _fileCID,
        string calldata _poaCID,
        string[] calldata _posCIDs,
        string calldata _poagCID
    ) external onlyOwner {
        require(_poagCID.length() > 0, 'No ProofCID');
        require(_fileCID.length() > 0, 'No Agreement File CID');
        require(finalProofs[_fileCID][_poagCID].length() == 0, 'Proof already stored');
        require(finalProofs[_fileCID][_poaCID].length() > 0, 'Invalid input data');

        finalProofs[_fileCID][_poagCID] = getPoAgData(_fileCID, _poaCID, _posCIDs);

        emit ProofOfAgreementEvent(_fileCID, _poaCID, _poagCID, finalProofs[_fileCID][_poagCID]);
    }

    function getPoAData(
        address _creator,
        address[] calldata _signers,
        string calldata _fileCID,
        string calldata _version
    ) public view returns (string memory) {
        bytes32 key = keccak256(abi.encode(_creator, _signers, _fileCID, _version));
        return poaData[key];
    }

    function getPoSData(
        address _signer,
        string calldata _fileCID,
        string calldata _poaCID,
        string calldata _version
    ) public view returns (string memory) {
        bytes32 key = keccak256(abi.encode(_signer, _fileCID, _poaCID, _version));
        return posData[key];
    }

    function getPoAgData(
        string calldata _fileCID,
        string calldata _poaCID,
        string[] calldata _posCIDs
    ) public view returns (string memory) {
        bytes32 key = keccak256(abi.encode(_fileCID, _poaCID, _posCIDs));
        return poagData[key];
    }

    function _setPoAData(
        address _creator,
        address[] memory _signers,
        string memory _fileCID,
        string memory _version,
        string memory _data
    ) internal {
        bytes32 key = keccak256(abi.encode(_creator, _signers, _fileCID, _version));
        poaData[key] = _data;
    }

    function _setPoSData(
        address _signer,
        string memory _fileCID,
        string memory _poaCID,
        string memory _version,
        string memory _data
    ) internal {
        bytes32 key = keccak256(abi.encode(_signer, _fileCID, _poaCID, _version));
        posData[key] = _data;
    }

    function _setPoAgData(
        string memory _fileCID,
        string memory _poaCID,
        string[] memory _posCID,
        string memory _data
    ) internal {
        bytes32 key = keccak256(abi.encode(_fileCID, _poaCID, _posCID));
        poagData[key] = _data;
    }
}
