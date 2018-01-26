require 'singleton'
require 'sqlite3'

class PlayDBConnection < SQLite3::Database
  include Singleton
  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end

end

class Play
  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum)  }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} is already in the database" if @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
  end

  def update
  end

end
