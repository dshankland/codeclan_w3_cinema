require_relative('../db/sql_runner')
require_relative('film')
require_relative('ticket')
require_relative('screening')

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @funds = options['funds'].to_i
  end

  def save()
    sql = "INSERT INTO customers (name, funds) VALUES ($1, $2) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run(sql, values)[0]
    @id = customer['id'].to_i
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    results = SqlRunner.run(sql)
    return results.map{|customer| Customer.new(customer)}
  end

  def update()
    sql = "UPDATE customers SET (name, funds) = ($1, $2) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def films()
    # sql = "SELECT films.* FROM films INNER JOIN tickets ON films.id = tickets.film_id WHERE tickets.customer_id = $1"
    sql = "SELECT films.* FROM films INNER JOIN screenings ON films.id = screenings.film_id INNER JOIN tickets ON tickets.screening_id = screenings.id WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|film| Film.new(film)}
  end

  def charge_fee(fee)
    @funds -= fee
    update()
  end

  def sufficient_funds(fee)
    return @funds >= fee ? true : false
  end

  # assuming the buy_ticket should be a customer method
  # assuming we take a film as a parameter
  # def buys_ticket(film)
  #   # assumes we're passed a legit film
  #   # add if  statement for sufficient funds
  #   if sufficient_funds(film.price)
  #     # create a ticket, with film.id and customer.id
  #     ticket = Ticket.new({'customer_id' => @id, 'film_id' => film.id})
  #     ticket.save()
  #     # call charge_fee (stolen shamelessly from imdb)
  #     charge_fee(film.price)
  #   end
  # end
  # re-write of buys_ticket to work on screening instead of film
  def buys_ticket(screening)
    if sufficient_funds(screening.price())
      ticket = Ticket.new({'customer_id' => @id, 'screening_id' => screening.id})
      ticket.save()
      charge_fee(screening.price())
    end
  end

  def ticket_count()
    sql = "SELECT tickets.* FROM tickets WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end

  def screenings()
    sql = "SELECT screenings.* FROM screenings INNER JOIN tickets ON tickets.screening_id = screenings.id WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|screening| Screening.new(screening)}
  end

end