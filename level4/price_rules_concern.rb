module PriceRulesConcern
  def price_per_day
    price = super

    nb_days = ((@end_date - @start_date) + 1)
    
    if nb_days > 1
      nb_days_discounted = [nb_days, 4].min - 1
      price -= @car.price_per_day * nb_days_discounted * 0.1
    end
    if nb_days > 4
      nb_days_discounted = [nb_days, 10].min - 4
      price -= @car.price_per_day * nb_days_discounted * 0.3
    end
    if nb_days > 10
      nb_days_discounted = nb_days - 10
      price -= @car.price_per_day * nb_days_discounted * 0.5
    end

    price
  end
end
