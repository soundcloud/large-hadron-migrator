# Copyright (c) 2011, SoundCloud Ltd., Rany Keddo, Tobias Bielohlawek, Tobias
# Schmidt

require 'lhm/command'
require 'lhm/migration'
require 'lhm/sql_helper'

module Lhm
  # Switches origin with destination table using an atomic rename.
  class AtomicSwitcher
    include Command
    include SqlHelper

    attr_reader :connection

    def initialize(migration, connection = nil)
      @migration = migration
      @connection = connection
      @origin = migration.origin
      @destination = migration.destination
    end

    def statements
      atomic_switch
    end

    def atomic_switch
      [
        "rename table `#{ @origin.name }` to `#{ @migration.archive_name }`, " +
        "`#{ @destination.name }` to `#{ @origin.name }`"
      ]
    end
    
    def validate
      unless table?(@origin.name) && table?(@destination.name)
        error "`#{ @origin.name }` and `#{ @destination.name }` must exist"
      end
    end

  private
    def execute
      sql statements
    end
  end
end
