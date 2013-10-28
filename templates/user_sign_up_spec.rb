require 'spec_helper'

describe 'A visitor', js: true  do
  it 'can create a new user' do
    email = generate(:email)
    password = generate(:password)
    visit new_user_registration_path

    fill_in 'Email', with: email
    fill_in 'Password', with: password

    click_button 'Sign up'

    expect(page).to have_content I18n.t('devise.registrations.signed_up')

    user = User.find_by(email: email)
    expect(user).to be
  end

  it 'can not create a new user if they omit a field' do
    email = generate(:email)
    visit new_user_registration_path

    fill_in 'Email', with: email

    click_button 'Sign up'

    expect(page).to have_content 'Sign up'
    expect(page).to_not have_content 'success'
  end
end
