import { task } from 'hardhat/config';

task('deploy', 'Deploy DAOSign application').setAction(async function (_, { ethers }) {
  const sleep = (n: number = 1) => new Promise((r) => setTimeout(r, n * 1000));

  const [
    [owner],
    DAOSignApp,
    MockTradeFI,
    EIP721ProofOfAuthority,
    EIP712ProofOfSignature,
    EIP712ProofOfAgreement,
    EIP712ProofOfVoid,
    EIP712ProofOfCancel,
  ] = await Promise.all([
    ethers.getSigners(),
    ethers.getContractFactory('DAOSignApp'),
    ethers.getContractFactory('MockTradeFI'),
    ethers.getContractFactory('EIP721ProofOfAuthority'),
    ethers.getContractFactory('EIP712ProofOfSignature'),
    ethers.getContractFactory('EIP712ProofOfAgreement'),
    ethers.getContractFactory('EIP712ProofOfVoid'),
    ethers.getContractFactory('EIP712ProofOfCancel'),
  ]);

  const eip721ProofOfAuthority = await EIP721ProofOfAuthority.connect(owner).deploy();
  const eip721ProofOfAuthorityAddr = await eip721ProofOfAuthority.getAddress();
  console.log(`Transaction: ${eip721ProofOfAuthority.deploymentTransaction()?.hash}`);
  console.log(`EIP721ProofOfAuthority msg impl: ${eip721ProofOfAuthorityAddr}`);
  await sleep(5);

  const eip712ProofOfSignature = await EIP712ProofOfSignature.connect(owner).deploy();
  const eip712ProofOfSignatureAddr = await eip712ProofOfSignature.getAddress();
  console.log(`Transaction: ${eip712ProofOfSignature.deploymentTransaction()?.hash}`);
  console.log(`EIP712ProofOfSignature msg impl: ${eip712ProofOfSignatureAddr}`);
  await sleep(5);

  const eip712ProofOfAgreement = await EIP712ProofOfAgreement.connect(owner).deploy();
  const eip712ProofOfAgreementAddr = await eip712ProofOfAgreement.getAddress();
  console.log(`Transaction: ${eip712ProofOfAgreement.deploymentTransaction()?.hash}`);
  console.log(`EIP712ProofOfAgreement msg impl: ${eip712ProofOfAgreementAddr}`);
  await sleep(5);

  const eip712ProofOfVoid = await EIP712ProofOfVoid.connect(owner).deploy();
  const eip712ProofOfVoidAddr = await eip712ProofOfVoid.getAddress();
  console.log(`Transaction: ${eip712ProofOfVoid.deploymentTransaction()?.hash}`);
  console.log(`EIP712ProofOfVoid msg impl: ${eip712ProofOfVoidAddr}`);
  await sleep(5);

  const eio712ProofOfCancel = await EIP712ProofOfCancel.connect(owner).deploy();
  const eio712ProofOfCancelAddr = await eio712ProofOfCancel.getAddress();
  console.log(`Transaction: ${eio712ProofOfCancel.deploymentTransaction()?.hash}`);
  console.log(`EIP712ProofOfCancel msg impl: ${eio712ProofOfCancelAddr}`);
  await sleep(5);

  const mockTradeFI = await MockTradeFI.connect(owner).deploy();
  const mockTradeFIAddr = await mockTradeFI.getAddress();
  console.log(`Transaction: ${mockTradeFI.deploymentTransaction()?.hash}`);
  console.log(`Mock TradeFI: ${mockTradeFIAddr}`);
  await sleep(5);

  const daoSignApp = await DAOSignApp.connect(owner).deploy(
    eip721ProofOfAuthorityAddr,
    eip712ProofOfSignatureAddr,
    eip712ProofOfAgreementAddr,
    eip712ProofOfVoidAddr,
    eio712ProofOfCancelAddr,
    mockTradeFIAddr,
  );
  console.log(`Transaction: ${daoSignApp.deploymentTransaction()?.hash}`);
  console.log(`DAOSign app: ${await daoSignApp.getAddress()}`);
});
