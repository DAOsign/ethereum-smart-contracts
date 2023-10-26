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

    // TODO: sequence? create counter on smart contract and use it for dataSign in fetch functions
    /**
     * Generates Proof-of-Authority data for creator to sign and caches it in the smart contract
     * memory
     * @param _creator Agreement creator address
     * @param _signers Array of signers of the agreement
     * @param _fileCID IPFS CID of the agreement file
     * @param _version EIP712 version of the data
     * @param _dataSig _creator's signature of all input parameters to make sure they are correct
     * @return proofData Proof-of-Authority data to sign
     */
    function fetchProofOfAuthorityData(
        address _creator,
        address[] calldata _signers,
        string calldata _fileCID,
        string calldata _version,
        bytes calldata _dataSig
    ) external onlyOwner returns (string memory) {
        bytes32 _dataHash = keccak256(abi.encodePacked(_creator, _signers, _fileCID, _version));
        require(ProofsVerification.verify(_creator, _dataHash, _dataSig), 'Invalid data signature');
        if (getPoAData(_creator, _signers, _fileCID, _version).length() > 0) {
            return getPoAData(_creator, _signers, _fileCID, _version);
        }
        string memory proofData = ProofsHelper.getProofOfAuthorityData(
            proofsMetadata,
            _creator,
            _signers,
            _fileCID,
            _version,
            block.timestamp
        );
        _setPoAData(_creator, _signers, _fileCID, _version, proofData);
        return proofData;
    }

    /**
     * Generates Proof-of-Signature data for creator to sign and caches it in the smart contract
     * memory
     * @param _signer Current signer of the agreement from the list of agreement signers
     * @param _fileCID IPFS CID of the agreement file
     * @param _poaCID IPFS CID of Proof-of-Authority
     * @param _version EIP712 version of the data
     * @return proofData Proof-of-Signature data to sign
     */
    function fetchProofOfSignatureData(
        address _signer,
        string calldata _fileCID,
        string calldata _poaCID,
        string calldata _version,
        bytes calldata _dataSig
    ) external onlyOwner returns (string memory) {
        require(_fileCID.length() > 0, 'No Agreement File CID');
        bytes32 _dataHash = keccak256(abi.encodePacked(_signer, _fileCID, _poaCID, _version));
        require(ProofsVerification.verify(_signer, _dataHash, _dataSig), 'Invalid data signature');
        if (getPoSData(_signer, _fileCID, _poaCID, _version).length() > 0) {
            return getPoSData(_signer, _fileCID, _poaCID, _version);
        }
        require(finalProofs[_fileCID][_poaCID].length() > 0, 'No Proof-of-Authority');

        string memory proofData = ProofsHelper.getProofOfSignatureData(
            proofsMetadata,
            _signer,
            _poaCID,
            _version,
            block.timestamp
        );
        _setPoSData(_signer, _fileCID, _poaCID, _version, proofData);
        return proofData;
    }

    /**
     * Generates Proof-of-Agreement data for creator to sign and caches it in the smart contract
     * memory
     * @param _fileCID IPFS CID of the agreement file
     * @param _poaCID IPFS CID of Proof-of-Authority
     * @param _posCID IPFS CID of Proof-of-Signature
     * @return proofData Proof-of-Agreement data to sign
     */
    function fetchProofOfAgreementData(
        string calldata _fileCID,
        string calldata _poaCID,
        string[] calldata _posCID
    ) external onlyOwner returns (string memory) {
        require(_fileCID.length() > 0, 'No Agreement File CID');
        if (getPoAgData(_fileCID, _poaCID, _posCID).length() > 0) {
            return getPoAgData(_fileCID, _poaCID, _posCID);
        }
        require(finalProofs[_fileCID][_poaCID].length() > 0, 'No Proof-of-Authority');
        for (uint256 i = 0; i < _posCID.length; i++) {
            require(finalProofs[_fileCID][_posCID[i]].length() > 0, 'No Proof-of-Signature');
        }
        string memory proofData = ProofsHelper.getProofOfAgreementData(
            _poaCID,
            _posCID,
            block.timestamp
        );
        _setPoAgData(_fileCID, _poaCID, _posCID, proofData);
        return proofData;
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

        emit ProofOfAuthority(_creator, _signature, _fileCID, _proofCID, proof);
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

        emit ProofOfSignature(_signer, _signature, _fileCID, _posCID, proof);
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

        emit ProofOfAgreement(_fileCID, _poaCID, _poagCID, finalProofs[_fileCID][_poagCID]);
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
