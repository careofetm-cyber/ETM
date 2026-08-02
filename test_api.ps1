$token = (Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/auth/login' -Method POST -ContentType 'application/json' -Body '{"email":"priya.patel@techcorp.com","password":"password123"}').token
Write-Host "Token obtained"

Write-Host "`n=== OTP Employee ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/otp/employee/emp_usr_01_emp"

Write-Host "`n=== Dashboard Employee ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/dashboard/employee"

Write-Host "`n=== Auth Profile ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/auth/profile"

Write-Host "`n=== Trips ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/trips/"

Write-Host "`n=== Vehicles ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/vehicles/"

Write-Host "`n=== Drivers ==="
& curl.exe -s -H "Authorization: Bearer $token" "https://etm-gp12.onrender.com/api/v1/drivers/"
