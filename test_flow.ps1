$token = (Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/auth/login' -Method POST -ContentType 'application/json' -Body '{"email":"priya.patel@techcorp.com","password":"password123"}').token
Write-Host "=== EMPLOYEE LOGIN OK ==="

Write-Host "`n--- Step 1: Employee Ride Screen ---"
Write-Host "OTP endpoint (old backend): Will get 404"
Write-Host "Fallback: Dashboard endpoint works"

$dash = Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/dashboard/employee' -Method GET -Headers @{Authorization = "Bearer $token"}
$tripId = $dash.nextTrip.id
Write-Host "Active trip ID: $tripId"
Write-Host "Route: $($dash.nextTrip.routeName)"
Write-Host "Status: $($dash.nextTrip.status)"
Write-Host "Local OTP will be generated on device and displayed to employee"

Write-Host "`n--- Step 2: Get trip passengers ---"
$passengers = Invoke-RestMethod -Uri "https://etm-gp12.onrender.com/api/v1/trips/$tripId/passengers" -Method GET -Headers @{Authorization = "Bearer $token"}
foreach ($p in $passengers.data) {
    $name = "$($p.firstName) $($p.lastName)"
    Write-Host "  Passenger: $name | Boarded: $($p.isBoarded) | Dropped: $($p.isDropped)"
}

Write-Host "`n--- Step 3: Driver login and verify ---"
$drvToken = (Invoke-RestMethod -Uri 'https://etm-gp12.onrender.com/api/v1/auth/login' -Method POST -ContentType 'application/json' -Body '{"email":"driver1@techcorp.com","password":"password123"}').token
Write-Host "Driver login OK"

Write-Host "`n--- Step 4: Board passenger (emp_usr_01_emp) ---"
try {
    $boardResp = Invoke-RestMethod -Uri "https://etm-gp12.onrender.com/api/v1/trips/$tripId/passengers/emp_usr_01_emp/board" -Method POST -ContentType 'application/json' -Body '{}' -Headers @{Authorization = "Bearer $drvToken"}
    Write-Host "Board OK: $($boardResp.message)"
} catch {
    Write-Host "Board FAIL: $($_.Exception.Message)"
}

Write-Host "`n--- Step 5: Drop passenger ---"
try {
    $dropResp = Invoke-RestMethod -Uri "https://etm-gp12.onrender.com/api/v1/trips/$tripId/passengers/emp_usr_01_emp/drop" -Method POST -ContentType 'application/json' -Body '{}' -Headers @{Authorization = "Bearer $drvToken"}
    Write-Host "Drop OK: $($dropResp.message)"
} catch {
    Write-Host "Drop FAIL: $($_.Exception.Message)"
}

Write-Host "`n--- Step 6: Verify passenger status ---"
$passengers2 = Invoke-RestMethod -Uri "https://etm-gp12.onrender.com/api/v1/trips/$tripId/passengers" -Method GET -Headers @{Authorization = "Bearer $token"}
foreach ($p in $passengers2.data) {
    $name = "$($p.firstName) $($p.lastName)"
    Write-Host "  Passenger: $name | Boarded: $($p.isBoarded) | Dropped: $($p.isDropped)"
}

Write-Host "`n=== OTP FLOW SUMMARY ==="
Write-Host "1. Employee sees OTP on ride screen (generated locally since backend OTP routes missing)"
Write-Host "2. Employee tells driver the OTP verbally"
Write-Host "3. Driver enters OTP in verify dialog"
Write-Host "4. Backend /otp/verify returns 404 (old code)"
Write-Host "5. Driver app catches 404 and proceeds to board passenger directly"
Write-Host "6. Same for drop - driver enters OTP, backend ignores it, drop succeeds"
Write-Host "7. Once Render is updated with new code, full server-side OTP verification will work"
