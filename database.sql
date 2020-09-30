DROP TABLE EM_PHONE;

DROP TABLE SUPERVISORS;

DROP TABLE EMPLOYEES;

DROP TABLE PAYMENTS;

DROP TABLE RENTALS;

drop table movies;

drop table tapes;

DROP TABLE CUS_PHONE;

DROP TABLE CUSTOMERS;

DROP TABLE ST_PHONE;

DROP TABLE STORE;

DROP TABLE DISTRI_PHONE;

DROP TABLE DISTRIBUTOR;

-- *********************************************************

CREATE TABLE DISTRIBUTOR (DNAME VARCHAR(35) PRIMARY KEY,ADDRESS VARCHAR(50));

CREATE TABLE DISTRI_PHONE (DNAME VARCHAR(35),PHONE BIGINT);

ALTER TABLE DISTRI_PHONE ADD CONSTRAINT DIS_PHN_FK FOREIGN KEY (DNAME) REFERENCES DISTRIBUTOR(DNAME);

CREATE OR REPLACE PROCEDURE ADD_DISTRI (NAMED character varying ,ADDR character varying ,PH1 BIGINT)

LANGUAGE SQL

AS $$

INSERT INTO DISTRIBUTOR VALUES (NAMED, ADDR);
INSERT INTO DISTRI_PHONE VALUES (NAMED,PH1);
$$;

CALL ADD_DISTRI('Asha Ward','93735 Rodriguez Keys',1234567890);
CALL ADD_DISTRI('Ludie Hintz','151 Berta Brook',6689872617);
CALL ADD_DISTRI('Mallory Ryan','3627 McKenzie Crossing',12209743318752);
CALL ADD_DISTRI('Vivianne Barrows','705 Reinger Common',14450410220);
CALL ADD_DISTRI('Orie Macejkovic','994 Savion Garden',7379585550233);

CREATE OR REPLACE PROCEDURE DEL_DISTRI (NAMED character varying)
LANGUAGE SQL
AS $$

DELETE FROM DISTRI_PHONE WHERE DNAME = NAMED;
DELETE FROM DISTRIBUTOR WHERE DNAME = NAMED;
$$;

CREATE OR REPLACE PROCEDURE UPD_DISTRI (NAMED character varying,ADDR character varying ,PH1 BIGINT)
LANGUAGE SQL
AS $$

UPDATE DISTRIBUTOR SET ADDRESS = ADDR WHERE DNAME = NAMED;
UPDATE DISTRI_PHONE SET PHONE=PH1 WHERE DNAME = NAMED;
$$;

-- *********************************STORE ENTITY*************************


CREATE TABLE STORE (STORE_ID SMALLSERIAL PRIMARY KEY NOT NULL,SNAME VARCHAR(50),ADDRESS VARCHAR(50),DNAME VARCHAR(50));

CREATE TABLE ST_PHONE (STORE_ID SMALLSERIAL NOT NULL,PH BIGINT);

ALTER TABLE ST_PHONE ADD CONSTRAINT ST_PHN_FK FOREIGN KEY (STORE_ID) REFERENCES STORE(STORE_ID);

-- ********************************************************************

CREATE OR REPLACE PROCEDURE ADD_STORE (NAMES character varying ,ADDR IN STORE.ADDRESS%TYPE,NAMED IN STORE.DNAME%TYPE ,PH1 IN ST_PHONE.PH%TYPE)
language plpgsql    
as $$
declare
DIS DISTRIBUTOR.DNAME%TYPE;

BEGIN
SELECT DNAME FROM DISTRIBUTOR INTO DIS WHERE DNAME=NAMED;
IF FOUND THEN
INSERT INTO STORE (SNAME,ADDRESS,DNAME) VALUES (NAMES,ADDR,NAMED);
INSERT INTO ST_PHONE (PH) VALUES (PH1);
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;


CALL ADD_STORE('Monahan LLC','81408 Maryam Garden','Asha Ward',1-678-503-8003);
CALL ADD_STORE('Waters - Rippin','06314 Hoppe Light','Ludie Hintz',380-647-0797);
CALL ADD_STORE('Heathcote, Gutmann and Douglas','52142 Gusikowski Locks','Mallory Ryan',264-475-6846);
CALL ADD_STORE('Champlin - Muller','509 Kyler Center','Vivianne Barrows',9665194341390);
CALL ADD_STORE('Kiehn Group','8662 Heaney Mount','Orie Macejkovic',556-906-4284);

CREATE OR REPLACE PROCEDURE DEL_STORE (ID INTEGER)

LANGUAGE SQL

AS $$

DELETE FROM ST_PHONE WHERE STORE_ID=ID;
DELETE FROM STORE WHERE STORE_ID=ID;

$$;

CREATE OR REPLACE PROCEDURE UPD_STORE (ID INTEGER, NAMES character varying ,ADDR character varying,NAMED character varying ,PH1 BIGINT)
language plpgsql    
as $$
declare
DIS DISTRIBUTOR.DNAME%TYPE;

BEGIN
SELECT DNAME FROM DISTRIBUTOR INTO DIS WHERE DNAME=NAMED;
IF FOUND THEN
UPDATE STORE SET SNAME=NAMES,ADDRESS=ADDR,DNAME=NAMED WHERE STORE_ID=ID;
UPDATE ST_PHONE SET PH=PH1 WHERE STORE_ID=ID;ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;


-- ****************************EMPLOYEES ENTITY**********************************




CREATE TABLE EMPLOYEES (SIN INTEGER PRIMARY KEY NOT NULL,ENAME VARCHAR(35),ADDRESS VARCHAR(50),DOB VARCHAR(35),DOJ VARCHAR(35),STORE_ID SMALLINT,SALARY INTEGER, EMAIL VARCHAR(100) NOT NULL, PASSWORD VARCHAR(100) NOT NULL,UNIQUE (EMAIL));

ALTER TABLE EMPLOYEES ADD CONSTRAINT ST_EM_FK FOREIGN KEY (STORE_ID) REFERENCES STORE(STORE_ID);

CREATE TABLE EM_PHONE (SIN INTEGER NOT NULL,PH BIGINT);

ALTER TABLE EM_PHONE ADD CONSTRAINT EM_PHN_FK FOREIGN KEY (SIN) REFERENCES EMPLOYEES(SIN);

-- **************************************************************


CREATE OR REPLACE PROCEDURE ADD_EMP (SINE IN EMPLOYEES.SIN % TYPE,NAMEE IN EMPLOYEES.ENAME%TYPE,ADDR IN EMPLOYEES.ADDRESS%TYPE,BIR IN EMPLOYEES.DOB%TYPE,JOI IN EMPLOYEES.DOJ%TYPE,SID IN EMPLOYEES.STORE_ID%TYPE,SAL IN EMPLOYEES.SALARY%TYPE,EML IN EMPLOYEES.EMAIL%TYPE,PAS IN EMPLOYEES.PASSWORD%TYPE,PH1 IN EM_PHONE.PH%TYPE)
    
as $$
declare
EMP_SIN EMPLOYEES.SIN%TYPE;
SN STORE.SNAME%TYPE;
BEGIN
SELECT SIN FROM EMPLOYEES INTO EMP_SIN WHERE EMAIL=EML;
IF NOT FOUND THEN
SELECT SNAME FROM STORE INTO SN WHERE STORE_ID=SID;
IF FOUND THEN 
INSERT INTO EMPLOYEES VALUES (SINE,NAMEE,ADDR,BIR,JOI,SID,SAL,EML,PAS);
INSERT INTO EM_PHONE VALUES (SINE,PH1);
ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$
language plpgsql;


CALL ADD_EMP(1010::INTEGER,'Tarun'::VARCHAR,'VASHI'::VARCHAR,'1-23-12'::VARCHAR,'1-23-12'::VARCHAR,1::SMALLINT,5000000::INTEGER,'TarunSharma@gmail.com'::VARCHAR,'$2b$10$v58OEMwCo0n2vEXrUOwS7OBuFKE69Y0YXRBBAUsGDiSiupZukmvia'::VARCHAR,9022747122::BIGINT);



-- *************************************************************

CREATE OR REPLACE PROCEDURE DEL_EMP (SINE INTEGER)

LANGUAGE SQL

AS $$

DELETE FROM EM_PHONE WHERE SIN=SINE;
DELETE FROM EMPLOYEES WHERE SIN=SINE;

$$;

-- **************************************************



CREATE OR REPLACE PROCEDURE UPD_EMP(SINE INTEGER,NAMEE character varying,ADDR character varying,BIR character varying,JOI character varying,SID SMALLINT,SAL INTEGER,EML character varying,PAS character varying,PH1 BIGINT)
language plpgsql    
as $$
declare
EMP_SIN EMPLOYEES.SIN%TYPE;
SN STORE.SNAME%TYPE;
BEGIN
SELECT SIN FROM EMPLOYEES INTO EMP_SIN WHERE EMAIL=EML;
IF NOT FOUND THEN
SELECT SNAME FROM STORE INTO SN WHERE STORE_ID=SID;
IF FOUND THEN 
UPDATE EMPLOYEES SET ENAME=NAMEE,ADDRESS=ADDR,DOB=BIR,DOJ=JOI,STORE_ID=SID,SALARY=SAL,EMAIL=EML,PASSWORD=PAS WHERE SIN=SINE;
UPDATE EM_PHONE SET PH=PH1 WHERE SIN=SINE;
ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;







-- password = Password

CREATE TABLE SUPERVISORS( SIN INTEGER PRIMARY KEY NOT NULL);
ALTER TABLE SUPERVISORS ADD CONSTRAINT SUP_FK FOREIGN KEY (SIN) REFERENCES EMPLOYEES(SIN);


CREATE OR REPLACE PROCEDURE ADD_SUPVIS(EML character varying)
language plpgsql    
as $$
declare
EMP_SIN EMPLOYEES.SIN%TYPE;
BEGIN
SELECT SIN FROM EMPLOYEES INTO EMP_SIN WHERE EMAIL=EML;
IF FOUND THEN
INSERT INTO SUPERVISORS (SIN) VALUES (EMP_SIN);
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;

CALL ADD_SUPVIS('TarunSharma@gmail.com');

CREATE OR REPLACE PROCEDURE DEL_SUPVIS(SINE integer)
language sql    
as $$

DELETE FROM SUPERVISORS WHERE (SIN)=(SINE);

$$;

-- *************************CUSTOMER ENTITY*************************************




CREATE TABLE CUSTOMERS (CUS_ID SMALLSERIAL PRIMARY KEY NOT NULL,CNAME VARCHAR(35),ADDRESS VARCHAR(50),STORE_ID INTEGER);

CREATE TABLE CUS_PHONE (CUS_ID SMALLSERIAL NOT NULL,PH BIGINT);

ALTER TABLE CUSTOMERS ADD CONSTRAINT ST_CU_FK FOREIGN KEY (STORE_ID) REFERENCES STORE(STORE_ID);

ALTER TABLE CUS_PHONE ADD CONSTRAINT CUS_PHN_FK FOREIGN KEY (CUS_ID) REFERENCES CUSTOMERS(CUS_ID);

-- **************************************************************

CREATE OR REPLACE PROCEDURE ADD_CUS (NAMEC character varying,STD INTEGER,ADDR character varying,PH1 IN CUS_PHONE.PH%TYPE)

language plpgsql    
as $$
declare

STRNA STORE.SNAME%TYPE;
BEGIN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=STD;
IF FOUND THEN
INSERT INTO CUSTOMERS (CNAME,ADDRESS,STORE_ID) VALUES (NAMEC,ADDR,STD);
INSERT INTO CUS_PHONE (PH) VALUES (PH1);
ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
END;
$$;

CALL ADD_CUS ('Ora Bernhard',1,'518 Grimes Grove',9022747122);
CALL ADD_CUS ('Norma Streich',5,'3129 Norwood Garden',9022747122);
CALL ADD_CUS ('Miss Antwon Welch',2,'126 Homenick Field',9022747122);
CALL ADD_CUS ('Gayle Predovic',3,'321 Quigley Prairie',9022747122);
CALL ADD_CUS ('Leanna Glover',4,'96802 Bailey Summit',9022747122);

CALL ADD_CUS ('Paul Beier',1,'518 Grimes Grove',9022747122);
CALL ADD_CUS ('Kay Olson',5,'3129 Norwood Garden',9022747122);
CALL ADD_CUS ('Mr. Dolores Volkman',2,'126 Homenick Field',9022747122);
CALL ADD_CUS ('Anissa Schumm',4,'321 Quigley Prairie',9022747122);
CALL ADD_CUS ('Draco Malfoy',3,'96802 Bailey Summit',9022747122);

CREATE OR REPLACE PROCEDURE DEL_CUS (ID integer)

LANGUAGE SQL

AS $$

DELETE FROM CUS_PHONE WHERE CUS_ID=ID;
DELETE FROM CUSTOMERS WHERE CUS_ID=ID;

$$;

CREATE OR REPLACE PROCEDURE UPD_CUS (ID INTEGER,NAMEC character varying,STD INTEGER,ADDR character varying,PH1 IN CUS_PHONE.PH%TYPE)

language plpgsql    
as $$
declare

STRNA STORE.SNAME%TYPE;
BEGIN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=STD;
IF FOUND THEN

UPDATE CUSTOMERS SET CNAME=NAMEC,ADDRESS=ADDR,STORE_ID=STD WHERE CUS_ID=ID;
UPDATE CUS_PHONE SET PH=PH1 WHERE CUS_ID=ID;
ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
END;
$$;

-- ***********************TAPE ENTITY********************************


CREATE TABLE TAPES(TAPE_ID SMALLSERIAL PRIMARY KEY NOT NULL,STOCK SMALLINT,PRICE SMALLINT,STORE_ID SMALLINT);
CREATE TABLE MOVIES(TAPE_ID SMALLSERIAL NOT NULL,TITLE VARCHAR(50),DIRECTOR VARCHAR(50),DESCRIPTION VARCHAR(50),GENRE VARCHAR(10),RATING SMALLINT,NOS VARCHAR(50));

ALTER TABLE TAPES ADD CONSTRAINT ST_TP_FK FOREIGN KEY (STORE_ID) REFERENCES STORE(STORE_ID);

ALTER TABLE MOVIES ADD CONSTRAINT MOVIE_FK FOREIGN KEY (TAPE_ID) REFERENCES TAPES(TAPE_ID);



CREATE OR REPLACE PROCEDURE ADD_TAPE (STK integer,PR integer,SID integer,TIT character varying,DIR character varying,DES character varying,GEN character varying,RAT integer,STR character varying)

language plpgsql    
as $$
declare

STRNA STORE.SNAME%TYPE;

BEGIN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=SID;
IF FOUND THEN
INSERT INTO TAPES (STOCK,PRICE,STORE_ID) VALUES (STK,PR,SID);
INSERT INTO MOVIES (TITLE,DIRECTOR,DESCRIPTION,GENRE,RATING,NOS) VALUES (TIT,DIR,DES,GEN,RAT,STR);
ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
END;
$$;

CALL ADD_TAPE (100,399,1,'Harry Potter and the Sorcerers Stone','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Daniel Jacob Radcliffe');
CALL ADD_TAPE (100,399,5,'Harry Potter and the Chamber of Secrets','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Emma Watson');
CALL ADD_TAPE (100,399,2,'Harry Potter and the Prisoner of Azkaban ','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Rupert Grint');
CALL ADD_TAPE (100,399,4,'Harry Potter and the Goblet of Fire','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Richard Harris');
CALL ADD_TAPE (100,399,3,'Harry Potter and the Order of the Phoenix','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Maggie Smith');
CALL ADD_TAPE (100,399,2,'Harry Potter and the Half-Blood Prince','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Robbie Coltrane');
CALL ADD_TAPE (100,399,1,'Harry Potter and the Deathly Hallows: Part 1','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Alan Rickman');
CALL ADD_TAPE (100,399,1,'Harry Potter and the Deathly Hallows: Part 2','Chris Columbus','A Boy who became a wizard','Fantasy',10,'Ralph Fiennes');



-- **********************************************************

CREATE OR REPLACE PROCEDURE DEL_TAPE (TPID integer)

LANGUAGE SQL

AS $$

DELETE FROM MOVIES WHERE TAPE_ID=TPID;
DELETE FROM TAPES WHERE TAPE_ID=TPID;

$$;



-- ************************************************************

CREATE OR REPLACE PROCEDURE UPD_TAPE (TPID integer,STK integer,PR integer,SID integer,TIT character varying,DIR character varying,DES character varying,GEN character varying,RAT integer,STR character varying)

language plpgsql    
as $$
declare

STRNA STORE.SNAME%TYPE;

BEGIN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=SID;
IF FOUND THEN

UPDATE TAPES SET STOCK=STK,PRICE=PR,STORE_ID=SID WHERE TAPE_ID = TPID;
UPDATE MOVIES SET TITLE=TIT,DIRECTOR=DIR,GENRE=GEN,RATING=RAT,NOS=STR WHERE TAPE_ID = TPID;

ELSE
RAISE NOTICE 'STORE NOT FOUND';
END IF;
END;
$$;


-- *****************************RENTAL ENTITY**************************************


CREATE TABLE RENTALS(RENTAL_ID SMALLSERIAL PRIMARY KEY,TAPE_ID INTEGER,STATUS VARCHAR(20),CUS_ID INTEGER,SIN INTEGER,STORE_ID INTEGER,RENTON TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);

ALTER TABLE RENTALS ADD CONSTRAINT ST_REN_FK FOREIGN KEY (STORE_ID) REFERENCES STORE(STORE_ID);

-- ******************************************************************

CREATE OR REPLACE PROCEDURE ADD_RENTAL(TPID INTEGER,STA character varying,CID INTEGER,EID INTEGER,STRID INTEGER)

language plpgsql    
as $$
declare
EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
RECN CUSTOMERS.CNAME%TYPE;
STRNA STORE.SNAME%TYPE;
TPPR TAPES.PRICE%TYPE;
BEGIN
SELECT EMAIL FROM EMPLOYEES INTO EMP_EMAIL WHERE SIN=EID;
IF FOUND THEN
SELECT CNAME FROM CUSTOMERS INTO RECN WHERE CUS_ID=CID;
IF FOUND THEN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=STRID;
IF FOUND THEN
SELECT PRICE FROM TAPES INTO TPPR WHERE TAPE_ID=TPID;
IF FOUND THEN
INSERT INTO RENTALS(TAPE_ID,STATUS,CUS_ID,SIN,STORE_ID) VALUES (TPID,STA,CID,EID,STRID);
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;



-- CALL ADD_RENTAL(8,'PENDING',5,1010,1);
-- CALL ADD_RENTAL(2,'PENDING',7,1010,4);
-- CALL ADD_RENTAL(4,'PENDING',2,1010,2);
-- CALL ADD_RENTAL(5,'PENDING',10,1010,5);
-- CALL ADD_RENTAL(1,'PENDING',6,1010,3);
-- CALL ADD_RENTAL(3,'PENDING',8,1010,2);
-- CALL ADD_RENTAL(6,'PENDING',4,1010,5);
-- CALL ADD_RENTAL(7,'PENDING',3,1010,4);

-- ********************************************************

CREATE OR REPLACE PROCEDURE UPD_RENTAL(RENTID INTEGER,TPID INTEGER,STA character varying,CID INTEGER,EID INTEGER,STRID INTEGER)

language plpgsql    
as $$
declare
EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
RECN CUSTOMERS.CNAME%TYPE;
STRNA STORE.SNAME%TYPE;
TPPR TAPES.PRICE%TYPE;
BEGIN
SELECT EMAIL FROM EMPLOYEES INTO EMP_EMAIL WHERE SIN=EID;
IF FOUND THEN
SELECT CNAME FROM CUSTOMERS INTO RECN WHERE CUS_ID=CID;
IF FOUND THEN
SELECT SNAME FROM STORE INTO STRNA WHERE STORE_ID=STRID;
IF FOUND THEN
SELECT PRICE FROM TAPES INTO TPPR WHERE TAPE_ID=TPID;
IF FOUND THEN
UPDATE RENTALS SET TAPE_ID=TPID,CUS_ID=CID,SIN=EID,STORE_ID=STRID,RENTON= CURRENT_TIMESTAMP WHERE RENTAL_ID=RENTID;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF; 
END;
$$;





-- ************************************************************

CREATE OR REPLACE PROCEDURE DEL_RENTAL(RID INTEGER)

LANGUAGE SQL

AS $$

DELETE FROM RENTALS WHERE RENTAL_ID=RID;

$$;


-- *******************************************PAYMENTS ENTITY*******************************

CREATE TABLE PAYMENTS(RENTAL_ID INTEGER,SIN INTEGER,FINAL_COST INTEGER,STATUS VARCHAR(20),TYPE VARCHAR(20),DETAIL INTEGER,PAYON TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP);

ALTER TABLE PAYMENTS ADD CONSTRAINT REN_PAY_FK FOREIGN KEY (RENTAL_ID) REFERENCES RENTALS(RENTAL_ID);


-- *************************

CREATE OR REPLACE PROCEDURE ADD_PAY(RENID INTEGER,EID INTEGER,FCOST INTEGER,STA character varying,PTYP character varying,DEET INTEGER)

language plpgsql    
as $$
declare
EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
EMP_SIN EMPLOYEES.SIN%TYPE;
BEGIN
SELECT EMAIL FROM EMPLOYEES INTO EMP_EMAIL WHERE SIN=EID;
IF FOUND THEN
SELECT SIN FROM PAYMENTS INTO EMP_SIN WHERE RENTAL_ID=RENID;
IF NOT FOUND THEN 
INSERT INTO PAYMENTS (RENTAL_ID,SIN,FINAL_COST,STATUS,TYPE,DETAIL) VALUES (RENID,EID,FCOST,STA,PTYP,DEET);
ELSE
RAISE NOTICE 'PAYMENT ALREADY DONE';
END IF;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
END;
$$;


-- ******************************

CREATE OR REPLACE PROCEDURE UPD_PAY(RENID INTEGER,EID INTEGER,FCOST INTEGER,STA character varying,PTYP character varying,DEET INTEGER)

language plpgsql    
as $$
declare
EMP_EMAIL EMPLOYEES.EMAIL%TYPE;
BEGIN
SELECT EMAIL FROM EMPLOYEES INTO EMP_EMAIL WHERE SIN=EID;
IF FOUND THEN
UPDATE PAYMENTS SET SIN=EID,FINAL_COST=FCOST,STATUS=STA,TYPE=PTYP,DETAIL=DEET,PAYON=CURRENT_TIMESTAMP WHERE RENTAL_ID=RENID;
ELSE
RAISE NOTICE 'EMPLOYEE NOT FOUND';
END IF;
END;
$$;

-- ****************************** TRIGGER******************
CREATE OR REPLACE FUNCTION status_change()
  RETURNS TRIGGER 
  LANGUAGE PLPGSQL  
  AS
$$
BEGIN
	UPDATE RENTALS SET STATUS = 'COMPLETED' WHERE RENTALS.RENTAL_ID=OLD.RENTAL_ID;
  
	RETURN NEW;
END;
$$;

CREATE TRIGGER change_rent_status
  AFTER INSERT
  ON PAYMENTS
  FOR EACH ROW
  EXECUTE PROCEDURE status_change();


CALL ADD_RENTAL(8,'PENDING',5,1010,1);
CALL ADD_RENTAL(2,'PENDING',7,1010,4);
CALL ADD_RENTAL(4,'PENDING',2,1010,2);
CALL ADD_RENTAL(5,'PENDING',10,1010,5);
CALL ADD_RENTAL(1,'PENDING',6,1010,3);
CALL ADD_RENTAL(3,'PENDING',8,1010,2);
CALL ADD_RENTAL(6,'PENDING',4,1010,5);
CALL ADD_RENTAL(7,'PENDING',3,1010,4);


CALL ADD_PAY(1,1010,990,'PENDING','CASH',0);
