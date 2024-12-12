const cds = require("@sap/cds");

module.exports = cds.service.impl(async function () {
  const { Orders, Products } = this.entities;

  // Stock availability check
  this.before("CREATE", "Orders", async (req) => {
    const { items } = req.data;

    // Validate items array exists
    if (!items || !items.length) {
      return req.error(400, "Order must contain at least one item");
    }

    // Check stock for each item
    for (const item of items) {
      // Get current product stock
      const product = await SELECT.from(Products).where({
        ID: item.product_ID,
      });

      // First check if product exists
      if (!product.length) {
        return req.error(400, `Product ${item.product_ID} not found`);
      }

      // Only after confirming product exists, check stock
      const availableStock = product[0].stockQuantity;
      const requestedQuantity = item.quantity;

      // Validate stock availability
      if (availableStock < requestedQuantity) {
        return req.error(
          400,
          `Insufficient stock for product ${product[0].name}. Available: ${availableStock}, Requested: ${requestedQuantity}`
        );
      }
    }
  });
});
