using {
    managed,
    cuid
} from '@sap/cds/common';

namespace sap.capire.theshire;

// Enums for status management
type Status : String enum {
    NEW;
    IN_PROCESS;
    SHIPPED;
    ISSUED;
    PAID;
}

// Product entity
entity Products : managed {
    key ID             : String;
        name           : String;
        unitOfMeasure  : String default 'Pallet';
        boxesPerPallet : Integer default 30;
        stemsPerBox    : Integer default 10;
        pricePerPallet : Decimal(10, 2);
        stockQuantity  : Integer;
}

// Order and related entities
entity Orders : managed {
    key orderNumber : String;
        orderDate   : Date;
        status      : Status default 'NEW';
        totalAmount : Decimal(10, 2);
        customer    : Composition of one Customers;
        items       : Composition of many OrderItems
                          on items.order = $self;
}

// Customer basic info
entity Customers : managed {
    key ID      : String;
        name    : String;
        contact : String;
}

// Order Items
entity OrderItems : cuid, managed {
    order          : Association to Orders;
    product        : Association to Products;
    quantity       : Integer;
    pricePerPallet : Decimal(10, 2);
    subtotal       : Decimal(10, 2);
}

// Delivery tracking
entity Deliveries : managed {
    key deliveryNumber : String;
        order          : Association to Orders;
        status         : String enum {
            IN_PROCESS;
            SHIPPED;
        };
        shippedAt      : Timestamp; // Single timestamp for shipping event
}

// Invoice
entity Invoices : managed {
    key invoiceNumber : String;
        order         : Association to Orders;
        amount        : Decimal(10, 2);
        issueDate     : Date;
        status        : String enum {
            ISSUED;
            PAID;
        };
}
