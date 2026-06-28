import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductItem extends Equatable {
  const ProductItem({
    required this.id,
    required this.name,
    required this.price,
  });

  final int id;
  final String name;
  final double price;

  @override
  List<Object?> get props => [id, name, price];
}

class CartState extends Equatable {
  const CartState({this.cartItems = const <ProductItem>[]});

  final List<ProductItem> cartItems;

  int get itemCount => cartItems.length;

  @override
  List<Object?> get props => [cartItems];
}

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addProduct(ProductItem product) {
    final updatedItems = List<ProductItem>.from(state.cartItems)..add(product);
    emit(CartState(cartItems: updatedItems));
  }

  void removeProduct(int productId) {
    final updatedItems = state.cartItems
        .where((item) => item.id != productId)
        .toList();
    emit(CartState(cartItems: updatedItems));
  }
}
