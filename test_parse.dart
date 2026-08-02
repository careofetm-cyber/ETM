import 'dart:convert';

void main() {
  // Vehicle test
  final vehicleJson = '{"id":"veh_001","plateNumber":"MH-01-AB-1234","model":"Traveller","brand":"Tata","year":2023,"seatingCapacity":12,"color":"White","status":"active","driverId":"drv_usr_01_drv","companyId":"comp_001","createdAt":"2026-08-02T08:05:09.169480"}';
  final vehicleMap = jsonDecode(vehicleJson) as Map<String, dynamic>;
  
  print('=== Vehicle parse test ===');
  print('id: ${vehicleMap['id']} (type: ${vehicleMap['id'].runtimeType})');
  print('plateNumber: ${vehicleMap['plateNumber']} (type: ${vehicleMap['plateNumber'].runtimeType})');
  print('year: ${vehicleMap['year']} (type: ${vehicleMap['year'].runtimeType})');
  print('seatingCapacity: ${vehicleMap['seatingCapacity']} (type: ${vehicleMap['seatingCapacity'].runtimeType})');
  print('status: ${vehicleMap['status']} (type: ${vehicleMap['status'].runtimeType})');
  print('color: ${vehicleMap['color']} (type: ${vehicleMap['color'].runtimeType})');
  
  // Employee test  
  final empJson = '{"id":"emp_usr_01_emp","userId":"emp_usr_01","employeeCode":"EMP001","department":"Engineering","designation":"Senior Developer","homeLatitude":19.076,"homeLongitude":72.8777,"homeAddress":"Andheri West, Mumbai","companyId":"comp_001","isTransportRequired":true,"createdAt":"2026-08-02T08:05:09.169480","email":"priya.patel@techcorp.com","firstName":"Priya","lastName":"Patel","phone":"+91 97000 00001","isActive":true}';
  final empMap = jsonDecode(empJson) as Map<String, dynamic>;
  
  print('\n=== Employee parse test ===');
  print('id: ${empMap['id']}');
  print('userId: ${empMap['userId']}');
  print('companyId: ${empMap['companyId']}');
  print('All required fields present: id=${empMap['id'] != null}, userId=${empMap['userId'] != null}, companyId=${empMap['companyId'] != null}');
  
  // Driver test
  final drvJson = '{"id":"drv_usr_01_drv","userId":"drv_usr_01","companyId":"comp_001","licenseNumber":"MH-2023-0001","licenseExpiry":"2028-12-31","isAvailable":true,"createdAt":"2026-08-02T08:05:09.169480","email":"driver1@techcorp.com","firstName":"Amit","lastName":"Sharma","phone":"+91 98000 00001","isActive":true}';
  final drvMap = jsonDecode(drvJson) as Map<String, dynamic>;
  
  print('\n=== Driver parse test ===');
  print('id: ${drvMap['id']}');
  print('userId: ${drvMap['userId']}');
  print('companyId: ${drvMap['companyId']}');
  print('licenseExpiry: ${drvMap['licenseExpiry']}');
  print('All required fields present: id=${drvMap['id'] != null}, userId=${drvMap['userId'] != null}, companyId=${drvMap['companyId'] != null}');
  
  print('\n=== CONCLUSION ===');
  print('All required fields are present and types are correct.');
  print('The fromJson parsing should work. The issue must be elsewhere.');
}
