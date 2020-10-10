require 'rails_helper'

RSpec.describe "Shelter specific index page" do
  it "can see all pets associated with shelter" do
    shelter_1 = create(:shelter)
    shelter_2 = create(:shelter)

    pet1 = shelter_1.pets.create!(name: "Bella", image: "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg", age: "5", sex: "Female", description: "Bork", status: 0)
    pet2 = shelter_2.pets.create!(name: "Mr.Cat", image: "https://media.wired.com/photos/5cdefb92b86e041493d389df/master/pass/Culture-Grumpy-Cat-487386121.jpg", age: "8", sex: "Male", description: "Has Russian Accent", status: 0)

    visit "/shelters/#{shelter_1.id}/pets"

    expect(page).to have_content(pet1.name)
    expect(page).to have_content(pet1.age)
    expect(page).to have_content(pet1.sex)
    expect(page).to have_content(pet1.status)

    visit "/shelters/#{shelter_2.id}/pets"

    expect(page).to have_content(pet2.name)
    expect(page).to have_content(pet2.age)
    expect(page).to have_content(pet2.sex)
    expect(page).to have_content(pet2.status)
  end
end