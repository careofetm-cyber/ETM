import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:etm_maps/etm_maps.dart';
import '../../providers.dart';

class LocationPickerResult {
  final double latitude;
  final double longitude;
  final String address;
  final double? accuracyMeters;

  const LocationPickerResult({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.accuracyMeters,
  });
}

class LocationPickerScreen extends ConsumerStatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final String? initialAddress;

  const LocationPickerScreen({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    this.initialAddress,
  });

  @override
  ConsumerState<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends ConsumerState<LocationPickerScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  LatLng? _selectedLocation;
  String _selectedAddress = '';
  double? _accuracyMeters;
  bool _isLoadingLocation = false;
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _selectedLocation = LatLng(widget.initialLatitude!, widget.initialLongitude!);
      _selectedAddress = widget.initialAddress ?? '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _error = null;
    });
    try {
      final position = await _locationService.getCurrentLocation();
      final latLng = LatLng(position.latitude, position.longitude);
      final address = await _locationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = latLng;
        _selectedAddress = address;
        _accuracyMeters = position.accuracy;
        _isLoadingLocation = false;
      });
      _mapController.move(latLng, 15);
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
        _error = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> _searchAddress(String query) async {
    if (query.trim().length < 3) {
      setState(() => _searchResults = []);
      return;
    }
    setState(() => _isSearching = true);
    try {
      final results = await _locationService.searchAddress(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (e) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    }
  }

  void _selectSearchResult(Map<String, dynamic> result) {
    final latLng = LatLng(result['latitude'], result['longitude']);
    setState(() {
      _selectedLocation = latLng;
      _selectedAddress = result['address'];
      _searchController.text = result['address'];
      _searchResults = [];
      _accuracyMeters = null;
      _searchFocusNode.unfocus();
    });
    _mapController.move(latLng, 15);
  }

  void _onMapTap(TapPosition tapPosition, LatLng latLng) async {
    final address = await _locationService.getAddressFromLatLng(
      latLng.latitude,
      latLng.longitude,
    );
    setState(() {
      _selectedLocation = latLng;
      _selectedAddress = address;
      _searchController.text = address;
      _accuracyMeters = null;
    });
  }

  void _save() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a location first')),
      );
      return;
    }
    Navigator.pop(
      context,
      LocationPickerResult(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
        address: _selectedAddress,
        accuracyMeters: _accuracyMeters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final initialPos = _selectedLocation ?? const LatLng(19.0760, 72.8777);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Home Location'),
        actions: [
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialPos,
              initialZoom: _selectedLocation != null ? 15 : 11,
              onTap: _onMapTap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.etm.employee',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_pin,
                        size: 40,
                        color: cs.primary,
                      ),
                    ),
                  ],
                ),
              // Accuracy circle
              if (_selectedLocation != null && _accuracyMeters != null)
                CircleLayer(
                  circles: [
                    CircleMarker(
                      point: _selectedLocation!,
                      radius: _accuracyMeters!,
                      useRadiusInMeter: true,
                      color: cs.primary.withOpacity(0.15),
                      borderColor: cs.primary.withOpacity(0.4),
                      borderStrokeWidth: 1,
                    ),
                  ],
                ),
            ],
          ),

          // Search bar
          Positioned(
            top: 8,
            left: 12,
            right: 12,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'Search address...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isSearching
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchResults = []);
                                  },
                                )
                              : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    ),
                    onChanged: _searchAddress,
                  ),
                ),
                if (_searchResults.isNotEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 250),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _searchResults.length,
                        itemBuilder: (ctx, i) {
                          final result = _searchResults[i];
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.location_on, size: 20),
                            title: Text(
                              result['address'],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            onTap: () => _selectSearchResult(result),
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Right side buttons
          Positioned(
            right: 12,
            bottom: 24,
            child: Column(
              children: [
                // Accuracy indicator
                if (_accuracyMeters != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 6)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _accuracyMeters! < 20 ? Icons.gps_fixed : Icons.gps_not_fixed,
                          size: 16,
                          color: _accuracyMeters! < 20 ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_accuracyMeters!.toStringAsFixed(0)}m accuracy',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _accuracyMeters! < 20 ? Colors.green.shade700 : Colors.orange.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Refresh button
                if (_selectedLocation != null)
                  _buildMapButton(
                    icon: Icons.refresh,
                    onTap: _getCurrentLocation,
                  ),
                const SizedBox(height: 8),
                // Current location button
                _buildMapButton(
                  icon: Icons.my_location,
                  onTap: _getCurrentLocation,
                  isLoading: _isLoadingLocation,
                ),
              ],
            ),
          ),

          // Error banner
          if (_error != null)
            Positioned(
              top: 8,
              left: 12,
              right: 12,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: cs.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: cs.onErrorContainer, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _error!,
                          style: TextStyle(color: cs.onErrorContainer, fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: cs.onErrorContainer, size: 18),
                        onPressed: () => setState(() => _error = null),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Loading overlay
          if (_isLoadingLocation)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text('Getting location...', style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              ),
            ),

          // Selected location info
          if (_selectedLocation != null && !_isLoadingLocation)
            Positioned(
              left: 12,
              bottom: 24,
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: cs.primary, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _selectedAddress.isNotEmpty ? _selectedAddress : 'Tap map to select',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                        style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMapButton({
    required IconData icon,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Icon(icon, size: 22, color: Colors.grey.shade700),
        ),
      ),
    );
  }
}
