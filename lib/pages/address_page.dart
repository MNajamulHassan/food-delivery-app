import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../theme/app_colors.dart';

/// Lets the user pick a delivery address.
/// Sends the chosen address back with Navigator.pop(context, address).
class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final AppStore _store = AppStore();
  final _newAddressController = TextEditingController();

  @override
  void dispose() {
    _newAddressController.dispose();
    super.dispose();
  }

  void _choose(String address) {
    Navigator.of(context).pop(address); // return data to the previous page
  }

  void _addNew() {
    final text = _newAddressController.text.trim();
    if (text.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a full address')),
      );
      return;
    }
    _choose(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery address'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Saved addresses',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          for (final address in _store.savedAddresses)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: address == _store.deliveryAddress
                      ? AppColors.primary
                      : const Color(0xFFEDEDED),
                  width: address == _store.deliveryAddress ? 1.5 : 1,
                ),
              ),
              child: ListTile(
                leading: const Icon(Icons.home_outlined, color: AppColors.primary),
                title: Text(address),
                trailing: address == _store.deliveryAddress
                    ? const Icon(Icons.check_circle, color: AppColors.primary)
                    : null,
                onTap: () => _choose(address),
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Add a new address',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _newAddressController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'House, street, area, city',
              prefixIcon: Icon(Icons.edit_location_alt_outlined),
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: _addNew,
            child: const Text('Use this address'),
          ),
        ],
      ),
    );
  }
}
