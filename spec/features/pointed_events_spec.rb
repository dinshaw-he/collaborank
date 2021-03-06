RSpec.feature 'As a user', type: :feature do
  let(:user) { users(:homer) }
  let(:most_recent_event) { PointedEvent.order('created_at desc').first }

  before do
    travel_to 1.week.ago do
      PointedEventCreator.new.call({ type: 'PR_APPROVAL', github_handles: [user.github] } )
    end

    travel_to 3.days.ago do
      PointedEventCreator.new.call({ type: 'PR_COAUTHORS', emails: [user.email] } )
    end

    visit pointed_events_path
  end

  scenario 'I can see all PointedEvents' do
    within first('tbody tr') do
      expect(page).to have_content most_recent_event.type
    end
  end
end
