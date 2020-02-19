require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'descriptive_statistics'
end

require 'date'
require 'descriptive_statistics'
require 'ostruct'
require 'optparse'

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

options = {
  run_count: 1,
  limit: 365
}

OptionParser.new do |opts|
  opts.banner = "Usage: birthday_paradox.rb [options]"

  opts.on("-lLIMIT", "--limit=LIMIT", "Room size limit (default 365)") do |l|
    options[:limit] = l.to_i
  end

  opts.on("-rRUN_COUNT", "--run-count=RUN_COUNT", "Number of simulations (default 1)") do |r|
    options[:run_count] = r.to_i
  end
end.parse!

data = options[:run_count].
  times.
  lazy.
  map { run_once(limit: options[:limit]) }.
  select(&:successful?).
  map(&:room_size).
  to_a

rate = data.length / options[:run_count].to_f * 100

puts <<~EOS
  #{options[:run_count]} simulations run with rooms of #{options[:limit]} participants.
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
