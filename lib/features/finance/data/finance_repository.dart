import 'package:platform_core_frontend/features/finance/data/finance_api.dart';
import 'package:platform_core_frontend/features/finance/data/models/collection_entry_model.dart';
import 'package:platform_core_frontend/features/finance/data/models/create_collection_request.dart';
import 'package:platform_core_frontend/features/finance/data/models/create_expense_request.dart';
import 'package:platform_core_frontend/features/finance/data/models/expense_entry_model.dart';
import 'package:platform_core_frontend/features/finance/data/models/finance_summary_model.dart';

class FinanceRepository {
  FinanceRepository({FinanceApi? financeApi})
      : _financeApi = financeApi ?? FinanceApi();

  final FinanceApi _financeApi;

  Future<FinanceSummaryModel> getFinanceSummary() {
    return _financeApi.getFinanceSummary();
  }

  Future<List<CollectionEntryModel>> getCollections() {
    return _financeApi.getCollections();
  }

  Future<void> createCollection(CreateCollectionRequest request) {
    return _financeApi.createCollection(request);
  }

  Future<List<ExpenseEntryModel>> getExpenses() {
    return _financeApi.getExpenses();
  }

  Future<void> createExpense(CreateExpenseRequest request) {
    return _financeApi.createExpense(request);
  }
}
