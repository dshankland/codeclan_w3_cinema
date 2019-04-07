require_relative('../db/sql_runner')
require_relative('customer')

class Screening

  attr_reader :id
  attr_accessor :film_id, :showtime

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id'].to_i
    @showtime = options['showtime']
  end

  def save()
    sql = "INSERT INTO screenings (film_id, showtime) VALUES ($1, $2) RETURNING id"
    values = [@film_id, @showtime]
    screening = SqlRunner.run(sql, values)[0]
    @id = screening['id'].to_i
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    results = SqlRunner.run(sql)
    return results.map{|screening| Screening.new(screening)}
  end

  def update()
    sql = "UPDATE screenings SET (film_id, showtime) = ($1, $2) WHERE id = $3"
    values = [@film_id, @showtime, @id]
    SqlRunner.run(sql, values)
  end

  def self.all_films()
    sql = "SELECT films.title, screenings.showtime FROM films INNER JOIN screenings ON films.id = screenings.film_id;"
    results = SqlRunner.run(sql)
    return results
  end

  def price()
    sql = "SELECT films.price FROM films INNER JOIN screenings ON screenings.film_id = films.id WHERE screenings.id = $1"
    values = [@id]
    result = SqlRunner.run(sql, values)[0]['price'].to_i
    return result
  end

  def customers()
    sql = "SELECT customers.* FROM customers INNER JOIN tickets ON customers.id = tickets.customer_id WHERE tickets.screening_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.map{|customer| Customer.new(customer)}
  end

  def customer_count()
    sql = "SELECT tickets.* FROM tickets WHERE tickets.screening_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end

end