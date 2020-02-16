require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'descriptive_statistics'
end

require 'date'
require 'descriptive_statistics'
require 'ostruct'

BIRTHDAYS = (1...365).map { |day_number| Date.strptime(day_number.to_s, "%j") }

Run = Struct.new(:successful?, :room_size, keyword_init: true)

def run_once(limit:)
  birthday_match = nil
  birthdays = Set.new

  while !birthday_match && birthdays.length < limit do
    birthday = BIRTHDAYS.sample
    birthday_match = birthdays.add?(birthday) ? nil : birthday
  end

  Run.new(
    room_size: birthdays.length + 1,
    successful?: !!birthday_match
  )
end

run_count = (ARGV[0] || 1).to_i
limit = (ARGV[1] || 365).to_i

data = run_count.
  times.
  lazy.
  map { run_once(limit: limit) }.
  select(&:successful?).
  map(&:room_size).
  to_a

rate = data.length / run_count.to_f * 100

puts <<~EOS
  #{run_count} simulations run with rooms of #{limit} participants.
  #{data.length} runs were successful, with a success rate of #{rate.round(2)}%.
EOS

if data.any?
  puts <<~EOS
    Mean successful run required #{data.mean.round(1)} participants.
    Median successful run required #{data.median} participants.
    The smallest successful run required #{data.min} participants.
    The 1st percentile successful run required #{data.percentile(1).to_i} participants.
    The 5th percentile successful run required #{data.percentile(5).to_i} participants.
    The 25th percentile successful run required #{data.percentile(25).to_i} participants.
    The 75th percentile successful run required #{data.percentile(75).to_i} participants.
    The 95th percentile successful run required #{data.percentile(95).to_i} participants.
    The 99th percentile successful run required #{data.percentile(99).to_i} participants.
    The largest successful run required #{data.max} participants.
    The standard deviation was #{data.standard_deviation.round(1)} participants.
  EOS
end
