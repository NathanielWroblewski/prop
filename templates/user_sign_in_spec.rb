require 'spec_helper'

describe 'An existing user', js: true do
  it 'can log in' do
    email = generate(:email)
    password = generate(:password)
    user = create(:user, email: email, password: password)

    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Sign in'

    expect(page).to have_content('success')
  end

  it 'cannot log in if a field is ommitted' do
    email = generate(:email)
    password = generate(:password)
    user = create(:user, email: email, password: password)

    visit new_user_session_path

    fill_in 'Email', with: email
    click_on 'Sign in'

    expect(page).to_not have_content('success')
    expect(page).to have_content('Invalid email or password.')
  end

  it 'can sign out if they are signed in' do
    email = generate(:email)
    password = generate(:password)
    user = create(:user, email: email, password: password)

    visit new_user_session_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_on 'Sign in'

    expect(page).to have_content('success')

    click_link 'Sign out'

    expect(page).to have_content('success')
  end
end
