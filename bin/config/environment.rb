require 'bundler'
Bundler.require

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: 'db/development.db')
old_logger = ActiveRecord::Base.logger
ActiveRecord::Base.logger = nil
require_all 'app'
$prompt = TTY::Prompt.new
Paint.mode = 0xFFFFFF
