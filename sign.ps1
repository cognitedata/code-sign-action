Param(
    [Parameter(Mandatory)]
    [string]$Certificate, 
    
    [Parameter(Mandatory)]
    [string]$CertificatePassword, 
    
    [Parameter(Mandatory)]
    [string]$PathToBinary, 
    
    [Parameter()]
    [switch]$Recursive
)

Get-LocalUser

Write-Output "Read certificate into a file"
$Certificate | OutFile "C:\\Users\\?\\Documents\\cognite_code_signing.pfx"

Write-Output "Import code signing certificate to Local Cert Store"
Import-PfxCertificate -FilePath "C:\\Users\\?\\Documents\\cognite_code_signing.pfx" -Password  (ConvertTo-SecureString -String $CertificatePassword -AsPlainText -Force)  -Cert "Cert:\\LocalMachine\\My"
\$cert = (Get-ChildItem -Path "Cert:\\LocalMachine\\My" | Where-Object {\$_.Subject -Match "Cognite AS"})[0]

Write-Output "Sign binary"
Set-AuthenticodeSignature -FilePath $PathToBinary -Certificate \$cert

Write-Output "Remove code signing certificate from Local Cert Store"
Get-ChildItem Cert:\\LocalMachine\\My | Where-Object {\$_.Subject -Match "Cognite AS"} | Remove-Item


# TODO: Handle files recursively
if ($Recursive.IsPresent) {
    Write-Host "Sign all files in folder"
}