package com.cse135.group49.project;

import java.util.ArrayList;
import java.util.List;

public class Cart {
    private String user;
    private List<Product> products;
    
    public Cart (String user) {
        this.user = user;
        products = new ArrayList<Product>();
    }
    
    public String getUser() { return user; }
    
    public void addProduct(Product mProduct) {
        products.add(mProduct);
    }
    
    public List<Product> getProducts() {
        return products;
    }
    
    public void removeProduct(Product mProduct) {
        products.remove(mProduct);
    }
}
