# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Product.delete_all

Product.create(title: 'Programming Ruby 1.9',
               description:
                 %{
              <p>
                Ruby is the fastest growing and most exciting dynamic language out there.
              </p>
              },
               image_url: 'ruby.png',
               price: 49.50
)

Product.create(title: 'Operation System',
               description: %{
               <p>
                  This banana is so delicious!
               </p>},
               image_url: 'os.png',
               price: 12.33
)

Product.create(title: 'Engineering A Compiler',
               description: %{
                  <p> An expression e is available at point p in a procedure if and only if on every path from the procedure’s entry to p,
                  e is evaluated and none of its constituent subexpressions is redeﬁned between that evaluation and p </p>
                },
               image_url: 'compiler.jpg',
               price: 49.88
)
