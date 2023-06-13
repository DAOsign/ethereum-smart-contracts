import { ethers } from 'hardhat';

/**
 * Deploy all project smart contracts for testing purposes
 */

export const deployStringsLibrary = async () => {
  const strings = await (await ethers.getContractFactory('Strings')).deploy();

  return strings;
};

export const deployProofsMetadata = async () => {
  const strings = await deployStringsLibrary();
  const proofsMetadata = await (
    await ethers.getContractFactory('ProofsMetadata', {
      libraries: { Strings: await strings.getAddress() },
    })
  ).deploy();

  return proofsMetadata;
};

export const deployProofs = async () => {
  const proofsMetadata = await deployProofsMetadata();
  const proofs = await (
    await ethers.getContractFactory('Proofs')
  ).deploy(await proofsMetadata.getAddress());

  return proofs;
};

// async function main() {
//   const currentTimestampInSeconds = Math.round(Date.now() / 1000);
//   const unlockTime = currentTimestampInSeconds + 60;

//   const lockedAmount = ethers.parseEther('0.001');

//   const lock = await ethers.deployContract('Lock', [unlockTime], {
//     value: lockedAmount,
//   });

//   await lock.waitForDeployment();

//   console.log(
//     `Lock with ${ethers.formatEther(
//       lockedAmount
//     )}ETH and unlock timestamp ${unlockTime} deployed to ${lock.target}`
//   );
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
