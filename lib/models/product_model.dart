class Product {
  final int id;
  final String name;
  final int price;
  final int stock; // 1. Tambahkan ini
  final String? imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock, // 2. Masukkan ke constructor
    this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      // KUNCINYA DI SINI: Harus 'nama_product' sesuai isi JSON kamu
      name: json['nama_product'] ?? 'No Name',
      price: json['price'] is int
          ? json['price']
          : int.parse(json['price'].toString()),
      stock: json['stock'] ?? 0,
      imageUrl: json['image_url'], // Ini juga pastikan snake_case
    );
  }
}
