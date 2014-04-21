$morning_duration = 180
$afternoon_duration = 240

class Schedule

    attr_reader :tracks

    def initialize(number_of_tracks)
        @tracks = []
        for i in 1..number_of_tracks do
            @tracks << Track.new("Track #{i}")
        end
    end

    def self.copy(schedule)
        schedule_copy = Schedule.new(0)
        schedule.tracks.each { |track|
            schedule_copy.tracks << Track.copy(track)
        }
        return schedule_copy
    end

    def can_schedule_talk?(talk)
        @tracks.inject(false) {|can_add, track| can_add || track.can_add_talk?(talk)}
    end

    def schedule_talk(talk)
        if talk.duration > $afternoon_duration
            raise ArgumentError, "Cannot schedule talks longer than #{$afternoon_duration} minutes"
        end
        if !talk.nil?
            @tracks.each { |track|
                if track.can_add_talk? talk
                    track.add_talk talk
                    break
                end
            }
        end
    end
end

class Track

    attr_reader :name, :morning, :afternoon

    def initialize(name)
        @name = name
        @morning = Period.morning
        @afternoon = Period.afternoon
    end

    def self.copy(track)
        track_copy = Track.new(track.name)
        track.morning.talks.each { |talk|
            track_copy.morning.add_talk talk
        }
        track.afternoon.talks.each { |talk|
            track_copy.afternoon.add_talk talk
        }
        return track_copy
    end

    def can_add_talk?(talk)
        (@morning.can_add_talk? talk) || (@afternoon.can_add_talk? talk)
    end

    def add_talk(talk)
        if @morning.can_add_talk? talk
            @morning.add_talk talk
        elsif @afternoon.can_add_talk? talk
            @afternoon.add_talk talk
        else
            raise "Cannot add talk to track #{@name}"
        end
    end
end

class Period

    attr_reader :talks, :duration

    def self.morning()
        Period.new($morning_duration)
    end

    def self.afternoon()
        Period.new($afternoon_duration)
    end

    def initialize(duration)
        @duration = duration
        @talks = []
    end

    def add_talk(talk)
        @talks << talk
    end

    def can_add_talk?(talk)
        talk.duration <= available_time
    end

    def available_time()
        @duration - occupation
    end

    def occupation()
        @talks.inject(0) {|occupation, talk| occupation + talk.duration}
    end
end

class Talk

    attr_reader :name, :duration

    def initialize(name, duration)
        @name = name
        @duration = duration
    end
end
