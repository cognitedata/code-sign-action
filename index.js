const core = require('@actions/core');
const { exec } = require('child_process');

async function sign(certificate, certificate_password, path_to_binary, recursive=false) {
    core.info(`Execute PS script to sign binary`);

    exec("./sign.ps1", [certificate, certificate_password, path_to_binary, recursive], (error, stdout, stderr) => {
        if (error) {
          console.error(`exec error: ${error}`);
          core.setFailed(err.message);
        }
        console.log(`stdout: ${stdout}`);
        console.error(`stderr: ${stderr}`);
      });
}
async function run() {
  try {
    const certificate = core.getInput('certificate');
    const certificate_password = core.getInput('certificate-password');
    const path_to_binary = core.getInput('path-to-binary');
    const recursive = core.getInput('recursive');
    
    const { output } = await sign(certificate, certificate_password, path_to_binary, recursive);

    core.setOutput('result', output);
  } catch (error) {
    core.setFailed(error.message);
  }
}

run();