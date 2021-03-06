require "rails_helper"

describe "as a visitor" do
  describe "when I visit a shelters show page" do
    describe "I see a link to add a review" do
      it "when I click this link im taken to a form" do
        shelter1 = create(:shelter)
        shelter2 = create(:shelter)
        user = User.create!(name: "John Doe", address: "123 candy cane lane", city: "Denver", state: "Colorado", zip: "80128")

        visit "/shelters/#{shelter1.id}"

        click_link "Add Review"

        expect(current_path).to eq("/shelters/#{shelter1.id}/reviews/new")

        expect(page).to have_field('Title')
        expect(page).to have_field('Rating')
        expect(page).to have_field('Content')
        expect(page).to have_field('Name')
        expect(page).to have_field('Image')

        fill_in "Title", with: "This place rocks"
        fill_in "Rating", with: "5"
        fill_in "Content", with: "This place has everything you need"
        fill_in "Name", with: "#{user.name}"
        fill_in "Image", with: ""

        click_on "Add Review"

        expect(current_path).to eq("/shelters/#{shelter1.id}")

        expect(page).to have_content("This place rocks")
        expect(page).to have_content("5")
        expect(page).to have_content("This place has everything you need")
        expect(page).to have_content("#{user.name}")
        expect(page).to have_xpath("//img[@src='https://media3.giphy.com/media/o0vwzuFwCGAFO/giphy.gif?cid=790b761143794a0c3a7b311e04b4bbf2966d12685520db43&rid=giphy.gif']")

        visit "/shelters/#{shelter2.id}"

        click_link "Add Review"

        fill_in "Title", with: "This place rocks"
        fill_in "Rating", with: "5"
        fill_in "Content", with: "This place has everything you need"
        fill_in "Name", with: "#{user.name}"
        fill_in "Image", with: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTMGwI5inesDaT4zWtwKPvk0jvMyY2NT7lBrg&usqp=CAU"

        click_on "Add Review"

        expect(page).to_not have_xpath("//img[@src='https://media3.giphy.com/media/o0vwzuFwCGAFO/giphy.gif?cid=790b761143794a0c3a7b311e04b4bbf2966d12685520db43&rid=giphy.gif']")
        expect(page).to have_xpath("//img[@src='https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTMGwI5inesDaT4zWtwKPvk0jvMyY2NT7lBrg&usqp=CAU']")

      end
      it "I fail to fill in the form correctly and it displays a flash message" do
        shelter1 = create(:shelter)
        shelter2 = create(:shelter)
        user = User.create!(name: "John Doe", address: "123 candy cane lane", city: "Denver", state: "Colorado", zip: "80128")

        visit "/shelters/#{shelter1.id}"

        click_link "Add Review"

        expect(current_path).to eq("/shelters/#{shelter1.id}/reviews/new")

        expect(page).to have_field('Title')
        expect(page).to have_field('Rating')
        expect(page).to have_field('Content')
        expect(page).to have_field('Name')
        expect(page).to have_field('Image')

        fill_in "Title", with: ""
        fill_in "Rating", with: "5"
        fill_in "Content", with: "This place has everything you need"
        fill_in "Name", with: "#{user.name}"
        fill_in "Image", with: ""

        click_on "Add Review"

        expect(page).to have_content("Title can't be blank")
      end
      it "Won't allow a visitor create a form without a valid user" do
        shelter1 = create(:shelter)
        user = User.create!(name: "John Doe", address: "123 candy cane lane", city: "Denver", state: "Colorado", zip: "80128")

        visit "/shelters/#{shelter1.id}"

        click_link "Add Review"

        expect(current_path).to eq("/shelters/#{shelter1.id}/reviews/new")

        expect(page).to have_field('Title')
        expect(page).to have_field('Rating')
        expect(page).to have_field('Content')
        expect(page).to have_field('Name')
        expect(page).to have_field('Image')

        fill_in "Title", with: "This place rocks"
        fill_in "Rating", with: "5"
        fill_in "Content", with: "This place has everything you need"
        fill_in "Name", with: ""
        fill_in "Image", with: ""

        click_on "Add Review"

        expect(page).to have_content("User Must Exist")
      end
    end
  end
end
