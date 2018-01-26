
require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton
  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :title, :year, :playwright_id

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def self.find_by_title(title)
    play = PlayDBConnection.instance.execute(<<-SQL, title: title)
    SELECT
      *
    FROM
      plays
    WHERE
      title = :title
    SQL
    Play.new(play.first)
  end

  def self.find_by_playwright(name)
    plays = PlayDBConnection.instance.execute(<<-SQL, name: name)
    SELECT
      *
    FROM
      plays
    JOIN
      playwrights
    ON playwrights.id = plays.playwright_id
    WHERE
      playwrights.name = :name
    SQL
    plays.map { |play| Play.new(play)  }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already exists in the database" if @id
    PlayDBConnection.instance.execute(<<-SQL, title: title, year: year, playwright_id: playwright_id)
    INSERT INTO
      plays(title, year, playwright_id)
    VALUES
      (:title, :year, :playwright_id)
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} isn't in the database yet, create first" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
    UPDATE
      plays
    SET
      title = ?, year = ?, playwright_id = ?
    WHERE
      id = ?
    SQL
  end


end

class Playwright
  attr_accessor :name, :birth_year

  def self.all
    data = PlayDBConnection.instance.execute('select * from playwrights')
    data.map { |datum| Playwright.new(datum)  }
  end

  def self.find_by_name(name)
    playwright = PlayDBConnection.instance.execute(<<-SQL, name: name)
    SELECT
      *
    FROM
      playwrights
    WHERE
      name = :name
    SQL
    Playwright.new(playwright.first)
  end

  def initialize(options)
    @name = options['name']
    @birth_year = options['birth_year']
    @id = options['id']
  end

  def create
    raise "#{self} is a Playwright that is in the database" if @id
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year)
    INSERT INTO
      playwrights(name, birth_year)
    VALUES
      (?, ?)
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} isn't in the database yet" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @name, @birth_year, @id)
    UPDATE
      playwrights
    SET
      name = ?, birth_year = ?
    WHERE
      id = ?
    SQL
  end

  def get_plays
    plays = PlayDBConnection.instance.execute(<<-SQL, name: name)
    SELECT
      *
    FROM
      plays
    JOIN
      playwrights ON plays.playwright_id = playwrights.id
    WHERE
      playwrights.name = :name
    SQL

    plays.map { |play| Play.new(play)  }
  end

end
