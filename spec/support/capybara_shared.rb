# By default this will return true, and thus all of the Capybara specs will
# fail until a developer using the site for training has patched up all of
# the vulnerabilities.
#
# However, RailsGoat maintainers need the Capybara features to pass to indicate
# changes to the site have not inadvertently removed or fixed any vulnerabilities
# since the whole point is to provide a site for a developer to fix.
@@displayed_spec_notice = false

def verifying_fixed?
  maintainer_env_name = 'RAILSGOAT_MAINTAINER'
  result = !ENV[maintainer_env_name]
  if !@@displayed_spec_notice && result
    puts <<-NOTICE

******************************************************************************
  You are running the RailsGoat Capybara Specs in Training mode. These specs
  are supposed to fail, indicating vulnerabilities exist. They contain
  spoilers, so do not read the code in spec/features if your goal is to
  learn more about patching the vulnerabilities. You should fix the
  vulnerabilities in the application in order to get these specs to pass**.
  You can use them to measure your progress.

  These same specs will pass if you set the #{maintainer_env_name} ENV
  variable.

  **NOTE: The RSpec pending feature is used to toggle the outcome of these
  specs between Training mode and RailsGoat Maintainer mode, so when the
  vulnerabilities are removed, these specs actually won't 'pass' but go into
  a 'pending' state.
******************************************************************************
    NOTICE
    @@displayed_spec_notice = true
  end
  result
end

def login(user)
  visit '/'
  within('.signup') do
    fill_in 'email', :with => user.email
    fill_in 'password', :with => user.clear_password
  end
  click_on 'Login'
end
