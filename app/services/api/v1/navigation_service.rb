# frozen_string_literal: true

class Api::V1::NavigationService
  def self.navigation_links
    [
      {
        id: "products",
        title: "Products",
        path: "/products",
        children: [
          { id: "products-table", title: "Products Table", path: "/products" },
          { id: "add-product", title: "Add Product", path: "/add-product" },
          { id: "import-products", title: "Import Products", path: "/import-products" }
        ]
      },
      {
        id: "deal-management",
        title: "Deal Management",
        path: "/deal-management",
        children: [
          { id: "invoices", title: "Invoices", path: "/invoices" },
          { id: "orders-status", title: "Orders Status", path: "/orders-status" },
          { id: "crm", title: "CRM", path: "/crm" }
        ]
      }
    ]
  end
end
