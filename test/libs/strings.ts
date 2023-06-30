import { loadFixture } from '@nomicfoundation/hardhat-toolbox/network-helpers';
import { expect } from 'chai';
import { deployStringsLibrary } from '../../scripts/deployForTest';

describe('Strings library', () => {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployStringsFixture() {
    const { strings } = await deployStringsLibrary();

    return { strings };
  }

  it('length', async () => {
    const { strings } = await loadFixture(deployStringsFixture);

    expect(await strings.length('')).to.equal(0);
    expect(await strings.length(' _ ')).to.equal(3);
    expect(await strings.length('om-om-om')).to.equal(8);
  });
});
