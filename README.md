# code-sign-action

This Action can be used to sign Windows binaries. It has been tested on `windows-2022` runners.

------------

## Usage

### Environment

- `CERTIFICATE`: Base64-encoded PKCS #12 archive (.pfx file).
- `CERTIFICATE_PASSWORD`: Pass phrase to decode the .pfx file.

### Inputs

- `path-to-binary`: path to the file to be signed.

#### Optional:
|  Parameter   |                                         Description                                          |      Default       |
| :----------: | :------------------------------------------------------------------------------------------: | :----------------: |
|   options    |                   Use "-Recurse" to recursively search for and sign files                    |        null        |

### Examples

#### Sign one file

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
      - name: Run the action for a single binary
        env:
          CERTIFICATE: ${{ secrets.CODE_SIGNING_CERTIFICATE }}
          CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CERTIFICATE_PASSWORD }}
        uses: cognitedata/code-sign-action/@v1
        with:
          path-to-binary: 'files\some_file.exe'
```

#### Sign multiple files

```yaml
name: codesign-example-multiple-files
on:
  push:
    branches:
      - main
      - 'releases/*'

jobs:
  run-action:
    runs-on: windows-2022
    steps:
      - name: Run the action for all binaries under a folder
        env:
          CERTIFICATE: ${{ secrets.CODE_SIGNING_CERTIFICATE }}
          CERTIFICATE_PASSWORD: ${{ secrets.CODE_SIGNING_CERTIFICATE_PASSWORD }}
        uses: cognitedata/code-sign-action/@v1
        with:
          path-to-binary: 'files'
          options: '-Recurse'
```

