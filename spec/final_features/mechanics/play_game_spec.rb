require 'rails_helper'

feature 'user plays the game', js: true do
  scenario 'users without a profile cannot play the game' do
    When 'a user visits the game' do
      visit('/game')
    end

    Then 'they are redirected to the registration page' do
      wait_for do
        focus_on(:page_content).container_for('register').heading
      end.to eq('Register')
    end
  end

  context 'user with incomplete profile' do
    before do
      @profile = create_and_login_as(handle: 'BBCmicro', email: nil)
    end

    scenario 'game shows loading spinner while the user profile is being fetched' do
      When 'a user visits the game page in original loading state' do
        with_api_route_paused(method: 'get', url: '/api/v1/profiles') do
          visit('/game')
          wait_for { focus_on(:util).test_elements('spinner') }.to eq ['Loading...']
        end
      end

      Then 'the loading element is no longer visible' do
        wait_for { focus_on(:util).test_elements('profile') }.to_not include('Loading...')
      end
    end

    scenario 'users with a profile can play the game' do
      When 'user visits the game' do
        visit('/game')
      end

      Then 'they are shown the coming soon status' do
        wait_for { focus_on(:page_content).container_for('game').heading }.to eq('coming soon')
      end

      And 'an action to complete their profile' do
        wait_for do
          focus_on(:page_content).container_for('game').actions
        end.to eq(['Complete my profile'])
      end
    end
  end

  context 'user with complete profile' do
    before do
      create_and_login_as(
        handle: 'BBCmicro',
        email: 'sophie.wilson@acorn.co.uk',
        avatar_url: '/sample_avatars/bbc_micro_80_80.png'
      )
    end

    scenario 'users with a profile can play the game' do
      When 'user visits the game' do
        visit('/game')
      end

      Then 'they are shown the coming soon status' do
        wait_for { focus_on(:page_content).container_for('game').heading }.to eq('coming soon')
      end

      And 'an action to complete their profile' do
        wait_for do
          focus_on(:page_content).container_for('game').actions
        end.to eq([])
      end
    end
  end
end
