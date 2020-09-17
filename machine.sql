CREATE TABLE machine(
    ip INTEGER, 
    hostname CHAR(50), 
    os CHAR(100), 
    PRIMARY KEY(ip));	

CREATE TABLE events(
	a_ip INTEGER, 
	v_ip INTEGER, 
	dates DATE, 
	FOREIGN KEY a_ip REFERENCES machine(ip),
	FOREIGN KEY v_ip REFERENCES machine(ip),
	PRIMARY KEY(a_ip,v_ip,dates));
		    
SELECT os
FROM machine, events
WHERE events. a_ip= machine.ip AND 
hostname=’aramis.rutgers.edu’ IN (SELECT hostname FROM events WHERE events.v_ip= machine.ip); 
		    
CREATE TABLE STOCK(
	Ticker CHAR(10), 
	Exchange CHAR(10), 
	PRIMARY KEY(Ticker));

CREATE TABLE Price(
	Ticker CHAR(10),
	dates DATE, 
	closes INTEGER, 
    	PRIMARY KEY(Ticker,dates));
		    
SELECT Tickers, closes
FROM STOCK,Price
WHERE Exchange=’NASDAQ’ AND dates=’1/19/2016’;
SELECT ip, hostname
FROM Machine
WHERE os=’Windows’;
		    
SELECT hostname
	FROM machine, events
	WHERE machine.ip= events.v_ip AND events.date= ‘03/07/2016’;
		    
CREATE TABLE STOCK(
	Ticker CHAR(10), 
	Exchange CHAR(10), 
	PRIMARY KEY(Ticker));

CREATE TABLE Price(
	Ticker CHAR(10),
	dates DATE, 
	closes INTEGER, 
    	PRIMARY KEY(Ticker,dates));

	SELECT Tickers
FROM STOCK
WHERE P.date=’1/20/2016’  AND P.close>IBM.close; 


