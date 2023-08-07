# code-sign-action

This Action integrates with Digicert One and uses SignTool on Windows runners and JSign on Linux runners. It has been tested on `windows-2022`, `ubuntu-20.04` and `ubuntu-22.04` runners.

------------

## Usage

### Environment

- `CERTIFICATE_HOST`: https://clientauth.one.digicert.com
- `CERTIFICATE_HOST_API_KEY`: An API key created for the GitHub Actions service user in Digicert One.
- `CERTIFICATE_SHA1_HASH`: SHA1 fingerprint of the code signing certificate.
- `CLIENT_CERTIFICATE`: Client authentication certificate created for the GitHub Actions service user in Digicert One.(.p12 file)
- `CLIENT_CERTIFICATE_PASSWORD`: Client authentication certificate password created for the GitHub Actions service user in Digicert One.

### Inputs

- `path-to-binary`: Takes either a file path or a directory path containing the files to be signed.

### Examples

#### Sign a single file on Windows

```yaml
name: codesign-example-single-file
on:
  push:
    branches:
      - main
      - 'releases/*'

jobs:
  run-action:
    runs-on: windows-2022
    steps:
      - name: Run the action for a single file
        env:
          CERTIFICATE_HOST: ${{ secrets.CODE_SIGNING_CERT_HOST }}
          CERTIFICATE_HOST_API_KEY: ${{ secrets.CODE_SIGNING_CERT_HOST_API_KEY }}
          CERTIFICATE_SHA1_HASH: ${{ secrets.CODE_SIGNING_CERT_SHA1_HASH }}
          CLIENT_CERTIFICATE: ${{ secrets.CODE_SIGNING_CLIENT_CERT }}
          CLIENT_CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CLIENT_CERT_PASSWORD }}
        uses: cognitedata/code-sign-action/@v2
        with:
          path-to-binary: 'test\test.dll'
```

#### Sign multiple files on Linux

```yaml
name: codesign-example-multiple-files
on:
  pull_request:
  push:
    branches:
      - main
      - "releases/*"

jobs:
  run-action-linux:
    runs-on: ubuntu-22.04
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Run the action for multiple files in directory
        env:
          CERTIFICATE_HOST: ${{ secrets.CODE_SIGNING_CERT_HOST }}
          CERTIFICATE_HOST_API_KEY: ${{ secrets.CODE_SIGNING_CERT_HOST_API_KEY }}
          CERTIFICATE_SHA1_HASH: ${{ secrets.CODE_SIGNING_CERT_SHA1_HASH }}
          CLIENT_CERTIFICATE: ${{ secrets.CODE_SIGNING_CLIENT_CERT }}
          CLIENT_CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CLIENT_CERT_PASSWORD }}
        uses: cognitedata/code-sign-action/@v2
        with:
          path-to-binary: "test"
```

