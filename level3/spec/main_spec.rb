require './main.rb'

RSpec.configure do |config|
  config.before(:all) do
    Car.class_variable_set :@@cars, []
    Rental.class_variable_set :@@rentals, []
  end
  config.after(:all) do
    File.delete('data/output_test.json') if File.exist? 'data/output_test.json'
  end
end

describe Car do
  context "Create Car" do
    subject(:car) { Car.create car_params }
    let(:car_params) { { 'id' => 1, 'price_per_km' => 10, 'price_per_day' => 2000 } }

    it 'should be created' do
      expect(car.id).to eq(1)
      expect(car.price_per_km).to eq(10)
      expect(car.price_per_day).to eq(2000)
    end

    it 'should update the collection' do
      expect{ car }.to change(Car.all, :count).by(1)
    end

    it 'should be found by find method' do
      car
      expect(Car.find('XX')).to be(nil)
    end

    it 'should be found by find method' do
      car
      expect(Car.find(1)).to be_a_kind_of(Car)
    end
  end
end

describe Rental do
  context "Create rental" do
    before(:all) do
      @car = Car.create({ 'id' => 1, 'price_per_km' => 10, 'price_per_day' => 2000 })
    end

    subject(:rental) { Rental.create rental_params }
    let(:rental_params) { { 'id' => 1, 'car_id' => 1, 'start_date' => '2022-01-20', 'end_date' => '2022-01-21', 'distance' => 10 } }

    it 'should be created' do
      expect(rental.id).to eq(1)
      expect(rental.car.id).to eq(@car.id)
      expect(rental.start_date).to eq(Date.new(2022, 01, 20))
      expect(rental.end_date).to eq(Date.new(2022, 01, 21))
      expect(rental.distance).to eq(10)
    end

    it 'should update the collection' do
      expect{ rental }.to change(Rental.all, :count).by(1)
    end
    context 'when the car is rented for 2 days' do
      it 'should have a correct price' do
        expect(rental.price).to eq(3900)
      end
      it 'should have correct commisions' do
        expect(rental.commission).to eq(1170)
        expect(rental.insurance_fee).to eq(585)
        expect(rental.assistance_fee).to eq(200)
        expect(rental.internal_commision).to eq(385)
      end
    end
    context 'when the car is rented for 12 days' do
      let(:rental_params) { { 'id' => 1, 'car_id' => 1, 'start_date' => '2022-01-20', 'end_date' => '2022-01-31', 'distance' => 10 } }
      it 'should have a correct price' do
        expect(rental.price).to eq(17900)
      end
      it 'should have correct commisions' do
        expect(rental.commission).to eq(5370)
        expect(rental.insurance_fee).to eq(2685)
        expect(rental.assistance_fee).to eq(1200)
        expect(rental.internal_commision).to eq(1485)
      end
    end
  end
end

describe RentalService do
  let(:output_file) { 'output_test.json' }
  let(:input_file) { 'input.json' }
  context 'import file' do
    subject(:rental_import) { RentalService.import_file input_file }

    it 'should import data' do
      expect{ rental_import }.to change(Car.all, :count).by(1)
      expect(Car.all.last&.id).to eq(1)
      expect(Rental.all.last&.id).to eq(3)
      expect(Rental.all.last&.car.id).to eq(1)
    end
  end

  context 'export file' do
    before do
      RentalService.import_file('input.json')
    end
    subject(:rental_export) { RentalService.export_file output_file }

    it 'should export data to output file' do
      rental_export
      expect(File.exists? "data/output_test.json").to be(true)
    end
  end
end

describe "Main" do
  context 'Executing main' do
    subject(:output_data) do
      RentalService.import_file 'input.json'
      RentalService.export_file 'output.json'
      input = File.read("data/output.json")
      JSON.parse(input)
    end
    let(:expected_output_data) {
      input = File.read("data/expected_output.json")
      JSON.parse(input)
    }
    it 'should have the same output than the expected output' do
      expect(output_data).to eq(expected_output_data)
    end
  end
end
