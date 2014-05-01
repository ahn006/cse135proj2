package com.cse135.group49.project;

public class Product {
    private Integer product;
    private Integer quantity;
    private Integer price;
    
    public Product(Integer product, Integer quantity, Integer price) {
        this.product = product;
        this.price = price;
        this.quantity = quantity;
    }
    
    public Integer getProduct() { return product; }
    public Integer getPrice() { return price; }
    public Integer getQuantity() { return quantity; } 
    
    public void changePrice(Integer mPrice) {
        this.price = mPrice;
    }
}
