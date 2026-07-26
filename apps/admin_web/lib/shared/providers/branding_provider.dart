import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class CompanyBranding {
  final String? name;
  final String? logoUrl;
  final String? faviconUrl;
  final String? primaryColor;
  final String? backgroundColor;

  const CompanyBranding({
    this.name,
    this.logoUrl,
    this.faviconUrl,
    this.primaryColor,
    this.backgroundColor,
  });

  Color? get primaryColorValue {
    if (primaryColor == null || primaryColor!.isEmpty) return null;
    try {
      final hex = primaryColor!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  Color? get backgroundColorValue {
    if (backgroundColor == null || backgroundColor!.isEmpty) return null;
    try {
      final hex = backgroundColor!.replaceFirst('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return null;
    }
  }

  bool get hasBranding => name != null || logoUrl != null || primaryColor != null;
}

class BrandingNotifier extends StateNotifier<CompanyBranding> {
  final Ref ref;

  BrandingNotifier(this.ref) : super(const CompanyBranding());

  Future<void> loadBranding(String slug) async {
    try {
      final dio = Dio(BaseOptions(
        baseUrl: 'http://localhost:8080/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      final response = await dio.get('/company/$slug');
      final data = response.data as Map<String, dynamic>;
      state = CompanyBranding(
        name: data['name'] as String?,
        logoUrl: data['logo'] as String?,
        faviconUrl: data['favicon'] as String?,
        primaryColor: data['primaryColor'] as String?,
        backgroundColor: data['backgroundColor'] as String?,
      );
    } catch (_) {
      state = const CompanyBranding();
    }
  }

  void reset() {
    state = const CompanyBranding();
  }
}

final brandingProvider = StateNotifierProvider<BrandingNotifier, CompanyBranding>((ref) {
  return BrandingNotifier(ref);
});
