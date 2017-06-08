-- Insert currency rates

insert into CurrencyRate values(NULL, 'AUD', 1, 'USD', 0.714285714285714, 2016, getdate(), getdate())
insert into CurrencyRate values(NULL, 'CAD', 1, 'USD', 0.725163161711385, 2016, getdate(), getdate())
insert into CurrencyRate values(NULL, 'EUR', 1, 'USD', 1.06382978723404, 2016, getdate(), getdate())
insert into CurrencyRate values(NULL, 'GBP', 1, 'USD', 1.2987012987013, 2016, getdate(), getdate())
insert into CurrencyRate values(NULL, 'JPY', 1, 'USD', 0.00883876328024183, 2016, getdate(), getdate())


select top 10 * from CurrencyRate order by CurrencyRateID desc
