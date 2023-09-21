import { ethers } from 'hardhat';

/**
 * Deploy all project smart contracts for testing purposes
 */

export const deployStringsExpandedLibrary = async () => {
  const strings = await (await ethers.getContractFactory('StringsExpanded')).deploy();

  return { strings };
};

export const deployProofsVerificationLibrary = async () => {
  const proofsVerification = await (await ethers.getContractFactory('ProofsVerification')).deploy();

  return { proofsVerification };
};

export const deployProofsHelperLibrary = async () => {
  const { strings } = await deployStringsExpandedLibrary();
  const proofsHelper = await (
    await ethers.getContractFactory('ProofsHelper', {
      libraries: { StringsExpanded: await strings.getAddress() },
    })
  ).deploy();

  return { proofsHelper };
};

export const deployProofsMetadata = async () => {
  const { strings } = await deployStringsExpandedLibrary();
  const proofsMetadata = await (
    await ethers.getContractFactory('ProofsMetadata', {
      libraries: { StringsExpanded: await strings.getAddress() },
    })
  ).deploy();

  return { proofsMetadata, strings };
};

export const deployProofs = async () => {
  const { proofsMetadata, strings } = await deployProofsMetadata();
  const { proofsVerification } = await deployProofsVerificationLibrary();
  const { proofsHelper } = await deployProofsHelperLibrary();
  const proofs = await (
    await ethers.getContractFactory('Proofs', {
      libraries: {
        StringsExpanded: await strings.getAddress(),
        ProofsVerification: await proofsVerification.getAddress(),
        ProofsHelper: await proofsHelper.getAddress(),
      },
    })
  ).deploy(await proofsMetadata.getAddress());

  return { proofs, proofsMetadata, strings, proofsVerification, proofsHelper };
};
