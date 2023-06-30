import { ethers } from 'hardhat';

/**
 * Deploy all project smart contracts for testing purposes
 */

export const deployStringsLibrary = async () => {
  const strings = await (await ethers.getContractFactory('Strings')).deploy();

  return { strings };
};

export const deployProofsMetadata = async () => {
  const { strings } = await deployStringsLibrary();
  const proofsMetadata = await (
    await ethers.getContractFactory('ProofsMetadata', {
      libraries: { Strings: await strings.getAddress() },
    })
  ).deploy();

  return { proofsMetadata, strings };
};

export const deployProofs = async () => {
  const { proofsMetadata, strings } = await deployProofsMetadata();
  const proofs = await (
    await ethers.getContractFactory('Proofs', {
      libraries: { Strings: await strings.getAddress() },
    })
  ).deploy(await proofsMetadata.getAddress());

  return { proofs, proofsMetadata, strings };
};
