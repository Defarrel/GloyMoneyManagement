import 'package:flutter/material.dart';
import 'package:gloymoneymanagement/core/components/custom_app_bar.dart';
import 'package:gloymoneymanagement/core/components/custom_text_field_2.dart';
import 'package:gloymoneymanagement/core/constants/colors.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/done_page.dart';
import 'package:gloymoneymanagement/presentation/user/transaksi/pages/map_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:gloymoneymanagement/data/models/request/transaksi/transaction_request_model.dart';
import 'package:gloymoneymanagement/data/repository/transaksi_repository.dart';
import 'package:gloymoneymanagement/services/service_http_client.dart';

class TambahTransaksi extends StatefulWidget {
  const TambahTransaksi({super.key});

  @override
  State<TambahTransaksi> createState() => _TambahTransaksiState();
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  final _formKey = GlobalKey<FormState>();
  final _repository = TransactionRepository(ServiceHttpClient());

  String _type = 'pemasukan';
  String? _category;
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  final List<String> pemasukanCategories = [
    'Gaji',
    'Bonus',
    'Penjualan',
    'Investasi',
    'Lainnya',
  ];
  final List<String> pengeluaranCategories = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Tagihan',
    'Lainnya',
  ];

  List<String> get currentCategories {
    return _type == 'pemasukan' ? pemasukanCategories : pengeluaranCategories;
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _dateController.text = DateFormat(
      'EEEE, dd MMMM yyyy',
      'id_ID',
    ).format(_selectedDate);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('id', 'ID'),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat(
          'EEEE, dd MMMM yyyy',
          'id_ID',
        ).format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final amount = double.tryParse(
        _amountController.text.replaceAll(',', ''),
      );
      if (amount == null) return;

      final model = TransactionRequestModel(
        type: _type,
        category: _category,
        amount: amount,
        description: _descController.text,
        location: _locationController.text,
        date: _selectedDate,
      );

      final result = await _repository.addTransaction(model);
      result.fold(
        (error) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error))),
        (success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const DonePage()),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Tambah Transaksi", showLogo: false),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ToggleButtons(
                isSelected: [_type == 'pemasukan', _type == 'pengeluaran'],
                onPressed: (index) {
                  setState(() {
                    _type = index == 0 ? 'pemasukan' : 'pengeluaran';
                    _category = null;
                  });
                },
                borderRadius: BorderRadius.circular(10),
                selectedColor: Colors.white,
                fillColor: _type == 'pemasukan'
                    ? AppColors.primary
                    : Colors.red,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pemasukan'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Pengeluaran'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField2(
                controller: _amountController,
                label: 'Jumlah',
                keyboardType: TextInputType.number,
                validator: 'Jumlah wajib diisi',
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Colors.green,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                hint: const Text(
                  'Pilih Kategori',
                  style: TextStyle(fontSize: 14),
                ),
                items: currentCategories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) => setState(() => _category = value),
                validator: (value) =>
                    value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              CustomTextField2(
                controller: _descController,
                label: 'Deskripsi (opsional)',
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: () async {
                  final selectedAddress = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MapPage()),
                  );
                  if (selectedAddress != null && selectedAddress is String) {
                    setState(() {
                      _locationController.text = selectedAddress;
                    });
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField2(
                    controller: _locationController,
                    label: 'Lokasi (opsional)',
                    suffixIcon: const Icon(Icons.map),
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: CustomTextField2(
                    controller: _dateController,
                    label: 'Tanggal',
                    validator: 'Tanggal wajib dipilih',
                    suffixIcon: const Icon(Icons.calendar_today),
                    readOnly: true,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Simpan',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
