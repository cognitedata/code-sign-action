# code-sign-action

This Action can be used to sign Windows binaries. It needs

- a code signing certificate and key in a PKCS #12 archive (.pfx file);
- a key to decrypt the PKCS #12 archive.

The recommended way of providing these inputs is to store them as Actions Secrets made available to this action.

The action requires a Windows runner to run and it has been tested on `windows-2022` runners.
