require 'date'
require 'descriptive_statistics'

BIRTHDAYS = (1...365).map { |day_number|
  Date.strptime(day_number.to_s, "%j")
}

def run_once(limit: 366)
  birthday_match = nil
  birthdays = Set.new

  while !birthday_match && birthdays.length < limit do
    birthday = BIRTHDAYS.sample
    birthday_match = birthdays.add?(birthday) ? nil : birthday
  end

  [ birthdays.length + 1, birthday_match ]
end

def stats(data)
  <<~EOS
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


if ARGV[0] == "run_once_infinity"
  birthday_count, birthday_match = run_once

  puts "Out of #{birthday_count} participants, two participants had the same birthday of #{birthday_match.strftime("%B %d")}"
end

if ARGV[0] == "run_multiple_infinity"
  run_count = ARGV[1]
  data = run_count.to_i.times.map { run_once.first }

  puts "#{data.number.to_i} simulations run."
  puts stats(data)
end

if ARGV[0] == "run_once_limited"
  limit = ARGV[1].to_i

  _, birthday_match = run_once(limit: limit)

  if birthday_match
    puts "out of #{limit} participants, two participants had the same birthday of #{birthday_match.strftime("%B %d")}"
  else
    puts "out of #{limit} participants, no two participants had the same birthday."
  end
end

if ARGV[0] == "run_multiple_limited"
  run_count = ARGV[1].to_i
  limit = ARGV[2].to_i
  data = run_count.to_i.times.map { run_once(limit: limit) }.select(&:last).map(&:first)
  rate = data.length / run_count.to_f * 100

  puts <<~EOS
    #{run_count} simulations run with rooms of #{limit} participants.
    #{ data.length } runs were successful, with a success rate of #{rate.round(2)}%.
  EOS

  puts stats(data) if data.any?
end
