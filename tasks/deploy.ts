import { task } from 'hardhat/config';
import { HardhatRuntimeEnvironment } from 'hardhat/types';
import {
  deployProofs,
  deployProofsHelper,
  deployProofsMetadata,
  deployProofsVerification,
  deployStringsExpanded,
} from '../scripts/deploy';

const deployAll = async (hre: HardhatRuntimeEnvironment, ownerAddr: string) => {
  console.log(`Deploying from address ${(await hre.ethers.getSigners())[0].address}`);
  console.log('Wait for up to 10 minutes.....');
  console.log(
    'You may want to check transactions from the deployment address \
on etherscan.io or goerli.etherscan.io',
  );

  // StringsExpanded
  console.log('\nDeploying StringsExpanded library...');
  const { strings } = await deployStringsExpanded(hre);
  const stringsAddr = await strings.getAddress();
  console.log(`\x1b[42m StringsExpanded \x1b[0m\x1b[32m ${stringsAddr}\x1b[0m`);

  // ProofsMetadata
  console.log('\nDeploying ProofsMetadata contract...');
  const { proofsMetadata } = await deployProofsMetadata(hre, stringsAddr);
  const proofsMetadataAddr = await proofsMetadata.getAddress();
  console.log(`\x1b[42m ProofsMetadata \x1b[0m\x1b[32m ${proofsMetadataAddr}\x1b[0m`);

  // ProofsVerification
  console.log('\nDeploying ProofsVerification library...');
  const { proofsVerification } = await deployProofsVerification(hre);
  const proofsVerificationAddr = await proofsVerification.getAddress();
  console.log(`\x1b[42m ProofsVerification \x1b[0m\x1b[32m ${proofsVerificationAddr}\x1b[0m`);

  // ProofsHelper
  console.log('\nDeploying ProofsHelper library...');
  const { proofsHelper } = await deployProofsHelper(hre, stringsAddr);
  const proofsHelperAddr = await proofsHelper.getAddress();
  console.log(`\x1b[42m ProofsHelper \x1b[0m\x1b[32m ${proofsHelperAddr}\x1b[0m`);

  // Proofs
  console.log('\nDeploying Proofs contract...');
  const { proofs } = await deployProofs(
    hre,
    stringsAddr,
    proofsVerificationAddr,
    proofsHelperAddr,
    proofsMetadataAddr,
    ownerAddr,
  );
  const proofsAddr = await proofs.getAddress();
  console.log(`\x1b[42m Proofs \x1b[0m\x1b[32m ${proofsAddr}\x1b[0m\n`);

  return { stringsAddr, proofsMetadataAddr, proofsVerificationAddr, proofsHelperAddr, proofsAddr };
};

const verifyAll = async (
  hre: HardhatRuntimeEnvironment,
  strings: string,
  proofsMetadata: string,
  proofsVerification: string,
  proofsHelper: string,
  proofs: string,
) => {
  // StringsExpanded
  await hre.run('verify:verify', {
    address: strings,
  });
  // ProofsMetadata
  await hre.run('verify:verify', {
    address: proofsMetadata,
    libraries: { StringsExpanded: strings },
  });
  // ProofsVerification
  await hre.run('verify:verify', {
    address: proofsVerification,
  });
  // ProofsHelper
  await hre.run('verify:verify', {
    address: proofsHelper,
    libraries: { StringsExpanded: strings },
  });
  // Proofs
  await hre.run('verify:verify', {
    address: proofs,
    libraries: {
      StringsExpanded: strings,
      ProofsVerification: proofsVerification,
      ProofsHelper: proofsHelper,
    },
    constructorArguments: [proofsMetadata],
  });
};

task(
  'deploy-and-verify:all',
  'Deploy all smart contracts and libraries and verify them on Etherscan',
)
  .addParam('owner', 'Owner of Proofs contract')
  .setAction(async ({ owner: ownerAddr }, hre) => {
    const {
      stringsAddr,
      proofsMetadataAddr,
      proofsVerificationAddr,
      proofsHelperAddr,
      proofsAddr,
    } = await deployAll(hre, ownerAddr);
    await verifyAll(
      hre,
      stringsAddr,
      proofsMetadataAddr,
      proofsVerificationAddr,
      proofsHelperAddr,
      proofsAddr,
    );
  });

// First deployment
task('deploy:all', 'Deploy all smart contracts and libraries for the first time')
  .addParam('owner', 'Owner of Proofs contract')
  .setAction(async ({ owner: ownerAddr }, hre) => {
    await deployAll(hre, ownerAddr);
  });

// Following deployments
task(
  'deploy:contracts',
  'Deploy only contracts by providing addresses of already deployed libraries',
)
  .addParam('strings', 'StringsExpanded library address')
  .addParam('proofsVerification', 'ProofsVerification library address')
  .addParam('proofsHelper', 'ProofsHelper library address')
  .addParam('owner', 'Owner of Proofs contract')
  .setAction(async ({ strings, proofsVerification, proofsHelper, owner: ownerAddr }, hre) => {
    console.log(`Deploying from address ${(await hre.ethers.getSigners())[0].address}`);
    console.log('Wait for up to 5 minutes.....');
    console.log(
      'You may want to check transactions from the deployment address \
on etherscan.io or goerli.etherscan.io',
    );
    console.log({ strings, proofsVerification, proofsHelper });

    console.log('\nDeploying ProofsMetadata contract...');
    const { proofsMetadata } = await deployProofsMetadata(hre, strings);
    const proofsMetadataAddr = await proofsMetadata.getAddress();
    console.log(`\x1b[42m ProofsMetadata \x1b[0m\x1b[32m ${proofsMetadataAddr}\x1b[0m`);

    console.log('\nDeploying Proofs contract...');
    const { proofs } = await deployProofs(
      hre,
      strings,
      proofsVerification,
      proofsHelper,
      proofsMetadataAddr,
      ownerAddr,
    );
    console.log(`\x1b[42m Proofs \x1b[0m\x1b[32m ${await proofs.getAddress()}\x1b[0m\n`);
  });

task('verify:all')
  .addParam('strings', 'StringsExpanded library address')
  .addParam('proofsMetadata', 'ProofsMetadata contract address')
  .addParam('proofsVerification', 'ProofsVerification library address')
  .addParam('proofsHelper', 'ProofsHelper  library address')
  .addParam('proofs', 'Proofs contract address')
  .setAction(async ({ strings, proofsMetadata, proofsVerification, proofsHelper, proofs }, hre) => {
    await verifyAll(hre, strings, proofsMetadata, proofsVerification, proofsHelper, proofs);
  });
