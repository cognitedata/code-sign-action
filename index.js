const core = require('@actions/core');
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function sign() {
  const pathToBinary = core.getInput('path-to-binary');
  const options = core.getInput('options');

  core.info(`Signing binary...`);
  return await exec('.\\sign.ps1 ' + pathToBinary + ' ' + options, {'shell':'powershell.exe'});
}

async function run() {
  try {
    const { stdout, stderr } = await sign();

    if (stderr) {
      console.error('stderr:', stderr);
      throw new Error(stderr);
    }
    console.log(stdout);
    core.setOutput('result', stdout);
  } catch (error) {
    console.error('error:', error.message);
    core.setFailed(`Action failed with error: ${error}`);
  }
}

run();
