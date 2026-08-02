import 'package:etm_core/etm_core.dart';
import '../api_client.dart';

class SuperAdminApi {
  final ApiClient _client;

  SuperAdminApi(this._client);

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _client.dio.get('/super-admin/dashboard');
    return response.data as Map<String, dynamic>;
  }

  Future<List<Company>> getCompanies({String? plan, String? status}) async {
    final response = await _client.dio.get('/super-admin/companies', queryParameters: {
      if (plan != null) 'plan': plan,
      if (status != null) 'status': status,
    });
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((c) => Company.fromJson(c as Map<String, dynamic>)).toList();
  }

  Future<Company> getCompany(String id) async {
    final response = await _client.dio.get('/super-admin/companies/$id');
    final data = response.data;
    final map = data is Map ? (data['data'] ?? data) : data;
    return Company.fromJson(map as Map<String, dynamic>);
  }

  Future<void> createCompany(Map<String, dynamic> data) async {
    await _client.dio.post('/super-admin/companies', data: data);
  }

  Future<void> updateCompany(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/super-admin/companies/$id', data: data);
  }

  Future<void> deleteCompany(String id) async {
    await _client.dio.delete('/super-admin/companies/$id');
  }

  Future<List<BillingRecord>> getBillingRecords({
    String? companyId,
    bool? billable,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _client.dio.get('/super-admin/billing', queryParameters: {
        if (companyId != null) 'companyId': companyId,
        if (billable != null) 'billable': billable,
        'page': page,
        'limit': limit,
      });
      final data = response.data;
      final map = data is Map ? data : {};
      final list = map['data'] ?? [];
      return (list as List).map((b) {
        try {
          return BillingRecord.fromJson(Map<String, dynamic>.from(b));
        } catch (_) {
          return null;
        }
      }).whereType<BillingRecord>().toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<CompanyBillingSummary>> getBillingSummary() async {
    try {
      final response = await _client.dio.get('/super-admin/billing/summary');
      final data = response.data;
      final map = data is Map ? data : {};
      final list = map['data'] ?? map['summaries'] ?? [];
      return (list as List).map((s) {
        try {
          return CompanyBillingSummary.fromJson(Map<String, dynamic>.from(s));
        } catch (_) {
          return null;
        }
      }).whereType<CompanyBillingSummary>().toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<Invoice>> getInvoices({
    String? companyId,
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.dio.get('/super-admin/invoices', queryParameters: {
      if (companyId != null) 'companyId': companyId,
      if (status != null) 'status': status,
      'page': page,
      'limit': limit,
    });
    final data = response.data;
    final list = data is Map ? data['data'] ?? [] : data;
    return (list as List).map((i) => Invoice.fromJson(i as Map<String, dynamic>)).toList();
  }

  Future<Invoice> updateInvoice(String id, Map<String, dynamic> data) async {
    await _client.dio.put('/super-admin/invoices/$id', data: data);
    final updated = await _client.dio.get('/super-admin/invoices');
    final invoicesData = updated.data;
    final invoicesList = invoicesData is Map ? invoicesData['data'] ?? [] : invoicesData;
    final match = (invoicesList as List).where((i) => i['id'] == id).toList();
    if (match.isNotEmpty) {
      return Invoice.fromJson(match.first as Map<String, dynamic>);
    }
    throw Exception('Invoice not found after update');
  }
}
