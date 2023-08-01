Param(
    [Parameter(Mandatory)]
    [string]$PathToBinary, 
    
    [Parameter()]
    [switch]$Recurse
)

Write-Output "Read certificate into a file"
[IO.File]::WriteAllBytes("C:\\Users\\runneradmin\\Documents\\cognite_code_signing.pfx", [Convert]::FromBase64String($env:CERTIFICATE))

Write-Output "Import code signing certificate to Local Cert Store"
Import-PfxCertificate -FilePath "C:\\Users\\runneradmin\\Documents\\cognite_code_signing.pfx" -Password  (ConvertTo-SecureString -String $env:CERTIFICATE_PASSWORD -AsPlainText -Force)  -Cert "Cert:\\LocalMachine\\My"
Get-ChildItem -Path "Cert:\\LocalMachine\\My"
$cert = (Get-ChildItem -Path "Cert:\\LocalMachine\\My" -CodeSigningCert | Where-Object {$_.Subject -Match "Cognite AS"})[0]

if ($Recurse) {
    Write-Host "Sign all files in folder $PathToBinary"
    Get-ChildItem -Path $PathToBinary -File -Recurse | % {
        Write-Host $_.FullName
        Set-AuthenticodeSignature -FilePath $_.FullName -Certificate $cert
    }
}
else {
    Write-Output "Sign a single binary"
    Set-AuthenticodeSignature -FilePath $PathToBinary -Certificate $cert
}

Write-Output "Remove code signing certificate from Local Cert Store"
Get-ChildItem Cert:\\LocalMachine\\My | Where-Object {$_.Subject -Match "Cognite AS"} | Remove-Item

Write-Output "Code signing completed" 
