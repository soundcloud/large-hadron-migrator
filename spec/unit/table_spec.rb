# Copyright (c) 2011 - 2013, SoundCloud Ltd., Rany Keddo, Tobias Bielohlawek, Tobias
# Schmidt

require File.expand_path(File.dirname(__FILE__)) + '/unit_helper'

require 'lhm/table'

describe Lhm::Table do
  include UnitHelper

  describe 'names' do
    it 'should name destination' do
      @table = Lhm::Table.new('users')
      @table.destination_name.must_equal 'lhmn_users'
    end
  end

  describe "constraints" do
    def set_columns(table, columns)
      table.instance_variable_set('@columns', columns)
    end

    it "should be satisfied with a single column primary key called id" do
      @table = Lhm::Table.new("table", "id")
      @table.columns["id"] = {:type => "int(11)"}
      set_columns(@table, { 'id' => { :type => 'int(1)', :extra => 'auto_increment' } })
      @table.satisfies_id_autoincrement_requirement?.must_equal true
    end

    it "should be satisfied with a primary key called something other than id" do
      @table = Lhm::Table.new("table", "weird_id")
      set_columns(@table, { 'weird_id' => { :type => "int(1)", :extra => 'auto_increment' } })
      @table.satisfies_id_autoincrement_requirement?.must_equal false
      @table.can_use_order_column?('weird_id').must_equal true
    end

    it "should not be satisfied with a non numeric primary key" do
      @table = Lhm::Table.new("table", "id")
      set_columns(@table, { 'id' => {:type => "varchar(255)"} })
      @table.satisfies_id_autoincrement_requirement?.must_equal false
    end

    it 'should not be satisfied if id is not auto increment' do
      @table = Lhm::Table.new('table', 'id')
      set_columns(@table, { 'id' => { :type => 'int(1)' } })
      @table.satisfies_id_autoincrement_requirement?.must_equal false
    end

    it "should not be satisfied with a non numeric key called something other than id" do
      @table = Lhm::Table.new("table", "weird_id")
      set_columns(@table, { 'weird_id' => { :type => "varchar(255)" } })
      @table.satisfies_id_autoincrement_requirement?.must_equal false
      @table.can_use_order_column?('weird_id').must_equal false
    end
  end
end
