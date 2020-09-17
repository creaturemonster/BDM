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
