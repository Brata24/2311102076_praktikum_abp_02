import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartCubit(),
      child: MaterialApp(
        title: 'Product Cart App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const ProductPage(),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  static const List<ProductItem> products = [
    ProductItem(id: 1, name: 'Laptop', price: 12000000),
    ProductItem(id: 2, name: 'Keyboard', price: 450000),
    ProductItem(id: 3, name: 'Mouse', price: 250000),
    ProductItem(id: 4, name: 'Monitor', price: 1800000),
    ProductItem(id: 5, name: 'Headset', price: 700000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(child: Text('Keranjang: ${state.itemCount}')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Pilih produk untuk ditambahkan ke keranjang',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('Rp ${product.price.toStringAsFixed(0)}'),
                    trailing: SizedBox(
                      width: 140,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                context.read<CartCubit>().addProduct(product),
                            icon: const Icon(Icons.add_shopping_cart),
                            tooltip: 'Tambah ke keranjang',
                          ),
                          IconButton(
                            onPressed: () => context
                                .read<CartCubit>()
                                .removeProduct(product.id),
                            icon: const Icon(Icons.remove_circle_outline),
                            tooltip: 'Hapus dari keranjang',
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.blue.shade50,
                child: Text(
                  state.cartItems.isEmpty
                      ? 'Keranjang masih kosong'
                      : 'Produk di keranjang: ${state.cartItems.map((e) => e.name).join(', ')}',
                  style: const TextStyle(fontSize: 15),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
