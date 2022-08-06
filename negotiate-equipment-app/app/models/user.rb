class User < ApplicationRecord
    after_create :insert_products

    has_many :products

    def insert_products
        products = [
            { name: "Desktop Gamer", price: 252.0 },
            { name: "Notebook",      price: 202.0 },
            { name: "Laser Printer", price: 126.0 },
            { name: "Smartphone",    price: 50.0  },
            { name: "Mouse",         price: 20.0  }
        ]

        products.each do |product|
            self.products.create(name: product[:name], price: product[:price])
        end
    end

    def to_s
        self.name
    end
end
