export const proofJSONtoBytes = (proof: object) =>
  '0x'.concat(Buffer.from(JSON.stringify(proof).slice(0, -1), 'utf8').toString('hex'));
