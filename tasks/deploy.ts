import { task } from 'hardhat/config';

task('deploy', 'Deploy DAOSign application').setAction(async function (_, { ethers }) {
  const [[owner], DAOSignApp] = await Promise.all([
    ethers.getSigners(),
    ethers.getContractFactory('DAOSignApp'),
  ]);
  const daoSignApp = await DAOSignApp.connect(owner).deploy();
  console.log(`Transaction: ${daoSignApp.deploymentTransaction()?.hash}`);
  console.log(`DAOSign app: ${await daoSignApp.getAddress()}`);
});
