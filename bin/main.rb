#!/usr/bin/ruby

require_relative "../lib/model/objects"
require_relative "../lib/scheduler"

t1 = Talk.new("talk A", 240)
t2 = Talk.new("talk B", 240)
t3 = Talk.new("talk C", 240)

scheduler = BacktrackingScheduler.new([t1, t2, t3])
candidates = scheduler.schedule

candidates.each { |candidate|
    puts "\nSuccessful Candidate"
    candidate.schedule.tracks.each { |track|
        puts "#{track.name}"
        puts "morning:"
        track.morning.talks.each { |talk|
            puts "#{talk.name} - #{talk.duration} minutes"
        }
        puts "afternoon:"
        track.afternoon.talks.each { |talk|
            puts "#{talk.name} - #{talk.duration} minutes"
        }
    }
}