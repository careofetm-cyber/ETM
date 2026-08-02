$ErrorActionPreference = "Continue"

# Login as employee
$loginBody = '{"email":"priya.patel@techcorp.com","password":"password123"}'
$loginResp = Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/auth/login' -Method POST -ContentType 'application/json' -Body $loginBody
$token = $loginResp.token
Write-Host "LOGIN OK, token: $($token.Substring(0, 30))..."

# Test OTP endpoint
try {
    $otpResp = Invoke-WebRequest -Uri 'https://etm-gp12.onrender.com/api/v1/otp/employee/emp_usr_01_emp' -Method GET -Headers @{Authorization = "Bearer $token"}
    Write-Host "OTP STATUS: $($otpResp.StatusCode)"
    Write-Host "OTP BODY: $($otpResp.Content)"
} catch {
    $statusCode = [int]$_.Exception.Response.StatusCode
    Write-Host "OTP ERROR STATUS: $statusCode"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    $body = $reader.ReadToEnd()
    Write-Host "OTP ERROR BODY: $body"
}

# Test dashboard
try {
    $dashResp = Invoke-WebRequest -Uri 'https://etm-gp12.onrender.com/api/v1/dashboard/employee' -Method GET -Headers @{Authorization = "Bearer $token"}
    Write-Host "`nDASHBOARD STATUS: $($dashResp.StatusCode)"
    Write-Host "DASHBOARD BODY: $($dashResp.Content.Substring(0, [Math]::Min(500, $dashResp.Content.Length)))"
} catch {
    $statusCode = [int]$_.Exception.Response.StatusCode
    Write-Host "DASHBOARD ERROR STATUS: $statusCode"
    $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    $body = $reader.ReadToEnd()
    Write-Host "DASHBOARD ERROR BODY: $body"
}
