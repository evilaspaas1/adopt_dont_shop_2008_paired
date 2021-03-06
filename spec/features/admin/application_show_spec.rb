require 'rails_helper'

describe "As a visitor" do
  describe "When I visit an admin applicaiton show page ('/admin/applications/:id')" do
    before :each do
      @shelter1 = Shelter.create(name: "Van's pet shop", address: "3724 tennessee dr", city: "Rockford", state: "Illinois", zip: "61108")
      @shelter2 = Shelter.create(name: "Bovice's pet shop", address: "1060 W Addison", city: "Chicago", state: "Illinois", zip: "61109")
      @pet1 = @shelter1.pets.create(image: "https://img.webmd.com/dtmcms/live/webmd/consumer_assets/site_images/article_thumbnails/other/dog_cool_summer_slideshow/1800x1200_dog_cool_summer_other.jpg", name: "Bella", age: "5", sex: "female", description: "Fun Loving Dog", status: 0)
      @pet2 = @shelter2.pets.create(image: "https://static.insider.com/image/5d24d6b921a861093e71fef3.jpg", name: "Maisy", age: "6", sex: "female", description: "Stomache on legs", status: 0)
      @user = User.create!(name: "Tim Tyrell", address: "321 you hate to see it dr", city: "Denver", state: "Colorado", zip: "80000")
      @application = @user.applications.create(description: "I'm awesome, give me animals.", status: 1)
      @application.application_pets.create([{pet_id: @pet1.id}, {pet_id: @pet2.id}])
      visit "/admin/applications/#{@application.id}"
    end
    it "I see a button for every pet to approve that pet for the application" do
      within("#pet-application-status-#{@pet1.id}") do
        expect(page).to have_button("Approve Pet")
      end
      within("#pet-application-status-#{@pet2.id}") do
        expect(page).to have_button("Approve Pet")
      end
    end
    it "When I click that button, I'm taken back to the admin application show page and next to the pet I approved, I see an approval indicator next to the pet instead of an approaval button" do
      within("#pet-application-status-#{@pet1.id}") do
        click_button "Approve Pet"
        expect(page).to have_content("accepted")
        expect(page).to_not have_button("Approve Pet")
      end
      within("#pet-application-status-#{@pet2.id}") do
        click_button "Approve Pet"
        expect(page).to have_content("accepted")
        expect(page).to_not have_button("Approve Pet")
      end
    end
    it "I see a button for every pet to reject that pet for the application" do
      within("#pet-application-status-#{@pet1.id}") do
        expect(page).to have_button("Reject Pet")
      end
      within("#pet-application-status-#{@pet2.id}") do
        expect(page).to have_button("Reject Pet")
      end
    end
    it "When I click that button, I'm taken back to the admin application show page and next to the pet I rejected, I see an rejection indicator next to the pet instead of an reject button" do
      within("#pet-application-status-#{@pet1.id}") do
        click_button "Reject Pet"
        expect(page).to have_content("rejected")
        expect(page).to_not have_button("Reject Pet")
      end
      within("#pet-application-status-#{@pet2.id}") do
        click_button "Reject Pet"
        expect(page).to have_content("rejected")
        expect(page).to_not have_button("Reject Pet")
      end
    end
    describe "and I approve all pets for and application" do
      it "then I am taken back to the admin application show page and I see the applications's status has changed to 'approved'" do
        expect(page).to have_content("Status: pending")

        within("#pet-application-status-#{@pet1.id}") do
          click_button "Approve Pet"
        end

        expect(page).to have_content("Status: pending")

        within("#pet-application-status-#{@pet2.id}") do
          click_button "Approve Pet"
        end

        expect(page).to have_content("Status: approved")
      end
    end
    describe "and I reject one or more pets on the application, but approve all other pets" do
      it "then I am taken back to the admin application show page and I see the application's status has changet to 'rejected'" do
        expect(page).to have_content("Status: pending")

        within("#pet-application-status-#{@pet1.id}") do
          click_button "Reject Pet"
        end

        within("#pet-application-status-#{@pet2.id}") do
          click_button "Approve Pet"
        end

        expect(page).to have_content("Status: rejected")
      end
    end
    describe "When a pet has and approved application on them" do
      describe "I as an admin cannot approve or reject them for another app" do
        it "And I see a message telling me that this pet has been approved for adoption" do
          @user2 = User.create!(name: "John Doe", address: "123 candy cane lane", city: "Denver", state: "Colorado", zip: "80128")
          @application2 = @user2.applications.create(description: "Just cuz", status: 1)
          @application2.application_pets.create([{pet_id: @pet1.id}, {pet_id: @pet2.id}])
          expect(page).to have_content("Status: pending")

          within("#pet-application-status-#{@pet1.id}") do
            click_button "Approve Pet"
          end

          expect(page).to have_content("Status: pending")

          within("#pet-application-status-#{@pet2.id}") do
            click_button "Approve Pet"
          end

          expect(page).to have_content("Status: approved")

          visit "/admin/applications/#{@application2.id}"

          within("#pet-application-status-#{@pet1.id}") do
            expect(page).to_not have_button("Approve Pet")
            expect(page).to have_content("This pet has already been approved for adoption")
          end

          within("#pet-application-status-#{@pet2.id}") do
            expect(page).to_not have_button("Approve Pet")
            expect(page).to have_content("This pet has already been approved for adoption")
          end
        end
      end
    end
  end
end
