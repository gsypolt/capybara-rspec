describe "front module for polls -", :polls, :type => :feature  do

  before :each do
    visit '/module-showcase/polldaddy-poll/'
  end

  it "will show poll results when clicking on View Results" do
    first('.pmp-view-results').click
    expect(page).to have_selector('.poll-answer-wrapper', visible: true)
  end

  it "will show poll list when clicking on See All Polls" do
    first('.pmp-see-all-polls').click
    expect(URI.parse(current_url).path).to eq(URI.parse('/polls/all/').path)
  end

  it "will show poll results after a vote is submitted" do
    first('.pmp-answer-option').click
    expect(page).to have_selector('.poll-answer-wrapper', visible: true)
  end

  it "will display poll results for a given poll when returning after voting", :broken do
    localstorage_name = "polldaddy_pollvote"
    visit '/module-showcase/'
    driver = Capybara.current_session.driver
    name = String driver.execute_script("return localStorage.getItem('"+localstorage_name+"')")
    expect(name.empty?).to eq(false)
    expect(page).to have_selector('.poll-answer-wrapper', visible: true)
  end

end