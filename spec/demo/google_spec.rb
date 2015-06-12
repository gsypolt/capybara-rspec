describe "google homepage -", :google, :type => :feature  do

  before :each do
    visit 'https://google.com/'
  end

  it "search input field is exists" do
    expect(page).to have_css('input#lst-ib.gsfi')
  end
end
