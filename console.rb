require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

customer1 = Customer.new({'name' => 'Darren Shankland', 'funds' => 50})
customer1.save()



binding.pry
nil