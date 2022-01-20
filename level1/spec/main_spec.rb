require './main.rb'

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

    it 'should have a correct price' do
      expect(rental.price).to eq(4100)
    end
  end
end
