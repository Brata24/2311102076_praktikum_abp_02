import 'package:flutter_test/flutter_test.dart';
import 'package:product_cart_app/cart_cubit.dart';

void main() {
  group('CartCubit', () {
    late CartCubit cubit;

    setUp(() {
      cubit = CartCubit();
    });

    test('initial state has empty cart', () {
      expect(cubit.state.cartItems, isEmpty);
      expect(cubit.state.itemCount, 0);
    });

    test('addProduct adds item to cart', () {
      cubit.addProduct(ProductItem(id: 1, name: 'Laptop', price: 12000000));

      expect(cubit.state.cartItems.length, 1);
      expect(cubit.state.itemCount, 1);
    });

    test('removeProduct removes item from cart', () {
      cubit.addProduct(ProductItem(id: 1, name: 'Laptop', price: 12000000));
      cubit.removeProduct(1);

      expect(cubit.state.cartItems, isEmpty);
      expect(cubit.state.itemCount, 0);
    });
  });
}
