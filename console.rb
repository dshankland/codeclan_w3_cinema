require('pry-byebug')
require_relative('models/customer')
require_relative('models/film')
require_relative('models/ticket')
require_relative('models/screening')

Ticket.delete_all()
Screening.delete_all()
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

screening1 = Screening.new({'film_id' => film1.id, 'showtime' => '12:00'})
screening1.save()
screening2 = Screening.new({'film_id' => film1.id, 'showtime' => '15:00'})
screening2.save()
screening3 = Screening.new({'film_id' => film2.id, 'showtime' => '17:15'})
screening3.save()
screening4 = Screening.new({'film_id' => film2.id, 'showtime' => '20:15'})
screening4.save()
screening5 = Screening.new({'film_id' => film3.id, 'showtime' => '11:30'})
screening5.save()
screening6 = Screening.new({'film_id' => film3.id, 'showtime' => '14:30'})
screening6.save()

customer1.buys_ticket(film3)
customer2.buys_ticket(film1)
customer3.buys_ticket(film1)
customer4.buys_ticket(film1)
customer1.buys_ticket(film1)


binding.pry
nil