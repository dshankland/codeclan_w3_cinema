require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')

Ticket.delete_all()
Customer.delete_all()
Film.delete_all()

customer1 = Customer.new({'name' => 'Ann Campbell', 'funds' => 50})
customer1.save()
customer2 = Customer.new({'name' => 'Anne McKendry', 'funds' => 100})
customer2.save()
customer3 = Customer.new({'name' => 'David McAllister', 'funds' => 80})
customer3.save()
customer4 = Customer.new({'name' => 'John Moir', 'funds' => 60})
customer4.save()

film1 = Film.new({'title' => 'Captain Marvel', 'price' => 11})
film1.save()
film2 = Film.new({'title' => 'Pet Sematary', 'price' => 9})
film2.save()
film3 = Film.new({'title' => 'Dumbo', 'price' => 10})
film3.save()

# ticket1 = Ticket.new({'customer_id' =>  customer1.id, 'film_id' => film3.id})
# ticket1.save()
# ticket2 = Ticket.new({'customer_id' =>  customer2.id, 'film_id' => film1.id})
# ticket2.save()
# ticket3 = Ticket.new({'customer_id' =>  customer3.id, 'film_id' => film1.id})
# ticket3.save()
# ticket4 = Ticket.new({'customer_id' =>  customer4.id, 'film_id' => film1.id})
# ticket4.save()
# ticket5 = Ticket.new({'customer_id' =>  customer1.id, 'film_id' => film1.id})
# ticket5.save()
#
customer1.buys_ticket(film3)
customer2.buys_ticket(film1)
customer3.buys_ticket(film1)
customer4.buys_ticket(film1)
customer1.buys_ticket(film1)


binding.pry
nil