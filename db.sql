SET SERVEROUTPUT ON;

/* MAIN TABLES  */

CREATE TABLE z_country(
    country_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100)
);
/

CREATE TABLE z_region(
    region_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100),
    country_id NUMBER, CONSTRAINT FK_region_country FOREIGN KEY (country_id) REFERENCES z_country(country_id) ON DELETE CASCADE
);
/

CREATE TABLE z_city(
    city_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100),
    region_id NUMBER, CONSTRAINT FK_city_region FOREIGN KEY (region_id) REFERENCES z_region(region_id) ON DELETE CASCADE
);
/

CREATE TABLE z_weather(
    weather_id NUMBER PRIMARY KEY,
    city_id NUMBER, CONSTRAINT FK_wf_city FOREIGN KEY (city_id) REFERENCES z_city(city_id) ON DELETE CASCADE,
    datetime DATE,
    tempmax NUMBER,
    tempmin NUMBER,
    temp NUMBER,
    feelslikemax NUMBER,
    feelslikemin NUMBER,
    feelslike NUMBER,
    dew NUMBER,
    humidity NUMBER,
    precip NUMBER,
    precipcover NUMBER,
    preciptype VARCHAR2(50),
    snow NUMBER,
    snowdepth NUMBER,
    windgust NUMBER,
    windspeed NUMBER,
    winddir NUMBER,
    sealevelpressure NUMBER,
    cloudcover NUMBER,
    visibility NUMBER
);
/

CREATE TABLE z_astrology(
    astrology_id NUMBER PRIMARY KEY, 
    weather_id NUMBER, CONSTRAINT FK_astrology_weather FOREIGN KEY (weather_id) REFERENCES z_weather(weather_id) ON DELETE CASCADE,
    sunrise TIMESTAMP,
    sunset TIMESTAMP,
    moonphase NUMBER
);
/

CREATE TABLE z_desc(
    desc_id NUMBER PRIMARY KEY, 
    weather_id NUMBER, CONSTRAINT FK_desc_weather FOREIGN KEY (weather_id) REFERENCES z_weather(weather_id) ON DELETE CASCADE,
    conditions VARCHAR(100),
    description VARCHAR(500)
);
/

CREATE SEQUENCE z_country_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_country_auto_increment
BEFORE INSERT ON z_country FOR EACH ROW
BEGIN
    SELECT z_country_seq.NEXTVAL INTO :NEW.country_id FROM DUAL;
END;
/

CREATE SEQUENCE z_region_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_region_auto_increment
BEFORE INSERT ON z_region FOR EACH ROW
BEGIN
    SELECT z_region_seq.NEXTVAL INTO :NEW.region_id FROM DUAL;
END;
/

CREATE SEQUENCE z_city_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_city_auto_increment
BEFORE INSERT ON z_city FOR EACH ROW
BEGIN
    SELECT z_city_seq.NEXTVAL INTO :NEW.city_id FROM DUAL;
END;
/

CREATE SEQUENCE z_weather_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_weather_auto_increment
BEFORE INSERT ON z_weather FOR EACH ROW
BEGIN
    SELECT z_weather_seq.NEXTVAL INTO :NEW.weather_id FROM DUAL;
END;
/

CREATE SEQUENCE z_astrology_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_astrology_auto_increment
BEFORE INSERT ON z_astrology FOR EACH ROW
BEGIN
    SELECT z_astrology_seq.NEXTVAL INTO :NEW.astrology_id FROM DUAL;
END;
/

CREATE SEQUENCE z_desc_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_desc_auto_increment
BEFORE INSERT ON z_desc FOR EACH ROW
BEGIN
    SELECT z_desc_seq.NEXTVAL INTO :NEW.desc_id FROM DUAL;
END;
/

/* ARCHIVE TABLES */

CREATE TABLE z_country_archive(
    country_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100)
);
/

CREATE TABLE z_region_archive(
    region_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100),
    country_id NUMBER, CONSTRAINT FK_region_country_archive FOREIGN KEY (country_id) REFERENCES z_country_archive(country_id) ON DELETE CASCADE
);
/

CREATE TABLE z_city_archive(
    city_id NUMBER PRIMARY KEY, 
    name VARCHAR2(100),
    region_id NUMBER, CONSTRAINT FK_city_region_archive FOREIGN KEY (region_id) REFERENCES z_region_archive(region_id) ON DELETE CASCADE
);
/

CREATE TABLE z_weather_archive(
    weather_id NUMBER PRIMARY KEY,
    city_id NUMBER, CONSTRAINT FK_wf_city_archive FOREIGN KEY (city_id) REFERENCES z_city_archive(city_id) ON DELETE CASCADE,
    datetime DATE,
    tempmax NUMBER,
    tempmin NUMBER,
    temp NUMBER,
    feelslikemax NUMBER,
    feelslikemin NUMBER,
    feelslike NUMBER,
    dew NUMBER,
    humidity NUMBER,
    precip NUMBER,
    precipcover NUMBER,
    preciptype VARCHAR2(50),
    snow NUMBER,
    snowdepth NUMBER,
    windgust NUMBER,
    windspeed NUMBER,
    winddir NUMBER,
    sealevelpressure NUMBER,
    cloudcover NUMBER,
    visibility NUMBER
);
/

CREATE TABLE z_astrology_archive(
    astrology_id NUMBER PRIMARY KEY, 
    weather_id NUMBER, CONSTRAINT FK_astrology_weather_archive FOREIGN KEY (weather_id) REFERENCES z_weather_archive(weather_id) ON DELETE CASCADE,
    sunrise TIMESTAMP,
    sunset TIMESTAMP,
    moonphase NUMBER
);
/

CREATE TABLE z_desc_archive(
    desc_id NUMBER PRIMARY KEY, 
    weather_id NUMBER, CONSTRAINT FK_desc_weather_archive FOREIGN KEY (weather_id) REFERENCES z_weather_archive(weather_id) ON DELETE CASCADE,
    conditions VARCHAR(100),
    description VARCHAR(500)
);


/* MAIN TABLES ON DELETE TRIGERS*/

CREATE OR REPLACE TRIGGER z_archive_country
BEFORE DELETE ON z_country
FOR EACH ROW
BEGIN
  INSERT INTO z_country_archive (country_id, name)
  VALUES (:OLD.country_id, :OLD.name);
END;
/

CREATE OR REPLACE TRIGGER z_archive_region
BEFORE DELETE ON z_region
FOR EACH ROW
BEGIN
  INSERT INTO z_region_archive (region_id, name, country_id)
  VALUES (:OLD.region_id, :OLD.name, :OLD.country_id);
END;
/

CREATE OR REPLACE TRIGGER z_archive_city
BEFORE DELETE ON z_city
FOR EACH ROW
BEGIN
  INSERT INTO z_city_archive (city_id, name, region_id)
  VALUES (:OLD.city_id, :OLD.name, :OLD.region_id);
END;
/

CREATE OR REPLACE TRIGGER z_archive_weather
BEFORE DELETE ON z_weather
FOR EACH ROW
BEGIN
  INSERT INTO z_weather_archive (weather_id, city_id, datetime, 
  tempmax, tempmin, temp, feelslikemax, feelslikemin, feelslike, dew, humidity,
  precip, precipcover, preciptype, snow, snowdepth, windgust, windspeed, winddir,
  sealevelpressure, cloudcover, visibility)
  VALUES (:OLD.weather_id, :OLD.city_id, :OLD.datetime, :OLD.tempmax, :OLD.tempmin,
  :OLD.temp, :OLD.feelslikemax, :OLD.feelslikemin, :OLD.feelslike, :OLD.dew, 
  :OLD.humidity, :OLD.precip, :OLD.precipcover, :OLD.preciptype, :OLD.snow, 
  :OLD.snowdepth, :OLD.windgust, :OLD.windspeed, :OLD.winddir, :OLD.sealevelpressure, 
  :OLD.cloudcover, :OLD.visibility);
END;
/

CREATE OR REPLACE TRIGGER z_archive_astrology
BEFORE DELETE ON z_astrology
FOR EACH ROW
BEGIN
  INSERT INTO z_astrology_archive (astrology_id, weather_id, sunrise, sunset, moonphase)
  VALUES (:OLD.astrology_id, :OLD.weather_id, :OLD.sunrise, :OLD.sunset, :OLD.moonphase);
END;
/

CREATE OR REPLACE TRIGGER z_archive_desc
BEFORE DELETE ON z_desc
FOR EACH ROW
BEGIN
  INSERT INTO z_desc_archive (desc_id, weather_id, conditions, description)
  VALUES (:OLD.desc_id, :OLD.weather_id, :OLD.conditions, :OLD.description);
END;
/

/* LOG TABLE */

CREATE TABLE z_log(
    log_id NUMBER PRIMARY KEY,
    log_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    log_module VARCHAR2(100),
    log_action VARCHAR2(100),
    log_message VARCHAR2(500)
);
/

CREATE SEQUENCE z_log_seq START WITH 1 INCREMENT BY 1;
CREATE OR REPLACE TRIGGER z_log_auto_increment
BEFORE INSERT ON z_log FOR EACH ROW
BEGIN
    SELECT z_log_seq.NEXTVAL INTO :NEW.log_id FROM DUAL;
END;
/

/* ADD ROW PROCEDURES */

CREATE OR REPLACE PROCEDURE z_add_country (
    p_name VARCHAR2,
    p_country_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid country name format');
    END IF;

    INSERT INTO z_country (name) VALUES (p_name) RETURNING country_id INTO p_country_id;

    v_log_module := 'z_add_country';
    v_log_action := 'INSERT';
    v_log_message := 'Country added: ' || p_name || ', Country ID: ' || p_country_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        v_log_module := 'z_add_country';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding country: ' || p_name || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_add_region (
    p_name VARCHAR2,
    p_country_id NUMBER,
    p_region_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid region name format');
    END IF;
    
    DECLARE
        v_country_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_country_count FROM z_country WHERE country_id = p_country_id;

        IF v_country_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid country_id. Country does not exist.');
        END IF;
    END;

    INSERT INTO z_region (name, country_id) VALUES (p_name, p_country_id) RETURNING region_id INTO p_region_id;
    
    v_log_module := 'z_add_region';
    v_log_action := 'INSERT';
    v_log_message := 'Region added: ' || p_name || ', Region ID: ' || p_region_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_module := 'z_add_region';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding region: ' || p_name || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_add_city (
    p_name VARCHAR2,
    p_region_id NUMBER,
    p_city_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid city name format');
    END IF;
    
    DECLARE
        v_region_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_region_count FROM z_region WHERE region_id = p_region_id;

        IF v_region_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid region_id. Region does not exist.');
        END IF;
    END;

    INSERT INTO z_city (name, region_id) VALUES (p_name, p_region_id) RETURNING city_id INTO p_city_id;
    
    v_log_module := 'z_add_city';
    v_log_action := 'INSERT';
    v_log_message := 'City added: ' || p_name || ', City ID: ' || p_city_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_module := 'z_add_city';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding city: ' || p_name || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_add_weather (
    p_city_id NUMBER,
    p_datetime DATE,
    p_tempmax NUMBER,
    p_tempmin NUMBER,
    p_temp NUMBER,
    p_feelslikemax NUMBER,
    p_feelslikemin NUMBER,
    p_feelslike NUMBER,
    p_dew NUMBER,
    p_humidity NUMBER,
    p_precip NUMBER,
    p_precipcover NUMBER,
    p_preciptype VARCHAR2,
    p_snow NUMBER,
    p_snowdepth NUMBER,
    p_windgust NUMBER,
    p_windspeed NUMBER,
    p_winddir NUMBER,
    p_sealevelpressure NUMBER,
    p_cloudcover NUMBER,
    p_visibility NUMBER,
    p_weather_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    
    DECLARE
        v_city_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_city_count FROM z_city WHERE city_id = p_city_id;

        IF v_city_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid city_id. City does not exist.');
        END IF;
    END;
    
    BEGIN
        IF TO_DATE(p_datetime, 'YYYY-MM-DD') IS NULL THEN
            RAISE_APPLICATION_ERROR(-20003, 'Invalid date format.');
        END IF;
    END;

    INSERT INTO z_weather (city_id, datetime, tempmax, tempmin, temp, feelslikemax, 
        feelslikemin, feelslike, dew, humidity, precip, precipcover, preciptype, 
        snow, snowdepth, windgust, windspeed, winddir, sealevelpressure, cloudcover, visibility)
    VALUES(p_city_id, p_datetime, p_tempmax, p_tempmin, p_temp, p_feelslikemax,
        p_feelslikemin, p_feelslike, p_dew, p_humidity, p_precip, p_precipcover,
        p_preciptype, p_snow, p_snowdepth, p_windgust, p_windspeed, p_winddir,
        p_sealevelpressure, p_cloudcover, p_visibility) 
    RETURNING weather_id INTO p_weather_id;
    
    
    v_log_module := 'z_add_weather';
    v_log_action := 'INSERT';
    v_log_message := 'Weather added with ID: ' || p_weather_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_module := 'z_add_weather';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding weather, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_add_astrology (
    p_weather_id NUMBER,
    p_sunrise VARCHAR2,
    p_sunset VARCHAR2,
    p_moonphase NUMBER,
    p_astrology_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    DECLARE
        v_weather_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_weather_count FROM z_weather WHERE weather_id = p_weather_id;

        IF v_weather_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid weather_id. Weather does not exist.');
        END IF;
    END;
    
    BEGIN
        IF TO_TIMESTAMP(p_sunrise, 'YYYY-MM-DD"T"HH24:MI:SS') IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Invalid timestamp format for sunrise.');
        END IF;
    END;
    
    BEGIN
        IF TO_TIMESTAMP(p_sunset, 'YYYY-MM-DD"T"HH24:MI:SS') IS NULL THEN
            RAISE_APPLICATION_ERROR(-20004, 'Invalid timestamp format for sunset.');
        END IF;
    END;
    
    INSERT INTO z_astrology (weather_id, sunrise, sunset, moonphase) 
    VALUES (p_weather_id, TO_TIMESTAMP(p_sunrise, 'YYYY-MM-DD"T"HH24:MI:SS'), TO_TIMESTAMP(p_sunset, 'YYYY-MM-DD"T"HH24:MI:SS'), p_moonphase) 
    RETURNING astrology_id INTO p_astrology_id;

    v_log_module := 'z_add_astrology';
    v_log_action := 'INSERT';
    v_log_message := 'Astrology added with ID: ' || p_astrology_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        v_log_module := 'z_add_astrology';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding astrology, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_add_desc (
    p_weather_id VARCHAR2,
    p_conditions VARCHAR2 DEFAULT '',
    p_description VARCHAR2 DEFAULT '',
    p_desc_id OUT NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    DECLARE
        v_weather_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_weather_count FROM z_weather WHERE weather_id = p_weather_id;

        IF v_weather_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid weather_id. Weather does not exist.');
        END IF;
    END;
    
    INSERT INTO z_desc (weather_id, conditions, description) VALUES (p_weather_id, p_conditions, p_description) 
    RETURNING desc_id INTO p_desc_id;

    v_log_module := 'z_add_desc';
    v_log_action := 'INSERT';
    v_log_message := 'Description added with ID: ' || p_desc_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        v_log_module := 'z_add_desc';
        v_log_action := 'ERROR';
        v_log_message := 'Error adding description, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

/* DELETE ROW PROCEDURES */

CREATE OR REPLACE PROCEDURE z_delete_country (
    p_country_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_country';
    
    DELETE FROM z_country WHERE country_id = p_country_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for country with country_id: ' || p_country_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted country with country_id: ' || p_country_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted country with country_id: ' || p_country_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting country with country_id: ' || p_country_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_country_archive (
    p_country_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_country_archive';
    
    DELETE FROM z_country_archive WHERE country_id = p_country_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for country_archive with country_id: ' || p_country_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted country with country_id: ' || p_country_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted country with country_id: ' || p_country_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting country with country_id: ' || p_country_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_region (
    p_region_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_region';
    
    DELETE FROM z_region WHERE region_id = p_region_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for region with region_id: ' || p_region_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted region with region_id: ' || p_region_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted region with region_id: ' || p_region_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting region with region_id: ' || p_region_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_region_archive (
    p_region_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_region_archive';
    
    DELETE FROM z_region_archive WHERE region_id = p_region_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for region with region_id: ' || p_region_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted region with region_id: ' || p_region_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted region with region_id: ' || p_region_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting region with region_id: ' || p_region_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_city (
    p_city_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_city';
    
    DELETE FROM z_city WHERE city_id = p_city_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for city with city_id: ' || p_city_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted city with city_id: ' || p_city_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted city with city_id: ' || p_city_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting city with city_id: ' || p_city_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_city_archive (
    p_city_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_city_archive';
    
    DELETE FROM z_city_archive WHERE city_id = p_city_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for city with city_id: ' || p_city_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted city with city_id: ' || p_city_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted city with city_id: ' || p_city_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting city with city_id: ' || p_city_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_weather (
    p_weather_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_weather';
    
    DELETE FROM z_weather WHERE weather_id = p_weather_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for weather with weather_id: ' || p_weather_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted city with weather_id: ' || p_weather_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted weather with weather_id: ' || p_weather_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting weather with weather_id: ' || p_weather_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_weather_archive (
    p_weather_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_weather_archive';
    
    DELETE FROM z_weather_archive WHERE weather_id = p_weather_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for weather with weather_id: ' || p_weather_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted city with weather_id: ' || p_weather_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted weather with weather_id: ' || p_weather_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting weather with weather_id: ' || p_weather_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_astrology (
    p_astrology_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_astrology';
    
    DELETE FROM z_astrology WHERE astrology_id = p_astrology_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for astrology with astrology_id: ' || p_astrology_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted astrology with astrology_id: ' || p_astrology_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted astrology with astrology_id: ' || p_astrology_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting astrology with astrology_id: ' || p_astrology_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_astrology_archive (
    p_astrology_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_astrology_archive';
    
    DELETE FROM z_astrology_archive WHERE astrology_id = p_astrology_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for astrology with astrology_id: ' || p_astrology_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted astrology with astrology_id: ' || p_astrology_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted astrology with astrology_id: ' || p_astrology_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting astrology with astrology_id: ' || p_astrology_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_desc (
    p_desc_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_desc';
    
    DELETE FROM z_desc WHERE desc_id = p_desc_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for desc with desc_id: ' || p_desc_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted desc with desc_id: ' || p_desc_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted desc with desc_id: ' || p_desc_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting desc with desc_id: ' || p_desc_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

CREATE OR REPLACE PROCEDURE z_delete_desc_archive (
    p_desc_id NUMBER
) AS
    v_log_module VARCHAR2(100);
    v_log_action VARCHAR2(100);
    v_log_message VARCHAR2(500);
BEGIN
    v_log_module := 'z_delete_desc_archive';
    
    DELETE FROM z_desc_archive WHERE desc_id = p_desc_id;

    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No rows deleted');
        v_log_action :='DELETE';
        v_log_message := 'No rows deleted for desc with desc_id: ' || p_desc_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Deleted desc with desc_id: ' || p_desc_id);
        v_log_action :='DELETE';
        v_log_message := 'Deleted desc with desc_id: ' || p_desc_id;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    END IF;
    
    COMMIT;
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        
        v_log_action := 'ERROR';
        v_log_message := 'Error deleting desc with desc_id: ' || p_desc_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

/* UPDATE ROW PROCEDURES */

CREATE OR REPLACE PROCEDURE z_update_country (
    p_country_id NUMBER,
    p_name VARCHAR2
) AS
    v_log_module VARCHAR2(100) := 'z_update_country';
    v_log_action VARCHAR2(100) := 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN
    
    DECLARE
        v_country_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_country_count FROM z_country WHERE country_id = p_country_id;

        IF v_country_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid country_id. Country does not exist.');
        END IF;
    END;

    IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
        RAISE_APPLICATION_ERROR(-20001, 'Invalid country name format');
    END IF;

    UPDATE z_country SET name = p_name WHERE country_id = p_country_id;

    v_log_message := 'Country updated: Country ID ' || p_country_id || ', New Name: ' || p_name;
    INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        v_log_message := 'Error updating country with country_id: ' || p_country_id || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message) VALUES (v_log_module, 'ERROR', v_log_message);

        RAISE;
END;
/


CREATE OR REPLACE PROCEDURE z_update_region (
    p_region_id NUMBER,
    p_name VARCHAR2 DEFAULT NULL,
    p_country_id NUMBER DEFAULT NULL
) AS
    v_log_module VARCHAR2(100):= 'z_update_region';
    v_log_action VARCHAR2(100):= 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN
    
    DECLARE
        v_region_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_region_count FROM z_region WHERE region_id = p_region_id;

        IF v_region_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid region_id. Region does not exist.');
        END IF;
    END;

    IF p_name IS NOT NULL THEN
        IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid region name format');
        END IF;
        UPDATE z_region
        SET name = p_name
        WHERE region_id = p_region_id;
    END IF;

    IF p_country_id IS NOT NULL THEN
        DECLARE
            v_country_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_country_count FROM z_country WHERE country_id = p_country_id;
    
            IF v_country_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Invalid country_id. Country does not exist.');
            END IF;
        END;
        UPDATE z_region
        SET country_id = p_country_id
        WHERE region_id = p_region_id;
    END IF;
    
    v_log_message := 'Region updated, Region ID: ' || p_region_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_action := 'ERROR';
        v_log_message := 'Error updating region: ' || p_name || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/
--CALL z_update_region(p_region_id => 10, p_name => 'Purda');

CREATE OR REPLACE PROCEDURE z_update_city (
    p_city_id NUMBER,
    p_name VARCHAR2 DEFAULT NULL,
    p_region_id NUMBER DEFAULT NULL
) AS
    v_log_module VARCHAR2(100):= 'z_update_city';
    v_log_action VARCHAR2(100):= 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN
    
    DECLARE
        v_city_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_city_count FROM z_city WHERE city_id = p_city_id;

        IF v_city_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid city_id. City does not exist.');
        END IF;
    END;

    IF p_name IS NOT NULL THEN
        IF p_name IS NULL OR REGEXP_LIKE(p_name, '\d') THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid city name format');
        END IF;
        UPDATE z_city
        SET name = p_name
        WHERE city_id = p_city_id;
    END IF;

    IF p_region_id IS NOT NULL THEN
        DECLARE
            v_region_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_region_count FROM z_region WHERE region_id = p_region_id;
    
            IF v_region_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Invalid region_id. Region does not exist.');
            END IF;
        END;
        UPDATE z_city
        SET region_id = p_region_id
        WHERE city_id = p_city_id;
    END IF;
    
    v_log_message := 'City updated, City ID: ' || p_city_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_action := 'ERROR';
        v_log_message := 'Error updating city: ' || p_name || ', Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

--CALL z_update_city(p_city_id => 22, p_name => 'Lublin');


CREATE OR REPLACE PROCEDURE z_update_weather (
    p_weather_id NUMBER,
    p_city_id NUMBER DEFAULT NULL,
    p_datetime DATE DEFAULT NULL,
    p_tempmax NUMBER DEFAULT NULL,
    p_tempmin NUMBER DEFAULT NULL,
    p_temp NUMBER DEFAULT NULL,
    p_feelslikemax NUMBER DEFAULT NULL,
    p_feelslikemin NUMBER DEFAULT NULL,
    p_feelslike NUMBER DEFAULT NULL,
    p_dew NUMBER DEFAULT NULL,
    p_humidity NUMBER DEFAULT NULL,
    p_precip NUMBER DEFAULT NULL,
    p_precipcover NUMBER DEFAULT NULL,
    p_preciptype VARCHAR2 DEFAULT NULL,
    p_snow NUMBER DEFAULT NULL,
    p_snowdepth NUMBER DEFAULT NULL,
    p_windgust NUMBER DEFAULT NULL,
    p_windspeed NUMBER DEFAULT NULL,
    p_winddir NUMBER DEFAULT NULL,
    p_sealevelpressure NUMBER DEFAULT NULL,
    p_cloudcover NUMBER DEFAULT NULL,
    p_visibility NUMBER DEFAULT NULL
) AS
    v_log_module VARCHAR2(100):= 'z_update_weather';
    v_log_action VARCHAR2(100):= 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN

    DECLARE
        v_weather_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_weather_count FROM z_weather WHERE weather_id = p_weather_id;

        IF v_weather_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid weather_id. Weather does not exist.');
        END IF;
    END;
    
    IF p_city_id IS NOT NULL THEN
        DECLARE
            v_city_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_city_count FROM z_city WHERE city_id = p_city_id;
    
            IF v_city_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Invalid city_id. City does not exist.');
            END IF;
        END;
        UPDATE z_weather
        SET city_id = p_city_id
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_datetime IS NOT NULL THEN
        BEGIN
            IF TO_DATE(p_datetime, 'YYYY-MM-DD') IS NULL THEN
                RAISE_APPLICATION_ERROR(-20003, 'Invalid date format.');
            END IF;
        END;
        UPDATE z_weather
        SET datetime = p_datetime
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_tempmax IS NOT NULL THEN
        UPDATE z_weather
        SET tempmax = p_tempmax
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_tempmin IS NOT NULL THEN
        UPDATE z_weather
        SET tempmin = p_tempmin
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_temp IS NOT NULL THEN
        UPDATE z_weather
        SET temp = p_temp
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_feelslikemax IS NOT NULL THEN
        UPDATE z_weather
        SET feelslikemax = p_feelslikemax
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_feelslikemin IS NOT NULL THEN
        UPDATE z_weather
        SET feelslikemin = p_feelslikemin
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_feelslike IS NOT NULL THEN
        UPDATE z_weather
        SET feelslike = p_feelslike
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_dew IS NOT NULL THEN
        UPDATE z_weather
        SET dew = p_dew
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_humidity IS NOT NULL THEN
        UPDATE z_weather
        SET humidity = p_humidity
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_precip IS NOT NULL THEN
        UPDATE z_weather
        SET precip = p_precip
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_precipcover IS NOT NULL THEN
        UPDATE z_weather
        SET precipcover = p_precipcover
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_preciptype IS NOT NULL THEN
        UPDATE z_weather
        SET preciptype = p_preciptype
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_snow IS NOT NULL THEN
        UPDATE z_weather
        SET snow = p_snow
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_snowdepth IS NOT NULL THEN
        UPDATE z_weather
        SET snowdepth = p_snowdepth
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_windgust IS NOT NULL THEN
        UPDATE z_weather
        SET windgust = p_windgust
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_windspeed IS NOT NULL THEN
        UPDATE z_weather
        SET windspeed = p_windspeed
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_winddir IS NOT NULL THEN
        UPDATE z_weather
        SET winddir = p_winddir
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_sealevelpressure IS NOT NULL THEN
        UPDATE z_weather
        SET sealevelpressure = p_sealevelpressure
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_cloudcover IS NOT NULL THEN
        UPDATE z_weather
        SET cloudcover = p_cloudcover
        WHERE weather_id = p_weather_id;
    END IF;
    
    IF p_visibility IS NOT NULL THEN
        UPDATE z_weather
        SET visibility = p_visibility
        WHERE weather_id = p_weather_id;
    END IF;


    v_log_message := 'Weather updated with ID: ' || p_weather_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);
    
    COMMIT;
        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        
        v_log_action := 'ERROR';
        v_log_message := 'Error updating weather, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

--CALL z_update_weather(p_weather_id => 767, p_temp => 8.6);

CREATE OR REPLACE PROCEDURE z_update_astrology (
    p_astrology_id NUMBER,
    p_weather_id NUMBER DEFAULT NULL,
    p_sunrise VARCHAR2 DEFAULT NULL,
    p_sunset VARCHAR2 DEFAULT NULL,
    p_moonphase NUMBER DEFAULT NULL
) AS
    v_log_module VARCHAR2(100):= 'z_update_astrology';
    v_log_action VARCHAR2(100):= 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN
    DECLARE
        v_astrology_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_astrology_count FROM z_astrology WHERE astrology_id = p_astrology_id;

        IF v_astrology_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid astrology_id. Astrology does not exist.');
        END IF;
    END;
    
    IF p_weather_id IS NOT NULL THEN
        DECLARE
            v_weather_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_weather_count FROM z_weather WHERE weather_id = p_weather_id;
    
            IF v_weather_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Invalid weather_id. Weather does not exist.');
            END IF;
        END;
        UPDATE z_astrology
        SET weather_id = p_weather_id
        WHERE astrology_id = p_astrology_id;
    END IF;
    
    IF p_sunrise IS NOT NULL THEN
        BEGIN
            IF TO_TIMESTAMP(p_sunrise, 'YYYY-MM-DD"T"HH24:MI:SS') IS NULL THEN
                RAISE_APPLICATION_ERROR(-20004, 'Invalid timestamp format for sunrise. Should be YYYY-MM-DD"T"HH24:MI:SS');
            END IF;
        END;
        UPDATE z_astrology
        SET sunrise = TO_TIMESTAMP(p_sunrise, 'YYYY-MM-DD"T"HH24:MI:SS')
        WHERE astrology_id = p_astrology_id;
    END IF;
    
    IF p_sunset IS NOT NULL THEN
        BEGIN
            IF TO_TIMESTAMP(p_sunset, 'YYYY-MM-DD"T"HH24:MI:SS') IS NULL THEN
                RAISE_APPLICATION_ERROR(-20004, 'Invalid timestamp format for sunset. Should be YYYY-MM-DD"T"HH24:MI:SS');
            END IF;
        END;
        UPDATE z_astrology
        SET sunset = TO_TIMESTAMP(p_sunset, 'YYYY-MM-DD"T"HH24:MI:SS')
        WHERE astrology_id = p_astrology_id;
    END IF;
    
    IF p_moonphase IS NOT NULL THEN
        UPDATE z_astrology
        SET moonphase = p_moonphase
        WHERE astrology_id = p_astrology_id;
    END IF;

    v_log_message := 'Astrology updated with ID: ' || p_astrology_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        v_log_action := 'ERROR';
        v_log_message := 'Error updating astrology, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

--CALL z_update_astrology(p_astrology_id => 999999, p_moonphase => 0.12);

CREATE OR REPLACE PROCEDURE z_update_desc (
    p_desc_id NUMBER,
    p_weather_id NUMBER DEFAULT NULL,
    p_conditions VARCHAR2 DEFAULT NULL,
    p_description VARCHAR2 DEFAULT NULL
) AS
    v_log_module VARCHAR2(100):= 'z_update_desc';
    v_log_action VARCHAR2(100):= 'UPDATE';
    v_log_message VARCHAR2(500);
BEGIN
    DECLARE
        v_desc_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_desc_count FROM z_desc WHERE desc_id = p_desc_id;

        IF v_desc_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Invalid desc_id. Desc does not exist.');
        END IF;
    END;
    
    IF p_weather_id IS NOT NULL THEN
        DECLARE
            v_weather_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_weather_count FROM z_weather WHERE weather_id = p_weather_id;
    
            IF v_weather_count = 0 THEN
                RAISE_APPLICATION_ERROR(-20002, 'Invalid weather_id. Weather does not exist.');
            END IF;
        END;
        UPDATE z_desc
        SET weather_id = p_weather_id
        WHERE desc_id = p_desc_id;
    END IF;
    
    IF p_conditions IS NOT NULL THEN
        UPDATE z_desc
        SET conditions = p_conditions
        WHERE desc_id = p_desc_id;
    END IF;
    
    IF p_description IS NOT NULL THEN
        UPDATE z_desc
        SET description = p_description
        WHERE desc_id = p_desc_id;
    END IF;
    
    v_log_message := 'Desc updated with ID: ' || p_desc_id;
    INSERT INTO z_log (log_module, log_action, log_message)
    VALUES (v_log_module, v_log_action, v_log_message);

    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;

        v_log_action := 'ERROR';
        v_log_message := 'Error updating desc, Error: ' || SQLERRM;
        INSERT INTO z_log (log_module, log_action, log_message)
        VALUES (v_log_module, v_log_action, v_log_message);
        RAISE;
END;
/

--CALL z_update_desc(p_desc_id => 373, p_conditions => 'Overcast');

/* FUNCTIONS */

CREATE OR REPLACE FUNCTION z_country_exists(p_country_name VARCHAR2) RETURN BOOLEAN IS
    v_country_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_country_count
    FROM z_country
    WHERE UPPER(name) = UPPER(p_country_name);

    RETURN v_country_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_country_exists;
/

CREATE OR REPLACE FUNCTION z_get_country_id(p_country_name VARCHAR2) RETURN NUMBER IS
    v_country_id NUMBER;
BEGIN
    SELECT country_id INTO v_country_id
    FROM z_country
    WHERE UPPER(name) = UPPER(p_country_name);

    RETURN v_country_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_country_id;
/

CREATE OR REPLACE FUNCTION z_region_exists(p_region_name VARCHAR2) RETURN BOOLEAN IS
    v_region_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_region_count
    FROM z_region
    WHERE UPPER(name) = UPPER(p_region_name);

    RETURN v_region_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_region_exists;
/

CREATE OR REPLACE FUNCTION z_get_region_id(p_region_name VARCHAR2) RETURN NUMBER IS
    v_region_id NUMBER;
BEGIN
    SELECT region_id INTO v_region_id
    FROM z_region
    WHERE UPPER(name) = UPPER(p_region_name);

    RETURN v_region_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_region_id;
/

CREATE OR REPLACE FUNCTION z_city_exists(p_city_name VARCHAR2) RETURN BOOLEAN IS
    v_city_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_city_count
    FROM z_city
    WHERE UPPER(name) = UPPER(p_city_name);

    RETURN v_city_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_city_exists;
/

CREATE OR REPLACE FUNCTION z_get_city_id(p_city_name VARCHAR2) RETURN NUMBER IS
    v_city_id NUMBER;
BEGIN
    SELECT city_id INTO v_city_id
    FROM z_city
    WHERE UPPER(name) = UPPER(p_city_name);

    RETURN v_city_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_city_id;
/

CREATE OR REPLACE FUNCTION z_weather_exists(p_datetime VARCHAR2, p_city_id NUMBER) RETURN BOOLEAN IS
    v_weather_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_weather_count
    FROM z_weather
    WHERE datetime = TO_DATE(p_datetime, 'YYYY-MM-DD') AND city_id = p_city_id;

    RETURN v_weather_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_weather_exists;
/

CREATE OR REPLACE FUNCTION z_get_weather_id(p_datetime VARCHAR2, p_city_id NUMBER) RETURN NUMBER IS
    v_weather_id NUMBER;
BEGIN
    SELECT weather_id INTO v_weather_id
    FROM z_weather
    WHERE datetime = TO_DATE(p_datetime, 'YYYY-MM-DD') AND city_id = p_city_id;

    RETURN v_weather_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_weather_id;
/

CREATE OR REPLACE FUNCTION z_astrology_exists(p_weather_id NUMBER) RETURN BOOLEAN IS
    v_astrology_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_astrology_count
    FROM z_astrology
    WHERE weather_id = p_weather_id;

    RETURN v_astrology_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_astrology_exists;
/

CREATE OR REPLACE FUNCTION z_get_astrology_id(p_weather_id NUMBER) RETURN NUMBER IS
    v_astrology_id NUMBER;
BEGIN
    SELECT astrology_id INTO v_astrology_id
    FROM z_astrology
    WHERE weather_id = p_weather_id;

    RETURN v_astrology_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_weather_id;
/

CREATE OR REPLACE FUNCTION z_desc_exists(p_weather_id NUMBER) RETURN BOOLEAN IS
    v_desc_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_desc_count
    FROM z_desc
    WHERE weather_id = p_weather_id;

    RETURN v_desc_count > 0;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END z_desc_exists;
/

CREATE OR REPLACE FUNCTION z_get_desc_id(p_weather_id NUMBER) RETURN NUMBER IS
    v_desc_id NUMBER;
BEGIN
    SELECT desc_id INTO v_desc_id
    FROM z_desc
    WHERE weather_id = p_weather_id;

    RETURN v_desc_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    WHEN OTHERS THEN
        RAISE;
END z_get_desc_id;
/

/* SELECT FUNCTIONS */

CREATE OR REPLACE FUNCTION z_get_weather_info_all(
    p_start_date VARCHAR2 DEFAULT NULL,
    p_end_date VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT
        c.name AS country,
        r.name AS region,
        ct.name AS city,
        w.datetime,
        w.tempmax,
        w.tempmin,
        w.temp,
        w.feelslikemax,
        w.feelslikemin,
        w.feelslike,
        w.dew,
        w.humidity,
        w.precip,
        w.precipcover,
        w.preciptype,
        w.snow,
        w.snowdepth,
        w.windgust,
        w.windspeed,
        w.winddir,
        w.sealevelpressure,
        w.cloudcover,
        w.visibility,
        a.sunrise,
        a.sunset,
        a.moonphase,
        d.conditions,
        d.description
    FROM z_country c
    JOIN z_region r ON c.country_id = r.country_id
    JOIN z_city ct ON r.region_id = ct.region_id
    JOIN z_weather w ON ct.city_id = w.city_id
    JOIN z_astrology a ON w.weather_id = a.weather_id
    JOIN z_desc d ON w.weather_id = d.weather_id
    WHERE
        (p_start_date IS NULL OR w.datetime >= TO_DATE(p_start_date, 'DD-MM-YYYY'))
        AND (p_end_date IS NULL OR w.datetime <= TO_DATE(p_end_date, 'DD-MM-YYYY'))
    ORDER BY w.datetime;

    RETURN v_cursor;
END;
/

CREATE OR REPLACE FUNCTION z_get_weather_info_country(
    p_country_name VARCHAR2,
    p_start_date VARCHAR2 DEFAULT NULL,
    p_end_date VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT
        c.name AS country,
        r.name AS region,
        ct.name AS city,
        w.datetime,
        w.tempmax,
        w.tempmin,
        w.temp,
        w.feelslikemax,
        w.feelslikemin,
        w.feelslike,
        w.dew,
        w.humidity,
        w.precip,
        w.precipcover,
        w.preciptype,
        w.snow,
        w.snowdepth,
        w.windgust,
        w.windspeed,
        w.winddir,
        w.sealevelpressure,
        w.cloudcover,
        w.visibility,
        a.sunrise,
        a.sunset,
        a.moonphase,
        d.conditions,
        d.description
    FROM z_country c
    JOIN z_region r ON c.country_id = r.country_id
    JOIN z_city ct ON r.region_id = ct.region_id
    JOIN z_weather w ON ct.city_id = w.city_id
    JOIN z_astrology a ON w.weather_id = a.weather_id
    JOIN z_desc d ON w.weather_id = d.weather_id
    WHERE UPPER(c.name) = UPPER(p_country_name)
        AND (p_start_date IS NULL OR w.datetime >= TO_DATE(p_start_date, 'DD-MM-YYYY'))
        AND (p_end_date IS NULL OR w.datetime <= TO_DATE(p_end_date, 'DD-MM-YYYY'))
    ORDER BY w.datetime;

    RETURN v_cursor;
END;
/

CREATE OR REPLACE FUNCTION z_get_weather_info_region(
    p_region_name VARCHAR2,
    p_start_date VARCHAR2 DEFAULT NULL,
    p_end_date VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT
        c.name AS country,
        r.name AS region,
        ct.name AS city,
        w.datetime,
        w.tempmax,
        w.tempmin,
        w.temp,
        w.feelslikemax,
        w.feelslikemin,
        w.feelslike,
        w.dew,
        w.humidity,
        w.precip,
        w.precipcover,
        w.preciptype,
        w.snow,
        w.snowdepth,
        w.windgust,
        w.windspeed,
        w.winddir,
        w.sealevelpressure,
        w.cloudcover,
        w.visibility,
        a.sunrise,
        a.sunset,
        a.moonphase,
        d.conditions,
        d.description
    FROM z_country c
    JOIN z_region r ON c.country_id = r.country_id
    JOIN z_city ct ON r.region_id = ct.region_id
    JOIN z_weather w ON ct.city_id = w.city_id
    JOIN z_astrology a ON w.weather_id = a.weather_id
    JOIN z_desc d ON w.weather_id = d.weather_id
    WHERE UPPER(r.name) = UPPER(p_region_name)
        AND (p_start_date IS NULL OR w.datetime >= TO_DATE(p_start_date, 'DD-MM-YYYY'))
        AND (p_end_date IS NULL OR w.datetime <= TO_DATE(p_end_date, 'DD-MM-YYYY'))
    ORDER BY w.datetime;

    RETURN v_cursor;
END;
/

CREATE OR REPLACE FUNCTION z_get_weather_info_city(
    p_city_name VARCHAR2,
    p_start_date VARCHAR2 DEFAULT NULL,
    p_end_date VARCHAR2 DEFAULT NULL
)
RETURN SYS_REFCURSOR
IS
    v_cursor SYS_REFCURSOR;
BEGIN
    OPEN v_cursor FOR
    SELECT
        c.name AS country,
        r.name AS region,
        ct.name AS city,
        w.datetime,
        w.tempmax,
        w.tempmin,
        w.temp,
        w.feelslikemax,
        w.feelslikemin,
        w.feelslike,
        w.dew,
        w.humidity,
        w.precip,
        w.precipcover,
        w.preciptype,
        w.snow,
        w.snowdepth,
        w.windgust,
        w.windspeed,
        w.winddir,
        w.sealevelpressure,
        w.cloudcover,
        w.visibility,
        a.sunrise,
        a.sunset,
        a.moonphase,
        d.conditions,
        d.description
    FROM z_country c
    JOIN z_region r ON c.country_id = r.country_id
    JOIN z_city ct ON r.region_id = ct.region_id
    JOIN z_weather w ON ct.city_id = w.city_id
    JOIN z_astrology a ON w.weather_id = a.weather_id
    JOIN z_desc d ON w.weather_id = d.weather_id
    WHERE UPPER(ct.name) = UPPER(p_city_name)
        AND (p_start_date IS NULL OR w.datetime >= TO_DATE(p_start_date, 'DD-MM-YYYY'))
        AND (p_end_date IS NULL OR w.datetime <= TO_DATE(p_end_date, 'DD-MM-YYYY'))
    ORDER BY w.datetime;

    RETURN v_cursor;
END;
