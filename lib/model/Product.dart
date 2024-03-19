class Product{
  
   String productImage;
   String productName;
  bool   isFavourite;
   double rating;
   double originalPrice;
   double discountPercent;
   bool   isAddedInCart;

  Product(this.productImage, this.productName, this.isFavourite, this.rating, this.originalPrice, this.discountPercent, this.isAddedInCart);
}