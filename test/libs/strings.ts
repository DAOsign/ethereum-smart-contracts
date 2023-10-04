import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { ethers } from 'hardhat';
import { deployStringsExpandedLibrary } from '../../scripts/deploy';

describe('Strings library', () => {
  async function deployStringsFixture() {
    const { strings } = await deployStringsExpandedLibrary();

    return { strings };
  }

  it('length', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    expect(await strings.length('')).equal(0);
    expect(await strings.length(' _ ')).equal(3);
    expect(await strings.length('om-om-om')).equal(8);
  });

  it('concatenate', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    expect(await strings.concat('DAO', 'sign')).equal('DAOsign');
    expect(await strings.concat('', 'DAO')).equal('DAO');
    expect(await strings.concat('DAO', '')).equal('DAO');
  });

  it('uint256 to string', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    expect(await strings['toString(uint256)'](0)).equal('0');
    expect(await strings['toString(uint256)'](5)).equal('5');
    // 2^256 - 1
    expect(
      await strings['toString(uint256)'](
        '115792089237316195423570985008687907853269984665640564039457584007913129639935',
      ),
    ).equal('115792089237316195423570985008687907853269984665640564039457584007913129639935');
  });

  it('address to string', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    expect(await strings['toString(address)'](ethers.ZeroAddress)).equal(ethers.ZeroAddress);
    // Mixed case -> lower case
    expect(await strings['toString(address)']('0x4D07e28E9EE6DC715b98f589169d7927239d7318')).equal(
      '0x4d07e28e9ee6dc715b98f589169d7927239d7318',
    );
    // Lower case -> lower case
    expect(await strings['toString(address)']('0x4d07e28e9ee6dc715b98f589169d7927239d7318')).equal(
      '0x4d07e28e9ee6dc715b98f589169d7927239d7318',
    );
  });

  it('bytes to hex string', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    // Test for empty bytes
    expect(await strings.toHexString('0x')).to.equal('0x');

    // Test for ASCII bytes
    expect(await strings.toHexString('0x68656c6c6f')).to.equal('0x68656c6c6f');

    // Test for non-ASCII bytes
    expect(await strings.toHexString('0x000102ff')).to.equal('0x000102ff');
  });
});
