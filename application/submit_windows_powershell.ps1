$ErrorActionPreference = "Stop"

$payloadPath = Join-Path $PSScriptRoot "application_payload.json"

if (-not (Test-Path $payloadPath)) {
    Write-Error "application_payload.json was not found. Copy and edit application_payload_template.json first."
}

$body = Get-Content $payloadPath -Raw

if ($body -match "YOUR_USERNAME") {
    Write-Error "Replace YOUR_USERNAME before submitting."
}

$response = Invoke-WebRequest `
    -Uri "https://windbornesystems.com/career_applications.json" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body

Write-Host "Status:" $response.StatusCode
Write-Host "Response:"
Write-Host $response.Content

if ($response.StatusCode -ne 200) {
    throw "Application was not accepted. Review the response body."
}
