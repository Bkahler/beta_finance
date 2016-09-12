class Stock < ActiveRecord::Base

  def self.find_by_ticker(ticker)
    where(ticker: ticker).first
  end

  def self.new_from_lookup(ticker)
    lookup_stock = StockQuote::Stock.quote(ticker)
    return nil unless lookup_stock.name

    new_stock = new(ticker: lookup_stock.symbol, name: lookup_stock.name)
    new_stock.last_price = new_stock.price
    new_stock
  end

  def price
    closing_price = StockQuote::Stock.quote(ticker).close
    return "#{closing_price} (Closing)" if closing_price

    opening_price = StockQuote::Stock.quote(ticker).open
    return "#{opening_price} (Opening)" if opening_price
  end

end
