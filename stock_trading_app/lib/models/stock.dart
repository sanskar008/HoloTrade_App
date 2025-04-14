class Stock {
  final String id;
  final String name;
  double price;
  final double initialPrice;

  Stock({
    required this.id,
    required this.name,
    required this.price,
    required this.initialPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'initialPrice': initialPrice,
    };
  }

  factory Stock.fromMap(Map<String, dynamic> map) {
    return Stock(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      initialPrice: map['initialPrice'],
    );
  }
}
