# frozen_string_literal: true

RSpec.describe Hash do
  describe "Basic Methods" do
    let(:user_profile) { { name: "Charlie", age: 35, email: "charlie@example.com", phone: "123-456-7890" } }

    describe "#[]" do
      it "retrieve the value associated with the key: name." do
        expect(user_profile[:email]).to eq("charlie@example.com")
      end
    end

    describe "#[] =" do
      it "update the user's age to 26 in the user_profile hash." do
        expect do
          user_profile[:age] = 26
        end.to change { user_profile[:age] }.from(35).to(26)
      end
    end

    describe "#delete" do
      it "remove the phone number from the user_profile hash return the phone value." do
        expect(
          user_profile.delete(:phone)
        ).to be("123-456-7890")
        expect(user_profile.key?(:phone)).to be(false)
      end
    end
  end
end
