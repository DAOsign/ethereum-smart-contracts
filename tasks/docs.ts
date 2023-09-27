import { task } from 'hardhat/config';
import fs from 'fs';
import path from 'path';

task('docs', 'Generate documentation based on the comments in the code').setAction(
  async (_, hre) => {
    // Remove all docs except for `requirements.txt` file
    const docsPath = path.join(__dirname, '..', 'docs');
    fs.readdirSync(docsPath).forEach((fileName) => {
      if (fileName !== 'requirements.txt') {
        const filePath = path.join(docsPath, fileName);
        if (fs.statSync(filePath).isDirectory()) {
          fs.rmdirSync(filePath, { recursive: true });
        } else {
          fs.unlinkSync(filePath);
        }
      }
    });

    // Regenerate the docs
    await hre.run('docgen');
  },
);
