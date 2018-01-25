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
  end

  def initialize(options)
  end

  def create
  end

  def update
  end

end
