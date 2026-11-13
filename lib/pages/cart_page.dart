import 'package:flutter/material.dart';

import '../models/app_store.dart';
import '../models/cart.dart';
import '../routes.dart';
import '../theme/app_colors.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AppStore _store = AppStore();
  Cart get cart => _store.cart;

  /// Opens the address page and waits for the address it sends back.
  Future<void> _changeAddress() async {
    final picked = await Navigator.of(context).pushNamed(AppRoutes.address);
    if (picked is String) {
      setState(() => _store.setDeliveryAddress(picked));
    }
  }

  Future<void> _placeOrder() async {
    final order = _store.placeOrder();
    await showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Order placed! 🎉'),
        content: Text(
          'Order ${order.id} of Rs. ${order.total.toStringAsFixed(0)} is being prepared.\n'
          'Estimated delivery: 30-40 min.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Track order'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    // Send `true` back so Home switches to the Orders tab
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        centerTitle: true,
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => setState(() => _store.clearCart()),
              child: const Text('Clear', style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          // Cross-fade between the empty state and the cart contents
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            crossFadeState:
                cart.isEmpty ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildEmptyState(),
            secondChild: _buildCartContents(),
          ),
        ),
      ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  child: Text(
                    'Place order  •  Rs. ${cart.total.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 80),
          const Text('🛒', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add something tasty from the menu.',
            style: TextStyle(color: AppColors.grey),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.restaurant_menu),
            label: const Text('Browse menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContents() {
    return Column(
      children: [
        for (final line in cart.lines) _buildCartLine(line),
        const SizedBox(height: 12),
        // Delivery address (tap to pick another one)
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFEDEDED)),
          ),
          child: ListTile(
            leading: const Icon(Icons.location_on, color: AppColors.primary),
            title: const Text('Deliver to', style: TextStyle(fontSize: 12, color: AppColors.grey)),
            subtitle: Text(
              _store.deliveryAddress,
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.dark),
            ),
            trailing: TextButton(onPressed: _changeAddress, child: const Text('Change')),
          ),
        ),
        // Bill summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              _summaryRow('Subtotal', 'Rs. ${cart.subtotal.toStringAsFixed(0)}'),
              _summaryRow(
                'Delivery',
                cart.delivery == 0 ? 'FREE' : 'Rs. ${cart.delivery.toStringAsFixed(0)}',
              ),
              if (cart.delivery > 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Add Rs. ${(Cart.freeDeliveryAbove - cart.subtotal).toStringAsFixed(0)} more for free delivery',
                    style: const TextStyle(fontSize: 12, color: AppColors.green),
                  ),
                ),
              const Divider(),
              _summaryRow('Total', 'Rs. ${cart.total.toStringAsFixed(0)}', bold: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartLine(CartLine line) {
    final item = line.item;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(item.emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rs. ${line.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => setState(() => _store.decreaseInCart(item)),
            icon: Icon(
              line.quantity == 1 ? Icons.delete_outline : Icons.remove_circle_outline,
              color: line.quantity == 1 ? Colors.red : AppColors.dark,
            ),
          ),
          Text(
            '${line.quantity}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          IconButton(
            onPressed: () => setState(() => _store.addToCart(item)),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
