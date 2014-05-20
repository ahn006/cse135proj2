package com.cse135.group49.project;

public class Product {
	private String name;
	private String product;
    private Integer quantity;
    private Double price;
    
    
    public Product(String name, String product, Integer quantity, Double price) {
    	this.name = name;
    	this.product = product;
        this.price = price;
        this.quantity = quantity;
    }
    public String getName() {return name;}
    public String getProduct() { return product; }
    public Double getPrice() { return price; }
    public Integer getQuantity() { return quantity; } 
    
    public void changePrice(Double mPrice) {
        this.price = mPrice;
    }
}
