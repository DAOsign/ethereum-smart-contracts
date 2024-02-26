import { task } from 'hardhat/config';

task('deploy', 'Deploy DAOSign application').setAction(async function (_, { ethers }) {
  const [
    [owner],
    DAOSignProxy,
    DAOSignApp,
    MockTradeFI,
    EIP721ProofOfAuthority,
    EIP712ProofOfSignature,
    EIP712ProofOfAgreement,
    EIP712ProofOfVoid,
    EIP712ProofOfCancel,
  ] = await Promise.all([
    ethers.getSigners(),
    ethers.getContractFactory('DAOSignProxy'),
    ethers.getContractFactory('DAOSignApp'),
    ethers.getContractFactory('MockTradeFI'),
    ethers.getContractFactory('EIP721ProofOfAuthority'),
    ethers.getContractFactory('EIP712ProofOfSignature'),
    ethers.getContractFactory('EIP712ProofOfAgreement'),
    ethers.getContractFactory('EIP712ProofOfVoid'),
    ethers.getContractFactory('EIP712ProofOfCancel'),
  ]);

  const eip721ProofOfAuthorityTx = await EIP721ProofOfAuthority.connect(owner).deploy();
  console.log(
    `EIP721ProofOfAuthority transaction: ${eip721ProofOfAuthorityTx.deploymentTransaction()?.hash}`,
  );
  const eip721ProofOfAuthority = await eip721ProofOfAuthorityTx.waitForDeployment();
  console.log(`EIP721ProofOfAuthority msg impl: ${await eip721ProofOfAuthority.getAddress()}`);

  const eip712ProofOfSignatureTx = await EIP712ProofOfSignature.connect(owner).deploy();
  console.log(
    `EIP712ProofOfSignature transaction: ${eip712ProofOfSignatureTx.deploymentTransaction()?.hash}`,
  );
  const eip712ProofOfSignature = await eip712ProofOfSignatureTx.waitForDeployment();
  console.log(`EIP712ProofOfSignature msg impl: ${await eip712ProofOfSignature.getAddress()}`);

  const eip712ProofOfAgreementTx = await EIP712ProofOfAgreement.connect(owner).deploy();
  console.log(
    `EIP712ProofOfAgreement transaction: ${eip712ProofOfAgreementTx.deploymentTransaction()?.hash}`,
  );
  const eip712ProofOfAgreement = await eip712ProofOfAgreementTx.waitForDeployment();
  console.log(`EIP712ProofOfAgreement msg impl: ${await eip712ProofOfAgreement.getAddress()}`);

  const eip712ProofOfVoidTx = await EIP712ProofOfVoid.connect(owner).deploy();
  console.log(
    `EIP712ProofOfVoid transaction: ${eip712ProofOfVoidTx.deploymentTransaction()?.hash}`,
  );
  const eip712ProofOfVoid = await eip712ProofOfVoidTx.waitForDeployment();
  console.log(`EIP712ProofOfVoid msg impl: ${await eip712ProofOfVoid.getAddress()}`);

  const eio712ProofOfCancelTx = await EIP712ProofOfCancel.connect(owner).deploy();
  console.log(
    `EIP712ProofOfCancel transaction: ${eio712ProofOfCancelTx.deploymentTransaction()?.hash}`,
  );
  const eip712ProofOfCancel = await eio712ProofOfCancelTx.waitForDeployment();
  console.log(`EIP712ProofOfCancel msg impl: ${await eip712ProofOfCancel.getAddress()}`);

  const mockTradeFItx = await MockTradeFI.connect(owner).deploy();
  console.log(`Mock TradeFI transaction: ${mockTradeFItx.deploymentTransaction()?.hash}`);
  const mockTradeFI = await mockTradeFItx.waitForDeployment();
  console.log(`Mock TradeFI: ${await mockTradeFI.getAddress()}`);

  const daoSignAppTx = await DAOSignApp.connect(owner).deploy(
    eip721ProofOfAuthority.getAddress(),
    eip712ProofOfSignature.getAddress(),
    eip712ProofOfAgreement.getAddress(),
    eip712ProofOfVoid.getAddress(),
    eip712ProofOfCancel.getAddress(),
    mockTradeFI.getAddress(),
  );
  console.log(`DAOSign app transaction: ${daoSignAppTx.deploymentTransaction()?.hash}`);
  const daoSignApp = await daoSignAppTx.waitForDeployment();
  console.log(`DAOSign app: ${await daoSignApp.getAddress()}`);

  const daoSignProxyTx = await DAOSignProxy.connect(owner).deploy(
    await daoSignApp.getAddress(),
    owner.address,
  );
  console.log(`DAOSign proxy transaction: ${daoSignProxyTx.deploymentTransaction()?.hash}`);
  const daoSignProxy = await daoSignProxyTx.waitForDeployment();
  console.log(`DAOSign proxy: ${await daoSignProxy.getAddress()}`);
});
