# frozen_string_literal: true

namespace :boot do
  desc 'Tries to connect to Backend'
  task backend: :environment do
    status = ThreeScale::Core::APIClient::Resource.api(:get, {}, uri: 'status').fetch(:response_json)
    puts "Backend Internal API version #{status.fetch(:version).fetch(:backend)} status: #{status.fetch(:status)}"
  end

  desc 'Tries to connect to the database'
  task :database do
    begin
      require 'system/database'
      exit false unless System::Database.ready?
    end
  end

  desc 'Tries to connect to Redis'
  task :redis do
    redis_config = Rails.application.config_for(:redis)
    redis = Redis.new(redis_config)
    redis.ping
    puts "Connected to #{redis.id}"
  end

  task all: %i[backend database redis]
end

desc 'Tries to connect to external services like Backend, DB, Redis or crashes'
task boot: 'boot:all'

Rake::Task['db:seed'].enhance(['boot:database'])
