# code-sign-action

The code-sign-action action integrates with Digicert One and uses SignTool on Windows runners and JSign on Linux runners. The code-sign-action has been tested on the following GitHub runners:
  - windows-2025
  - windows-2022
  - ubuntu-22.04
  - ubuntu-20.04

Note: Nuget packages can only be signed using Windows runners.
------------

## Usage

### Environment

- `CERTIFICATE_HOST`: https://clientauth.one.digicert.com
- `CERTIFICATE_HOST_API_KEY`: An API key created for the GitHub Actions service user in Digicert One.
- `CERTIFICATE_FINGERPRINT`: __Nuget only!__ The fingerprint value of the certificate to be used to search in a local certificate store. Have to be one of (SHA-256, SHA-384, and SHA-512).
- `CLIENT_CERTIFICATE`: Client authentication certificate created for the GitHub Actions service user in Digicert One.(.p12 file)
- `CLIENT_CERTIFICATE_PASSWORD`: Client authentication certificate password created for the GitHub Actions service user in Digicert One.
- `KEYPAIR_ALIAS`: Keypair alias value found in the "Keypair details" section of the "Certificates" page in your KeyLocker dashboard.

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
    runs-on: windows-2025
    steps:
      - name: Run the action for a single file
        env:
          CERTIFICATE_HOST: ${{ secrets.CODE_SIGNING_CERT_HOST }}
          CERTIFICATE_HOST_API_KEY: ${{ secrets.CODE_SIGNING_CERT_HOST_API_KEY }}
          CERTIFICATE_FINGERPRINT: ${{ secrets.CODE_SIGNING_CERT_SHA256_HASH }}
          CLIENT_CERTIFICATE: ${{ secrets.CODE_SIGNING_CLIENT_CERT }}
          CLIENT_CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CLIENT_CERT_PASSWORD }}
          KEYPAIR_ALIAS: ${{ secrets.CODE_SIGNING_KEYPAIR_ALIAS }}
        uses: cognitedata/code-sign-action/@v5
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
        uses: actions/checkout@v5.0.1

      - name: Run the action for multiple files in directory
        env:
          CERTIFICATE_HOST: ${{ secrets.CODE_SIGNING_CERT_HOST }}
          CERTIFICATE_HOST_API_KEY: ${{ secrets.CODE_SIGNING_CERT_HOST_API_KEY }}
          CLIENT_CERTIFICATE: ${{ secrets.CODE_SIGNING_CLIENT_CERT }}
          CLIENT_CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CLIENT_CERT_PASSWORD }}
          KEYPAIR_ALIAS: ${{ secrets.CODE_SIGNING_KEYPAIR_ALIAS }}
        uses: cognitedata/code-sign-action/@v5
        with:
          path-to-binary: "test"
```
