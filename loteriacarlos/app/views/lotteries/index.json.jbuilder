json.array!(@lotteries) do |lottery|
  json.extract! lottery, :id, :email, :contraseña, :usuario, :luckynumber, :genero
  json.url lottery_url(lottery, format: :json)
end
