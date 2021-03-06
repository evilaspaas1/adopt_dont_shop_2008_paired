require 'rails_helper'

describe "As a visitor" do
  describe "when I visit an applications show page '/applications/:id'" do
    it "then I see an application and it's info" do
      user = User.create!(name: "Tim Tyrell", address: "321 you hate to see it dr", city: "Denver", state: "Colorado", zip: "80000")
      shelter = Shelter.create(name: "Van's pet shop", address: "3724 tennessee dr", city: "Rockford", state: "Illinois", zip: "61108")
      pet1 = shelter.pets.create(image: "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg", name: "Bella", age: "5", sex: "female", description: "Fun Loving Dog", status: 0)
      pet2 = shelter.pets.create(image: "https://static.insider.com/image/5d24d6b921a861093e71fef3.jpg", name: "Maisy", age: "6", sex: "female", description: "Stomache on legs", status: 0)
      pet3 = shelter.pets.create(image: "https://media.wired.com/photos/5cdefb92b86e041493d389df/master/pass/Culture-Grumpy-Cat-487386121.jpg", name: "Mr. Cat", age: "9", sex: "male", description: "Has Russian accent", status: 0)
      pet4 = shelter.pets.create(image: "https://i.dailymail.co.uk/1s/2020/03/20/13/26207684-0-image-a-4_1584711978894.jpg", name: "Frank", age: "3", sex: "male", description: "Danger Noodle", status: 0)
      application = user.applications.create(description: "I'm awesome, give me animals.", status: 1)
      application.application_pets.create([{pet_id: pet1.id}, {pet_id: pet2.id}, {pet_id: pet3.id}, {pet_id: pet4.id}])

      visit "/applications/#{application.id}"

      expect(page).to have_content(application.user_name)
      expect(page).to have_content(application.full_address)
      expect(page).to have_content(application.description)
      expect(page).to have_content(pet1.name)
      expect(page).to have_content(pet2.name)
      expect(page).to have_content(pet3.name)
      expect(page).to have_content(pet4.name)
      expect(page).to have_content(application.status)

      click_on "#{pet1.name}"

      expect(current_path).to eq("/pets/#{pet1.id}")

      visit "/applications/#{application.id}"
      click_on "#{pet2.name}"

      expect(current_path).to eq("/pets/#{pet2.id}")

      visit "/applications/#{application.id}"
      click_on "#{pet3.name}"

      expect(current_path).to eq("/pets/#{pet3.id}")

      visit "/applications/#{application.id}"
      click_on "#{pet4.name}"

      expect(current_path).to eq("/pets/#{pet4.id}")
    end
    describe "And that application has not been submitted" do
      it "then I see a section on the page to 'Add a Pet to this Application'" do
        user = User.create!(name: "Tim Tyrell", address: "321 you hate to see it dr", city: "Denver", state: "Colorado", zip: "80000")
        shelter = Shelter.create(name: "Van's pet shop", address: "3724 tennessee dr", city: "Rockford", state: "Illinois", zip: "61108")
        application = user.applications.create(description: "I'm awesome, give me animals.")
        pet = shelter.pets.create(image: "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg", name: "Bella", age: "5", sex: "female", description: "Fun Loving Dog", status: 0)

        visit "/applications/#{application.id}"

        expect(page).to have_field("Add a Pet to this Application:")
        expect(page).to_not have_button("Submit Application")
        expect(page).to_not have_button("Adopt This Pet")
        expect(page).to_not have_field("Why Are You A Good Owner?")

        fill_in "Add a Pet to this Application:", with: "b"

        click_button "Search Pets"

        expect(current_path).to eq("/applications/#{application.id}")

        within "#result-#{pet.id}" do
          expect(page).to have_content(pet.name)
          click_button("Adopt This Pet")
        end
        expect(current_path).to eq("/applications/#{application.id}")

        within "#app-pets-#{pet.name}" do
          expect(page).to have_content(pet.name)
        end

        expect(page).to have_field("Why Are You A Good Owner?")

        fill_in "Why Are You A Good Owner?", with: "Just cuz"

        click_button "Submit Application"

        expect(current_path).to eq("/applications/#{application.id}")

        expect(page).to have_content("pending")

        expect(page).to_not have_field("Add a Pet to this Application:")
        expect(page).to_not have_button("Adopt This Pet")
        expect(page).to_not have_field("Why Are You A Good Owner?")
      end
      it "Shows flash message when I dont fill in good owner field" do
        user = User.create!(name: "Tim Tyrell", address: "321 you hate to see it dr", city: "Denver", state: "Colorado", zip: "80000")
        shelter = Shelter.create(name: "Van's pet shop", address: "3724 tennessee dr", city: "Rockford", state: "Illinois", zip: "61108")
        application = user.applications.create(description: "I'm awesome, give me animals.")
        pet = shelter.pets.create(image: "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg", name: "Bella", age: "5", sex: "female", description: "Fun Loving Dog", status: 0)

        visit "/applications/#{application.id}"

        fill_in "Add a Pet to this Application:", with: pet.name

        click_button "Search Pets"

        expect(current_path).to eq("/applications/#{application.id}")

        within "#result-#{pet.id}" do
          expect(page).to have_content(pet.name)
          click_button("Adopt This Pet")
        end
        expect(current_path).to eq("/applications/#{application.id}")

        fill_in "Why Are You A Good Owner?", with: ""

        click_button "Submit Application"

        expect(page).to have_content("Must enter a Description")
      end
    end
  end
end
