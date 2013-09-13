require 'faker'
require_relative '../config/application.rb'

20.times do
  Task.create(title: Faker::Commerce.product_name)
end
