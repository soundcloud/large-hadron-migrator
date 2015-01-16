# Copyright (c) 2011 - 2013, SoundCloud Ltd., Rany Keddo, Tobias Bielohlawek, Tobias
# Schmidt

require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'pathname'
require 'lhm'

$project = Pathname.new(File.dirname(__FILE__) + '/..').cleanpath
$spec = $project.join('spec')
$fixtures = $spec.join('fixtures')

begin
  require 'active_record'
  begin
    require 'mysql2'
  rescue LoadError
    require 'mysql'
  end
rescue LoadError
  require 'dm-core'
  require 'dm-mysql-adapter'
end

logger = Logger.new STDOUT
logger.level = Logger::WARN
Lhm.logger = logger
