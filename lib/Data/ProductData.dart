import '/constant/Constants.dart';
import '/model/Product.dart';
import '/model/ProductInCart.dart';

//INFO: Demo product images

 var mixProducts = [
  Product(
      'demo_image.png', 'Nike Sports Shoe for Men', false, 5.0, 29, 9, false),
  Product('demo_image.png', 'High heels Sandal', true, 4.1, 12, 2, true),
  Product('demo_image.png', 'Stereo Headset Black', false, 3.5, 6, 0, false),
  Product('demo_image.png', 'Flora Aloe vera with bucket ', false, 4.0, 4, 0,
      false),
  Product('demo_image.png', 'iPhone 11 Pro', false, 4.5, 499, 20, false),
  Product('demo_image.png', 'Sports Shoe', false, 5.0, 9, 3, false),
  Product('demo_image.png', 'Nikon Combo pack', false, 3.5, 20, 10, false),
  Product('demo_image.png', 'Coke Beverages', false, 5.0, 2, 0, false),
  Product(
      'demo_image_vertical.png', 'Gaming Unlimited', false, 4.0, 14, 4, false),
  Product(
      'demo_image_vertical.png', 'iPad Pro Pencil', false, 5.0, 29, 8, false),
];

var newInFashion = [
  Product(
      'demo_image.png', 'Nike Sports Shoe for Men', true, 5.0, 20, 30, false),
  Product('demo_image.png', 'Alabama\'s pure cotton Shirt', false, 3.5, 20, 30,
      false),
  Product(
      'demo_image_vertical.png', 'Home decoration', false, 4.1, 20, 30, true),
];

var bestInElectronicsData = [
  Product('demo_image.png', 'Nikon Combo pack', true, 3.5, 39, 0, false),
  Product('demo_image.png', 'Gaming Console', false, 4.0, 14, 4, false),
  Product('demo_image.png', 'iPhone 11 Pro', false, 4.5, 499, 20, false),
];

var stayHealthyData = [
  Product('demo_image.png', 'Protein Shake 5 Ltr', true, 5.0, 5.9, 0, true),
  Product('demo_image.png', '12 Piece of Healthy Fruits', false, 4.5, 4.0, 0.6,
      false),
  Product('demo_image.png', 'Fresh Honey', false, 4.1, 26.30, 15, false),
  Product('demo_image.png', 'Strawberry (5kg)', false, 4.1, 2.9, 6, false),
];

var makupProductsData = [
  Product(
      'demo_image.png', 'Pink and brown lipsticks', true, 5.0, 4.9, 2, false),
  Product('demo_image.png', 'Set of Eyeliners', false, 4.5, 2, 0, false),
  Product(
      'demo_image.png', 'Beauty Essential for girls', false, 4.1, 2, 1, false),
];

var lowPriceProductList = [
  Product('demo_image.png', 'New Arrivals for Men', true, 5.0, 8.99, 5, false),
  Product('demo_image.png', 'Alabama\'s pure cotton Shirts', false, 3.5, 5, 5,
      false),
  Product('demo_image_vertical.png', 'Wrist Watch for men', false, 4.1, 9, 4,
      false),
];

var myCartData = [
  ProductInCart(stayHealthyData[0], 2),
  ProductInCart(newInFashion[2], 1),
  ProductInCart(mixProducts[1], 1),
];

var shopForMen = [
  Product('demo_image_vertical.png', 'Branded multi-colored Shirt', false, 4.1,
      4.99, 20, false),
  Product('demo_image_vertical.png', 'Elsinore\'s pant shirt for young boy',
      false, 4.1, 8.99, 20, false),
];

var shopForWomen = [
  Product('demo_image_vertical.png', 'Golden kurta dress', false, 4.5, 8.99, 22,
      false),
  Product('demo_image_vertical.png', 'Pink and Sky-blue dress', false, 4.1,
      6.99, 22, false),
];

var similarProductData = [
  Product('demo_image.png', 'Josephs cool spec', true, 5.0, 4, 0, false),
  Product('demo_image.png', 'Fragrance Spray', false, 4.5, 12.99, 12, false),
  Product('demo_image.png', 'High heels Sandal', false, 4.1, 6, 0, false),
  Product(
      'demo_image.png', 'Odyssey\'s DLSR Camera', false, 4.1, 79.99, 12, false),
  Product('demo_image.png', 'Wrist Watch for men', false, 4.1, 9, 0, false),
  Product('demo_image.png', 'Set of Eyeliners', false, 4.5, 3, 0, false),
];



var myTicketProducts = [
  Product('demo_image.png', 'iPhone 11 Pro', false, 5.0, 499, 20, false),
  Product('demo_image.png', 'Flora Aloe vera with bucket ', false, 5.0, 2, 0,
      false),
  Product('demo_image.png', 'Josephs cool spec', true, 5.0, 4, 0, false),
];

var myPastOrderHistory = [
  Product('demo_image.png', 'Red Klarket for Storyteller', false, 5.0, 8.9, 30,
      false),
  Product(
      'demo_image_vertical.png', 'Gaming Console', false, 5.0, 15, 10, false),
];

var myOngoingOrderHistory = [
  Product(
      'demo_image.png', 'Android Smart Watch', false, 5.0, 55.99, 30, false),
];

/* Category Data */

var fashionCategory = [
  Product('demo_image.png', 'Josephs cool spec', true, 5.0, 4, 0, false),
  Product(
      'demo_image.png', 'Nike Sports Shoe for Men', false, 5.0, 29, 9, false),
  Product('demo_image.png', 'Wrist Watch for men', false, 4.1, 9, 4, false),
  Product('demo_image.png', 'Branded multi-colored Shirt', false, 4.1, 4.99, 20,
      false),
  Product('demo_image.png', 'Golden kurta dress', false, 4.5, 8.99, 22, false),
  Product('demo_image.png', 'High heels Sandal', true, 4.1, 12, 2, false),
  Product('demo_image.png', 'Sports Shoe', false, 5.0, 9, 3, false),
  Product('demo_image.png', 'Alabama\'s pure cotton Shirt', false, 3.5, 20, 30,
      false),
];

var electronicsCategory = [
  Product('demo_image.png', 'iPhone 11 Pro', false, 4.5, 499, 20, false),
  Product('demo_image.png', 'Nikon Combo pack', false, 3.5, 20, 10, false),
  Product('demo_image.png', 'Stereo Headset Black', false, 3.5, 6, 0, false),
  Product(
      'demo_image.png', 'Android Smart Watch', false, 5.0, 55.99, 30, false),
  Product(
      'demo_image_vertical.png', 'Gaming Unlimited', false, 4.0, 14, 4, false),
  Product(
      'demo_image_vertical.png', 'iPad Pro Pencil', false, 5.0, 29, 8, false),
  Product(
      'demo_image.png', 'Odyssey\'s DLSR Camera', false, 4.1, 79.99, 12, false),
];

var mobileCategory = [
  Product('demo_image.png', 'iPhone 11 Pro', false, 4.5, 499, 20, false),
  Product(
      'demo_image.png', 'Samsung Galaxy S6 Edge', false, 4.5, 349, 20, false),
  Product('demo_image.png', 'Google Pixel 5 - 5G', false, 4.5, 399, 20, false),
];

var groceryCategory = [
  Product('demo_image.png', 'Protein Shake 5 Ltr', true, 5.0, 5.9, 0, false),
  Product('demo_image.png', '12 Piece of Healthy Fruits', false, 4.5, 4.0, 0.6,
      false),
  Product('demo_image.png', 'Fresh Honey', false, 4.1, 26.30, 15, false),
  Product('demo_image.png', 'Strawberry (5kg)', false, 4.1, 2.9, 6, false),
];

var applianceCategory = [
  Product(
      'demo_image.png', 'Automatic Washing Machine', true, 4.5, 499, 20, false),
  Product('demo_image.png', '4 Slice Toaster Bread Electric Four Wide Slots',
      true, 3, 499, 20, false),
  Product(
      'demo_image.png',
      'Free Standing Air Conditioner Ventless Freestanding',
      true,
      5,
      499,
      20,
      false),
];

var booksCategory = [
  Product('demo_image.png', 'Inspired - How to create tech products', true, 4.5,
      56, 20, false),
  Product(
      'demo_image.png', 'Product Growth by Wes Bush', true, 3, 39, 20, false),
  Product('demo_image.png', 'India A Wounded Civilization by V.S.Naipoul', true,
      5, 15, 20, false),
  Product('demo_image.png', 'The Lean Product.png', false, 4.5, 30, 20, true),
  Product('demo_image.png', 'Mahatma Gandhi Autobiography', false, 4.5, 9, 20,
      false),
  Product('demo_image.png', 'An Area Of Darkness', false, 4.5, 14, 20, false),
];

List<Product> getCategoryProducts(int categoryIndex) {
  switch (categoryIndex) {
    case 0:
      return fashionCategory;
    case 1:
      return electronicsCategory;
    case 2:
      return mobileCategory;
    case 3:
      return groceryCategory;
    case 4:
      return applianceCategory;
    case 5:
      return booksCategory;
  }
  return fashionCategory;
}

var productDetails = [
  {'key': brandLabel, 'value': 'ABC brand let say this is long let say this is long let say this is long'},
  {'key': typeLabel, 'value': 'Mobile & Accessories'},
  {'key': weightLabel, 'value': '382 gram'},
  {'key': osLabel, 'value': 'Android 11'},
  {'key': colorLabel, 'value': 'Fluid black'},
  {'key': storageLabel, 'value': '256 GB'},
  {'key': ramLabel, 'value': '8 GB'},
  {'key': warrantyLabel, 'value': '12 month domestic warranty '},
];


var myTicketProductsOdoo = [
  Product('demo_image.png', 'iPhone 11 Pro', false, 5.0, 499, 20, false),
  Product('demo_image.png', 'Flora Aloe vera with bucket ', false, 5.0, 2, 0,
      false),
  Product('demo_image.png', 'Josephs cool spec', true, 5.0, 4, 0, false),
];



