# frozen_string_literal: true

RSpec.describe Hash do # rubocop:disable Metrics/BlockLength
  describe "Basic Methods" do # rubocop:disable Metrics/BlockLength
    let(:user_profile) { { name: "Charlie", age: 35, email: "charlie@example.com", phone: "123-456-7890" } }
    let(:h) { { foo: 0, bar: 1, baz: 2 } }

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

    describe "#fetch" do # rubocop:disable Metrics/BlockLength
      context "if key is found" do
        it "returns the value for the given key" do
          expect(
            user_profile.fetch(:age)
          ).to be(35)
        end
      end

      context "if key is not found and no block was given" do
        it "return default value." do
          expect(
            user_profile.fetch(:location, :default)
          ).to eq(:default)
        end

        it "return unknown value." do
          expect(
            user_profile.fetch(:location, "Unknown")
          ).to eq("Unknown")
        end
      end

      context "If key is not found and a block was given," do
        it "yields key to the block and returns the block’s return value." do
          expect(
            user_profile.fetch(:location) { |key| "No key #{key}" }
          ).to eq("No key location")
        end
      end
    end

    describe "#each" do # rubocop:disable Metrics/BlockLength
      describe "#each_pair" do
        context "when called with a block" do
          it "returns self" do
            expect(h.each_pair {}).to be(h)
          end

          it "yields each key-value pair to the block" do
            keys = []
            values = []

            h.each_pair do |key, value|
              keys << key
              values << value
            end

            expect(keys).to eq(%i[foo bar baz])
            expect(values).to eq([0, 1, 2])
          end
        end

        context "when no block was given" do
          it "returns a new Enumerator" do
            expect(h.each_pair).to be_a(Enumerator)
          end
        end
      end

      describe "#each_key" do
        context "when called with a block" do
          it "returns self" do
            expect(h.each_key {}).to eq(h)
          end
        end

        context "when no block was given" do
          it "returns a new Enumerator" do
            expect(h.each_key).to be_a(Enumerator)
          end
        end
      end

      describe "#each_value" do
        context "when called with a block" do
          it "returns self" do
            expect(h.each_value {}).to eq(h)
          end
        end

        context "when no block was given" do
          it "returns a new Enumerator" do
            expect(h.each_value).to be_a(Enumerator)
          end
        end
      end
    end

    describe "#keys" do
      it "returns a new Array containing all keys in self" do
        expect(h.keys).to eq(%i[foo bar baz])
      end
    end
  end
end
