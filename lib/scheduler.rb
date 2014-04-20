require_relative "model/objects"

class BacktrackingScheduler

    def initialize(talks_to_schedule)
        @talks_to_schedule = talks_to_schedule
        @successful_candidates = []
    end

    def schedule()
        min_number_of_tracks = min_number_of_tracks_needed()
        while !backtrack(SolutionCandidate.root(@talks_to_schedule, min_number_of_tracks))
            min_number_of_tracks = min_number_of_tracks + 1
        end
        return @successful_candidates
    end

    def min_number_of_tracks_needed()
        (total_talks_duration().to_f / ($morning_duration + $afternoon_duration).to_f).ceil
    end

    def total_talks_duration()
        @talks_to_schedule.inject(0) {|total, talk| total + talk.duration}
    end

    def backtrack(candidate)
        if !candidate.valid?
            return false
        elsif candidate.complete?
            @successful_candidates << candidate
            return true
        else
            foundSolution = false
            candidate_child = candidate.first_child
            while !candidate_child.nil?
                foundSolution = backtrack(candidate_child)
                candidate_child = candidate_child.next_child
            end
            return foundSolution
        end
    end
end

class SolutionCandidate

    attr_reader :schedule

    def initialize(talks_to_schedule, schedule)
        @talks_to_schedule = talks_to_schedule
        @schedule = schedule
    end

    def self.root(talks_to_schedule, min_number_of_tracks)
        talks_to_schedule.sort! { |a,b| b.duration <=> a.duration }
        SolutionCandidate.new(talks_to_schedule, Schedule.new(min_number_of_tracks))
    end

    def valid?()
        if complete?
            return true
        end
        @schedule.can_schedule_talk? @talks_to_schedule[0]
    end

    def complete?()
        @talks_to_schedule.nil? || @talks_to_schedule.empty?
    end

    def first_child()
        child_schedule = Schedule.copy(@schedule)
        child_schedule.schedule_talk(@talks_to_schedule[0])
        SolutionCandidate.new(@talks_to_schedule[1..-1], child_schedule)
    end

    def next_child()
        if (@talks_to_schedule.count < 2) || !(@schedule.can_schedule_talk? @talks_to_schedule[1])
            return nil
        end
        child_schedule = Schedule.copy(@schedule)
        child_talks_to_schedule = Array.new(@talks_to_schedule)
        child_schedule.schedule_talk(child_talks_to_schedule.slice!(1))
        SolutionCandidate.new(child_talks_to_schedule, child_schedule)
    end
end
