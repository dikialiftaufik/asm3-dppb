// Menu Item Model
class MenuItem {
  final String id;
  final String name;
  final String category; // 'Sate' atau 'Tongseng'
  final String meat; // 'Ayam', 'Sapi', 'Kambing'
  final double price;
  final String description;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.category,
    required this.meat,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'].toString(),
      name: json['name'],
      category: json['category'] ?? '',
      meat: json['meat'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

// Cart Item Model
class CartItem {
  final MenuItem menuItem;
  int quantity;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      menuItem: MenuItem.fromJson(json['menu_item']),
      quantity: json['quantity'],
    );
  }
}

// Order Model
class Order {
  final String id;
  final List<CartItem> items;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final String deliveryAddress;
  final String paymentMethod; // 'transfer', 'qris'
  final double totalPrice;
  final DateTime orderDate;
  final DateTime? completedDate;

  Order({
    required this.id,
    required this.items,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.totalPrice,
    required this.orderDate,
    this.completedDate,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List;
    List<CartItem> items = itemsList.map((i) => CartItem.fromJson(i)).toList();

    return Order(
      id: json['id'].toString(),
      items: items,
      status: json['status'],
      deliveryAddress: json['delivery_address'] ?? '',
      paymentMethod: json['payment_method'] ?? 'transfer',
      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,
      orderDate: DateTime.parse(json['created_at']),
      completedDate: json['completed_at'] != null ? DateTime.parse(json['completed_at']) : null,
    );
  }
}
