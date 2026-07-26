-- ETM Database Schema Migration
-- Version: 1.0.0

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Companies table
CREATE TABLE companies (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  logo VARCHAR(500),
  email VARCHAR(255),
  phone VARCHAR(50),
  address TEXT,
  city VARCHAR(100),
  state VARCHAR(100),
  country VARCHAR(100),
  postal_code VARCHAR(20),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Users table
CREATE TABLE users (
  id VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  phone VARCHAR(50),
  profile_image VARCHAR(500),
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) NOT NULL CHECK (role IN ('admin', 'manager', 'employee', 'driver')),
  company_id VARCHAR(255) REFERENCES companies(id),
  device_token VARCHAR(500),
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Employees table
CREATE TABLE employees (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  company_id VARCHAR(255) REFERENCES companies(id),
  employee_code VARCHAR(50),
  department VARCHAR(100),
  designation VARCHAR(100),
  phone VARCHAR(50),
  alternate_phone VARCHAR(50),
  email VARCHAR(255),
  address TEXT,
  home_latitude DECIMAL(10, 8),
  home_longitude DECIMAL(11, 8),
  home_address TEXT,
  assigned_route_id VARCHAR(255),
  assigned_stop_id VARCHAR(255),
  is_transport_required BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Drivers table
CREATE TABLE drivers (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  company_id VARCHAR(255) REFERENCES companies(id),
  license_number VARCHAR(100),
  license_expiry TIMESTAMP,
  phone VARCHAR(50),
  rating DECIMAL(3, 2) DEFAULT 5.00,
  total_trips INTEGER DEFAULT 0,
  is_available BOOLEAN DEFAULT true,
  is_active BOOLEAN DEFAULT true,
  assigned_vehicle_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Vehicles table
CREATE TABLE vehicles (
  id VARCHAR(255) PRIMARY KEY,
  plate_number VARCHAR(50) UNIQUE NOT NULL,
  model VARCHAR(100) NOT NULL,
  brand VARCHAR(100) NOT NULL,
  year INTEGER NOT NULL,
  seating_capacity INTEGER NOT NULL,
  color VARCHAR(50),
  image_url VARCHAR(500),
  status VARCHAR(50) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'maintenance', 'offline')),
  driver_id VARCHAR(255) REFERENCES drivers(id),
  company_id VARCHAR(255) REFERENCES companies(id),
  current_latitude DECIMAL(10, 8),
  current_longitude DECIMAL(11, 8),
  last_location_update TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Routes table
CREATE TABLE routes (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  company_id VARCHAR(255) REFERENCES companies(id),
  description TEXT,
  total_distance DECIMAL(10, 2),
  estimated_duration INTEGER, -- in minutes
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Stops table
CREATE TABLE stops (
  id VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  address TEXT,
  landmark VARCHAR(255),
  company_id VARCHAR(255) REFERENCES companies(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Route stops table (junction table)
CREATE TABLE route_stops (
  id VARCHAR(255) PRIMARY KEY,
  route_id VARCHAR(255) REFERENCES routes(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  sequence_order INTEGER NOT NULL,
  address TEXT,
  landmark VARCHAR(255),
  estimated_time_from_previous INTEGER, -- in seconds
  distance_from_previous DECIMAL(10, 2) -- in meters
);

-- Trips table
CREATE TABLE trips (
  id VARCHAR(255) PRIMARY KEY,
  route_id VARCHAR(255) REFERENCES routes(id),
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  driver_id VARCHAR(255) REFERENCES drivers(id),
  type VARCHAR(50) NOT NULL CHECK (type IN ('pickup', 'dropoff')),
  status VARCHAR(50) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'inProgress', 'completed', 'cancelled')),
  scheduled_time TIMESTAMP NOT NULL,
  actual_start_time TIMESTAMP,
  actual_end_time TIMESTAMP,
  company_id VARCHAR(255) REFERENCES companies(id),
  total_passengers INTEGER DEFAULT 0,
  boarded_passengers INTEGER DEFAULT 0,
  total_distance DECIMAL(10, 2),
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Trip passengers table
CREATE TABLE trip_passengers (
  id VARCHAR(255) PRIMARY KEY,
  trip_id VARCHAR(255) REFERENCES trips(id) ON DELETE CASCADE,
  employee_id VARCHAR(255) REFERENCES employees(id),
  stop_id VARCHAR(255) REFERENCES stops(id),
  is_boarded BOOLEAN DEFAULT false,
  is_dropped BOOLEAN DEFAULT false,
  boarded_at TIMESTAMP,
  dropped_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Attendance table
CREATE TABLE attendance (
  id VARCHAR(255) PRIMARY KEY,
  employee_id VARCHAR(255) REFERENCES employees(id),
  date TIMESTAMP NOT NULL,
  status VARCHAR(50) NOT NULL CHECK (status IN ('present', 'absent', 'late', 'halfDay', 'onLeave')),
  trip_id VARCHAR(255) REFERENCES trips(id),
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  boarding_method VARCHAR(50) CHECK (boarding_method IN ('qr', 'manual', 'gps')),
  check_in_time TIMESTAMP,
  check_out_time TIMESTAMP,
  check_in_location VARCHAR(255),
  check_out_location VARCHAR(255),
  company_id VARCHAR(255) REFERENCES companies(id),
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- GPS logs table
CREATE TABLE gps_logs (
  id VARCHAR(255) PRIMARY KEY,
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  trip_id VARCHAR(255) REFERENCES trips(id),
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  speed DECIMAL(5, 2),
  heading DECIMAL(5, 2),
  altitude DECIMAL(10, 2),
  timestamp TIMESTAMP NOT NULL
);

-- Fuel logs table
CREATE TABLE fuel_logs (
  id VARCHAR(255) PRIMARY KEY,
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  driver_id VARCHAR(255) REFERENCES drivers(id),
  date TIMESTAMP NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  price_per_unit DECIMAL(10, 2) NOT NULL,
  total_cost DECIMAL(10, 2) NOT NULL,
  odometer_reading DECIMAL(10, 2) NOT NULL,
  fuel_type VARCHAR(50),
  gas_station VARCHAR(255),
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Maintenance table
CREATE TABLE maintenance (
  id VARCHAR(255) PRIMARY KEY,
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  type VARCHAR(50) NOT NULL CHECK (type IN ('regularService', 'oilChange', 'tireRotation', 'brakeService', 'batteryReplacement', 'engineRepair', 'bodyWork', 'other')),
  scheduled_date TIMESTAMP NOT NULL,
  completed_date TIMESTAMP,
  status VARCHAR(50) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'inProgress', 'completed', 'overdue')),
  description TEXT,
  cost DECIMAL(10, 2),
  service_provider VARCHAR(255),
  odometer_at_service INTEGER,
  next_service_odometer INTEGER,
  next_service_date TIMESTAMP,
  notes TEXT,
  documents TEXT[], -- Array of document URLs
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Vehicle inspections table
CREATE TABLE vehicle_inspections (
  id VARCHAR(255) PRIMARY KEY,
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  driver_id VARCHAR(255) REFERENCES drivers(id),
  inspection_date TIMESTAMP NOT NULL,
  is_passed BOOLEAN NOT NULL,
  notes TEXT,
  issues TEXT[],
  created_at TIMESTAMP DEFAULT NOW()
);

-- Incidents table
CREATE TABLE incidents (
  id VARCHAR(255) PRIMARY KEY,
  reported_by VARCHAR(255) REFERENCES users(id),
  vehicle_id VARCHAR(255) REFERENCES vehicles(id),
  trip_id VARCHAR(255) REFERENCES trips(id),
  driver_id VARCHAR(255) REFERENCES drivers(id),
  severity VARCHAR(50) NOT NULL CHECK (severity IN ('low', 'medium', 'high', 'critical')),
  status VARCHAR(50) DEFAULT 'reported' CHECK (status IN ('reported', 'investigating', 'resolved', 'closed')),
  description TEXT NOT NULL,
  location VARCHAR(255),
  latitude DECIMAL(10, 8),
  longitude DECIMAL(11, 8),
  incident_time TIMESTAMP,
  image_urls TEXT[], -- Array of image URLs
  resolution TEXT,
  resolved_by VARCHAR(255) REFERENCES users(id),
  resolved_at TIMESTAMP,
  company_id VARCHAR(255) REFERENCES companies(id),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- SOS alerts table
CREATE TABLE sos_alerts (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  user_type VARCHAR(50) NOT NULL CHECK (user_type IN ('admin', 'manager', 'employee', 'driver')),
  latitude DECIMAL(10, 8) NOT NULL,
  longitude DECIMAL(11, 8) NOT NULL,
  message TEXT,
  is_resolved BOOLEAN DEFAULT false,
  resolved_by VARCHAR(255) REFERENCES users(id),
  resolved_at TIMESTAMP,
  company_id VARCHAR(255) REFERENCES companies(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Notifications table
CREATE TABLE notifications (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  type VARCHAR(50) NOT NULL CHECK (type IN ('trip', 'attendance', 'system', 'emergency', 'maintenance', 'general')),
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  data JSONB,
  is_read BOOLEAN DEFAULT false,
  read_at TIMESTAMP,
  company_id VARCHAR(255) REFERENCES companies(id),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Transport requests table
CREATE TABLE transport_requests (
  id VARCHAR(255) PRIMARY KEY,
  employee_id VARCHAR(255) REFERENCES employees(id),
  company_id VARCHAR(255) REFERENCES companies(id),
  type VARCHAR(50) NOT NULL CHECK (type IN ('newRequest', 'routeChange', 'stopChange', 'cancellation')),
  status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
  route_id VARCHAR(255) REFERENCES routes(id),
  stop_id VARCHAR(255) REFERENCES stops(id),
  effective_from TIMESTAMP,
  effective_to TIMESTAMP,
  reason TEXT,
  rejection_reason TEXT,
  approved_by VARCHAR(255) REFERENCES users(id),
  approved_at TIMESTAMP,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Audit logs table
CREATE TABLE audit_logs (
  id VARCHAR(255) PRIMARY KEY,
  user_id VARCHAR(255) REFERENCES users(id),
  action VARCHAR(100) NOT NULL,
  entity_type VARCHAR(100) NOT NULL,
  entity_id VARCHAR(255) NOT NULL,
  old_value JSONB,
  new_value JSONB,
  ip_address VARCHAR(50),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_company ON users(company_id);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_employees_company ON employees(company_id);
CREATE INDEX idx_employees_user ON employees(user_id);
CREATE INDEX idx_drivers_company ON drivers(company_id);
CREATE INDEX idx_drivers_user ON drivers(user_id);
CREATE INDEX idx_vehicles_company ON vehicles(company_id);
CREATE INDEX idx_vehicles_status ON vehicles(status);
CREATE INDEX idx_routes_company ON routes(company_id);
CREATE INDEX idx_trips_company ON trips(company_id);
CREATE INDEX idx_trips_driver ON trips(driver_id);
CREATE INDEX idx_trips_vehicle ON trips(vehicle_id);
CREATE INDEX idx_trips_status ON trips(status);
CREATE INDEX idx_trips_scheduled ON trips(scheduled_time);
CREATE INDEX idx_attendance_employee ON attendance(employee_id);
CREATE INDEX idx_attendance_date ON attendance(date);
CREATE INDEX idx_gps_logs_vehicle ON gps_logs(vehicle_id);
CREATE INDEX idx_gps_logs_timestamp ON gps_logs(timestamp);
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_incidents_company ON incidents(company_id);
CREATE INDEX idx_sos_alerts_company ON sos_alerts(company_id);
CREATE INDEX idx_sos_alerts_resolved ON sos_alerts(is_resolved);
