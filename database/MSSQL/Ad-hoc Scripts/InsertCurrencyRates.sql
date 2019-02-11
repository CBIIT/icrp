-- Insert currency rates

insert into CurrencyRate values(NULL, 'AUD', 1, 'USD', 0.705919, 2018, getdate(), getdate())
insert into CurrencyRate values(NULL, 'CAD', 1, 'USD', 0.733739, 2018, getdate(), getdate())
insert into CurrencyRate values(NULL, 'EUR', 1, 'USD', 1.145, 2018, getdate(), getdate())
insert into CurrencyRate values(NULL, 'GBP', 1, 'USD', 1.280002, 2018, getdate(), getdate())
insert into CurrencyRate values(NULL, 'JPY', 1, 'USD', 0.009098, 2018, getdate(), getdate())


select top 10 * from CurrencyRate order by CurrencyRateID desc
