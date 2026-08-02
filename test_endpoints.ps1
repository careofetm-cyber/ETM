$ErrorActionPreference = "Continue"

$loginBody = '{"email":"priya.patel@techcorp.com","password":"password123"}'
$loginResp = Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/auth/login' -Method POST -ContentType 'application/json' -Body $loginBody
$token = $loginResp.token
Write-Host "LOGIN OK"

$headers = @{Authorization = "Bearer $token"}

# Test various endpoints
$endpoints = @(
    '/auth/profile',
    '/dashboard/employee',
    '/trips/',
    '/employees/',
    '/otp/employee/emp_usr_01_emp',
    '/otp/generate',
    '/vehicles/',
    '/drivers/'
)

foreach ($ep in $endpoints) {
    try {
        $resp = Invoke-WebRequest -Uri "https://etm-gp12.onrender.com/api/v1$ep" -Method GET -Headers $headers -ErrorAction Stop
        Write-Host "OK $ep : $($resp.StatusCode) - $($resp.Content.Substring(0, [Math]::Min(200, $resp.Content.Length)))"
    } catch {
        $code = 0
        try { $code = [int]$_.Exception.Response.StatusCode } catch {}
        Write-Host "FAIL $ep : $code - $($_.Exception.Message.Substring(0, [Math]::Min(100, $_.Exception.Message.Length)))"
    }
    Start-Sleep -Milliseconds 500
}
