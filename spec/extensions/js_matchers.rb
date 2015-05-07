require 'rspec/expectations'
require 'capybara/cucumber'

#
# A method to assert between two elements that one has a higher
# position on the page than the other. This is performed via an offset().top
# comparison where the smaller number indicates the highest position.
#
#
RSpec::Matchers.define :be_above do |bottom_element|
  match do |top_element|
    expect(page).to have_css(top_element)
    expect(page).to have_css(bottom_element)
    @top_offset = evaluate_script("$('#{top_element}').offset().top").to_i
    @bottom_offset = evaluate_script("$('#{bottom_element}').offset().top").to_i
    # When working with offsets, a smaller number indicates a higher position.
    @top_offset < @bottom_offset # Performs the physical assertion.
  end
  failure_message do |top_element|
    "Expected element #{top_element} is above #{bottom_element} on the page,
    instead found #{@top_offset} versus #{@bottom_offset}."
  end
end