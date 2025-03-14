import 'dart:io';

class Product {
  String name;
  int price;

  Product(this.name, this.price);
}

class ShoppingMall {
  List<Product> products = [
    Product('셔츠', 45000),
    Product('원피스', 30000),
    Product('반팔티', 35000),
    Product('반바지', 38000),
    Product('양말', 5000),
  ];

  int totalPrice = 0;
  Map<String, int> cart = {};

  void showProducts() {
    print('\n상품 목록:');
    for (var product in products) {
      print('${product.name} / ${product.price}원');
    }
  }

  void addToCart() {
    stdout.write('\n상품 이름을 입력해 주세요: ');
    String? productName = stdin.readLineSync()?.trim();
    if (productName == null || productName.isEmpty ||
        !products.any((p) => p.name == productName)) {
      print('입력값이 올바르지 않아요!');
      return;
    }

    stdout.write('상품 개수를 입력해 주세요: ');
    String? quantityInput = stdin.readLineSync()?.trim();
    int? quantity = int.tryParse(quantityInput ?? '');
    if (quantity == null || quantity <= 0) {
      print('0개보다 많은 개수의 상품만 담을 수 있어요!');
      return;
    }

    var product = products.firstWhere((p) => p.name == productName);
    totalPrice += product.price * quantity;
    cart[productName] = (cart[productName] ?? 0) + quantity;
    print('장바구니에 상품이 담겼어요!');
  }

  void showTotal() {
    print('\n장바구니에 $totalPrice원 어치를 담으셨네요!');
  }

  void showCart() {
    print('\n장바구니 목록:');
    if (cart.isEmpty) {
      print('장바구니가 비어 있습니다.');
    } else {
      cart.forEach((name, quantity) {
        var price = products.firstWhere((p) => p.name == name).price;
        print('$name x $quantity = ${price * quantity}원');
      });
    }
  }

  void clearCart() {
    cart.clear();
    totalPrice = 0;
    print('장바구니가 초기화되었습니다.');
  }
}

void main() {
  ShoppingMall mall = ShoppingMall();
  bool running = true;

  while (running) {
    print('\n[1] 상품 목록 보기 / [2] 장바구니에 담기 / [3] 장바구니 총 가격 보기 / [4] 장바구니 보기 / [5] 장바구니 초기화 / [6] 프로그램 종료');
    stdout.write('선택: ');
    String? choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        mall.showProducts();
        break;
      case '2':
        mall.addToCart();
        break;
      case '3':
        mall.showTotal();
        break;
      case '4':
        mall.showCart();
        break;
      case '5':
        mall.clearCart();
        break;
      case '6':
        print('이용해 주셔서 감사합니다 ~ 안녕히 가세요!');
        running = false;
        break;
      default:
        print('지원하지 않는 기능입니다! 다시 시도해 주세요..');
    }
  }
}
