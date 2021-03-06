require_relative('../db/sql_runner')
require_relative('customer')
require_relative('screening')

class Film

  attr_reader :id
  attr_accessor :title, :price

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @title = options['title']
    @price = options['price'].to_i
  end

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run(sql, values)[0]
    @id = film['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM films"
    results = SqlRunner.run(sql)
    return results.map{|film| Film.new(film)}
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def customers()
    # sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE tickets.film_id = $1"
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id INNER JOIN screenings ON tickets.screening_id = screenings.id WHERE screenings.film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|customer| Customer.new(customer)}
  end

  def customer_count()
    # sql = "SELECT tickets.* FROM tickets WHERE tickets.film_id = $1"
    sql = "SELECT tickets.* FROM tickets INNER JOIN screenings ON tickets.screening_id = screenings.id WHERE screenings.film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end

  def screenings()
    sql = "SELECT screenings.* FROM screenings WHERE screenings.film_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|screening| Screening.new(screening)}
  end

  # def most_popular_screening()
  #   sql = "SELECT screenings.* FROM screenings WHERE screenings.film_id = $1"
  #   values = [@id]
  #   results = SqlRunner.run(sql, values)
  #   screenings = results.map{|screening| Screening.new(screening)}
  #   most_popular = screenings[0]
  #   for screening in screenings do
  #     if screening.customer_count() >  most_popular.customer_count()
  #       most_popular = screening
  #     end
  #   end
  #   return most_popular
  # end
  # re-write of this to use the customer_count property, which is also used for capacity limits
  def most_popular_screening()
    sql = "SELECT screenings.* FROM screenings WHERE screenings.film_id = $1 ORDER BY screenings.customer_count DESC"
    values = [@id]
    results = SqlRunner.run(sql, values)
    screenings = results.map{|screening| Screening.new(screening)}
    most_popular = screenings[0]
    return most_popular
  end

end