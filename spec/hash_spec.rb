# frozen_string_literal: true

RSpec.describe Hash do # rubocop:disable Metrics/BlockLength
  describe "Basic Methods" do # rubocop:disable Metrics/BlockLength
    let(:user_profile) { { name: "Charlie", age: 35, email: "charlie@example.com", phone: "123-456-7890" } }
    let(:h) { { foo: 0, bar: 1, baz: 2 } }
    let(:customer_record) do
      {
        user: {
          profile: {
            name: "Alice",
            address: {
              city: "Wonderland",
              zip: "12345"
            }
          },
          orders: [
            { id: 1, item: "Cheshire Cat Plush", quantity: 2 },
            { id: 2, item: "Mad Hatter Hat", quantity: 1 }
          ]
        }
      }
    end

    let(:permissions) do
      {
        role: {
          admin: { read: true, write: false },
          guest: { read: true }
        }
      }
    end

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

    describe "#values" do
      it "returns a new Array containing all values in self" do
        expect(h.values).to eq([0, 1, 2])
      end
    end

    describe "#key?" do
      context "when a key is present" do
        it "returns true" do
          expect(h.key?(:foo)).to be(true)
        end
      end

      context "when a key is not present" do
        it "returns false" do
          expect(h.key?(:blue)).to be(false)
        end
      end
    end

    describe "#value?" do
      context "when a value is present" do
        it "returns true" do
          expect(user_profile.value?("charlie@example.com")).to be(true)
        end
      end

      context "when a value is not present" do
        it "returns false" do
          expect(user_profile.value?(1)).to be(false)
        end
      end
    end

    describe "#dig" do
      context "when specified by key and identifiers" do
        it "find and returns the object in nested object" do
          expect(customer_record.dig(:user, :profile, :name)).to eq("Alice")
          expect(customer_record.dig(:user, :profile, :address, :city)).to eq("Wonderland")
          expect(customer_record.dig(:user, :orders, 0, :id)).to eq(1)
          expect(customer_record.dig(:user, :orders, 1, :item)).to eq("Mad Hatter Hat")
        end
      end

      context "when the keys is not present and a default value was not provided" do
        it "returns nil" do
          expect(customer_record.dig(:user, :profile, :age)).to be(nil)
        end
      end

      context "when the keys is not present and a default value was provided" do
        it "return default value" do
          permissions[:role].default_proc = proc {
            { read: false, write: false }
          }

          expect(permissions.dig(:role, :unknown_role)).to eq({ read: false, write: false })
        end
      end
    end
  end
end
