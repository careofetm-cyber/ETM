import '../config/database.dart';

class BillingService {
  static void processTripCompletion(String tripId) {
    final db = DatabaseConfig.db;
    final trip = db.findOne('trips', where: {'id': tripId});
    if (trip == null) return;

    final companyId = trip['company_id'] as String?;
    if (companyId == null) return;

    final company = db.findOne('companies', where: {'id': companyId});
    if (company == null) return;

    final totalDistance = (trip['total_distance'] as num?)?.toDouble() ?? 0.0;
    final minimumKm = (company['minimum_km_for_billing'] as num?)?.toDouble() ?? 0.0;
    final tripCost = (company['trip_cost_per_trip'] as num?)?.toDouble() ?? 0.0;
    final month = DateTime.now().toIso8601String().substring(0, 7);

    final isBillable = totalDistance >= minimumKm;
    final billingId = 'bill_${tripId}_${DateTime.now().millisecondsSinceEpoch}';

    db.insert('billing_records', {
      'id': billingId,
      'company_id': companyId,
      'trip_id': tripId,
      'month': month,
      'total_distance': totalDistance,
      'trip_cost': isBillable ? tripCost : 0.0,
      'is_billable': isBillable,
      'discard_reason': isBillable ? null : 'Distance $totalDistance km below minimum $minimumKm km',
      'needs_review': trip['total_distance'] == null,
      'created_at': DateTime.now().toIso8601String(),
    });

    if (isBillable) {
      final currentUsed = (company['trips_used_this_month'] as int?) ?? 0;
      db.update('companies', {
        'trips_used_this_month': currentUsed + 1,
      }, where: {'id': companyId});
    }
  }

  static void generateInvoice(String companyId, String month) {
    final db = DatabaseConfig.db;
    final records = db.findAll('billing_records', filters: {
      'company_id': companyId,
      'month': month,
      'is_billable': 'true',
    });

    final totalAmount = records.fold<double>(0.0, (sum, r) {
      return sum + ((r['trip_cost'] as num?)?.toDouble() ?? 0.0);
    });

    final invoiceId = 'inv_${companyId}_$month';
    final existing = db.findOne('invoices', where: {'id': invoiceId});

    if (existing != null) {
      db.update('invoices', {
        'total_amount': totalAmount,
        'trip_count': records.length,
        'updated_at': DateTime.now().toIso8601String(),
      }, where: {'id': invoiceId});
    } else {
      db.insert('invoices', {
        'id': invoiceId,
        'company_id': companyId,
        'month': month,
        'total_amount': totalAmount,
        'trip_count': records.length,
        'status': 'pending',
        'created_at': DateTime.now().toIso8601String(),
      });
    }
  }
}
