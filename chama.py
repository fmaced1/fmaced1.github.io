import yfinance as yf

ticker = "VALE3.SA"
period = "1y"
interval = "1wk"

historical_data = yf.Ticker(ticker).history(period, interval, actions=False).dropna()

print(historical_data.head())