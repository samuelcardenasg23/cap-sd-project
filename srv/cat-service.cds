using sap.capire.theshire as theshire from '../db/schema';

service CatalogService {
    entity Products   as projection on theshire.Products;
    entity Orders     as projection on theshire.Orders;
    entity Customers  as projection on theshire.Customers;
    entity OrderItems as projection on theshire.OrderItems;
    entity Deliveries as projection on theshire.Deliveries;
    entity Invoices   as projection on theshire.Invoices;
}
