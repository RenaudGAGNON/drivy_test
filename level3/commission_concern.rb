module CommissionConcern
  def commission
    (price * 0.3).to_i
  end

  def insurance_fee
    (commission * 0.5).to_i
  end

  def assistance_fee
    (((@end_date - @start_date) + 1) * 100).to_i
  end

  def internal_commision
    commission - insurance_fee - assistance_fee
  end
end
