import 'package:flutter/material.dart';

import '../../models/app_store.dart';
import '../../models/order.dart';
import '../../theme/app_colors.dart';

/// Orders split into two tabs with TabBar + TabBarView.
class OrdersTab extends StatelessWidget {
  const OrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppStore();
    final active = store.activeOrders;
    final past = store.pastOrders;

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.primary,
              labelStyle: const TextStyle(fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'Active (${active.length})'),
                Tab(text: 'Past (${past.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _OrderList(
                  orders: active,
                  emptyText: 'No active orders.\nPlace one from your cart!',
                ),
                _OrderList(
                  orders: past,
                  emptyText: 'Delivered orders will show up here.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<Order> orders;
  final String emptyText;

  const _OrderList({required this.orders, required this.emptyText});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧾', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
      children: [for (final order in orders) _OrderCard(order: order)],
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.onTheWay:
        return Colors.blue;
      case OrderStatus.delivered:
        return AppColors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemNames = order.lines
        .map((line) => '${line.quantity}x ${line.item.name}')
        .join(', ');

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Order ${order.id}',
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusLabel(order.status),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            order.placedAtLabel,
            style: const TextStyle(fontSize: 12, color: AppColors.grey),
          ),
          const SizedBox(height: 10),
          Text(itemNames, style: const TextStyle(height: 1.4)),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: AppColors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  order.address,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: AppColors.grey),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              Text(
                '${order.itemCount} items  •  Rs. ${order.total.toStringAsFixed(0)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              if (order.isActive)
                TextButton(
                  // Simulates the order moving along (no real tracking yet)
                  onPressed: () => AppStore().advanceOrder(order),
                  child: Text(
                    order.status == OrderStatus.preparing
                        ? 'Mark on the way'
                        : 'Mark delivered',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
