require_relative "../lib/model/objects"

describe Schedule do
    it "has specified amount of tracks" do
        number_of_tracks = 1
        schedule = Schedule.new(number_of_tracks)
        expect(schedule.tracks.count).to eq number_of_tracks
    end

    it "schedules talks on morning first" do
        talk = Talk.new("Talk", 60)
        schedule = Schedule.new(1)
        schedule.schedule_talk(talk)
        expect(schedule.tracks[0].morning.talks).to include talk
    end

    it "does not schedule talks longer than 4 hours" do
        lengthy_talk = Talk.new("Lengthy Talk", $afternoon_duration + 1)
        schedule = Schedule.new(1)
        expect { schedule.schedule_talk(lengthy_talk) }.to raise_error ArgumentError
    end

    it "schedules talks longer than morning duration on afternoon" do
        talk = Talk.new("Talk", $morning_duration + 1)
        schedule = Schedule.new(1)
        schedule.schedule_talk(talk)
        expect(schedule.tracks[0].afternoon.talks).to include talk
    end
end