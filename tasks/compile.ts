import { existsSync, readFileSync, writeFileSync } from 'fs';
import { extendEnvironment } from 'hardhat/config';

extendEnvironment(function (hre) {
  const fnames = [
    './artifacts/contracts/DAOSignApp.sol/DAOSignApp.json',
    './artifacts/contracts/DAOSignApp.sol/DAOSignBaseApp.json',
    './artifacts/contracts/mocks/MockDAOSignEIP712.sol/MockDAOSignEIP712.json',
  ];
  const action = hre.tasks['typechain:generate-types'].action;
  hre.tasks['typechain:generate-types'].setAction(async function (...params) {
    for (const fname of fnames) {
      if (!existsSync(fname)) {
        throw new Error(`file "${fname}" doesn't exist`);
      }
      const fdata = readFileSync(fname, { encoding: 'utf-8' });
      writeFileSync(fname, fdata.replaceAll('kind', 'type'));
    }
    return action(...params);
  });
});
