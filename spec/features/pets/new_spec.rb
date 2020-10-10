require "rails_helper"

describe "as a visitor" do
  describe "when i visit a shelter pets index page" do
    it "I see a link to create a pet" do
      shelter_1 = create(:shelter)


      visit "/shelters/#{shelter_1.id}/pets"

      expect(page).to have_link("Create Pet")

      click_link "Create Pet"

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets/new")

      expect(page).to_not have_field(:status)

      fill_in "name", with: "Pet Name"
      fill_in "image", with: "placeholder"
      fill_in "description", with: "test pet creation"
      fill_in "age", with: "2"
      fill_in "sex", with: "you decide"

      click_on "Create Pet"

      expect(current_path).to eq("/shelters/#{shelter_1.id}/pets")

      expect(page).to have_content("Pet Name")
      expect(page).to have_content("placeholder")
      expect(page).to have_content("2")
      expect(page).to have_content("you decide")
      expect(page).to have_content("adoptable")
    end
  end
end