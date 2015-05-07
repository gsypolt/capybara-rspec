describe "poster ads", :type => :feature do

  before :each do
    browser = Capybara.current_session.driver.browser
    browser.manage.delete_all_cookies
  end

  after :each do
    page.execute_script('if (localStorage && localStorage.clear) localStorage.clear()')
    page.execute_script('if (sessionStorage && sessionStorage.clear) sessionStorage.clear()')
  end

  it "appears on a blog page" do
    visit '/story/life/music/2014/06/22/jimmy-c-newman-opry/11237203/'
    expect(page).to have_css(".poster-ad-asset-module")
  end

  it "appears on a story with priority video page" do
    visit '/story/news/nation/2014/06/23/christian-radio-host-charged-sex-probe/11251795/'
    wait_for_pageload
    expect(page).to have_css(".poster-ad-asset-module")
    expect(".ui-video-wrapper").to be_above ".poster-ad-asset-module"
  end

  # This is a duplicate testing scenario based on the validation point
  it "appears on a gallery page" do
    visit '/story/life/music/2014/06/22/jimmy-c-newman-opry/11237203/'
    expect(page).to have_css(".poster-ad-asset-module")
  end

  it "appears on a video page" do
    visit '/videos/news/politics/2014/07/16/12728105/'
    expect(page).to have_css(".poster-ad-asset-module")
    expect(".ui-video-wrapper").to be_above ".poster-ad-asset-module"
  end

end