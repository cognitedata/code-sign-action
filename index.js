const core = require('@actions/core');
const {exec} = require('child_process');

/** Sign binary
 * @param {string} certificate - The base64 encoded certificate.
 * @param {string} certificatePassword - The password for the certificate.
 * @param {string} pathToBinary - The folder that contains the files to sign.
 * @param {string} recursive - Recursively search for supported files.
*/
async function sign(certificate,
    certificatePassword,
    pathToBinary,
    recursive=false) {
  core.info(`Execute PS script to sign binary`);

  exec('./sign.ps1',
      [certificate, certificatePassword, pathToBinary, recursive],
      (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          core.setFailed(error.message);
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
      });
}

async function run() {
  try {
    const certificate = core.getInput('certificate');
    const certificatePassword = core.getInput('certificate-password');
    const pathToBinary = core.getInput('path-to-binary');
    const recursive = core.getInput('recursive');

    const {output} = await sign(certificate,
        certificatePassword,
        pathToBinary,
        recursive);

    core.setOutput('result', output);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();
