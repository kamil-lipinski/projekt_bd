import urllib.request
import sys
import csv
import codecs
import pandas as pd
import oracledb


connection = oracledb.connect(
    user='lipinskik',
    password='kamilhaslo123',
    dsn='213.184.8.44:1521/orcl')

city = 'Zakopane'

try:
    ResultBytes = urllib.request.urlopen(
        f"https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/{city}/last30days"
        "?unitGroup=metric&elements=datetime%2Cname%2Ctempmax%2Ctempmin%2Ctemp%2Cfeelslikemax%2Cfeelslikemin"
        "%2Cfeelslike%2Cdew%2Chumidity%2Cprecip%2Cprecipcover%2Cpreciptype%2Csnow%2Csnowdepth%2Cwindgust%2Cwindspeed"
        "%2Cwinddir%2Cpressure%2Ccloudcover%2Cvisibility%2Csunrise%2Csunset%2Cmoonphase%2Cconditions%2Cdescription"
        "&include=days&key=2LUQHNEL4NZN8LLPCZQRNVZ8D&contentType=csv")

    CSVText = csv.reader(codecs.iterdecode(ResultBytes, 'utf-8'))

    # output_file_path = 'output.csv'

    # with open(output_file_path, 'w', newline='') as csvfile:
    #     csv_writer = csv.writer(csvfile)
    #
    #     for row in CSVText:
    #         csv_writer.writerow(row)
    #
    # print(f'The CSV file has been successfully saved at: {output_file_path}')

except urllib.error.HTTPError as e:
    ErrorInfo = e.read().decode()
    print('Error code: ', e.code, ErrorInfo)
    sys.exit()
except urllib.error.URLError as e:
    ErrorInfo = e.read().decode()
    print('Error code: ', e.code, ErrorInfo)
    sys.exit()

columns = next(CSVText)
df = pd.DataFrame(CSVText, columns=columns)

# df = pd.read_csv('output.csv', encoding="cp1250")

location = df['name'].iloc[0].split(',')
city = location[0].strip()
country = location[-1].strip()

if len(location) == 2:
    region = location[0].strip()
else:
    region = location[1].strip()

desc = df[['conditions', 'description']]
astrology = df[['sunrise', 'sunset', 'moonphase']]
weather = df.drop(['name', 'conditions', 'description', 'sunrise', 'sunset', 'moonphase'], axis=1)


cursor = connection.cursor()

# COUNTRY TABLE
cursor.execute(f"SELECT * FROM z_country WHERE name='{country}'")
rows = cursor.fetchall()

if len(rows) == 0:
    country_id = cursor.var(oracledb.NUMBER, outconverter=int)

    statement = ('INSERT INTO z_country (name) VALUES (:0) '
                 'RETURNING country_id into :1')
    cursor.execute(statement, (country, country_id))

    country_id = country_id.getvalue()[0]

    connection.commit()
    print(f"'{country}' not found in the database, inserted it into z_country table with country_id: {country_id}")

else:
    country_id = rows[0][0]


# REGION TABLE
cursor.execute(f"SELECT * FROM z_region WHERE name='{region}'")
rows = cursor.fetchall()

if len(rows) == 0:
    region_id = cursor.var(oracledb.NUMBER, outconverter=int)

    statement = ('INSERT INTO z_region (name, country_id) VALUES (:0, :1) '
                 'RETURNING region_id into :2')
    cursor.execute(statement, (region, country_id, region_id))

    region_id = region_id.getvalue()[0]

    connection.commit()
    print(f"'{region}' not found in the database, inserted it into z_region table with region_id: {region_id}")

else:
    region_id = rows[0][0]


# CITY TABLE
cursor.execute(f"SELECT * FROM z_city WHERE name='{city}'")
rows = cursor.fetchall()

if len(rows) == 0:
    city_id = cursor.var(oracledb.NUMBER, outconverter=int)

    statement = ('INSERT INTO z_city (name, region_id) VALUES (:0, :1) '
                 'RETURNING city_id into :2')
    cursor.execute(statement, (city, region_id, city_id))

    city_id = city_id.getvalue()[0]

    connection.commit()
    print(f"'{city}' not found in the database, inserted it into z_city table with city_id: {city_id}")

else:
    city_id = rows[0][0]


# WEATHER TABLE
for index, row in weather.iterrows():
    datetime = row['datetime']
    tempmax = float(row['tempmax'])
    tempmin = float(row['tempmin'])
    temp = float(row['temp'])
    feelslikemax = float(row['feelslikemax'])
    feelslikemin = float(row['feelslikemin'])
    feelslike = float(row['feelslike'])
    dew = float(row['dew'])
    humidity = float(row['humidity'])
    precip = float(row['precip'])
    precipcover = float(row['precipcover'])
    preciptype = str(row['preciptype'])
    snow = float(row['snow'])
    snowdepth = float(row['snowdepth'])
    windgust = float(row['windgust'])
    windspeed = float(row['windspeed'])
    winddir = float(row['winddir'])
    sealevelpressure = float(row['sealevelpressure'])
    cloudcover = float(row['cloudcover'])
    visibility = float(row['visibility'])

    cursor.execute(f"SELECT * FROM z_weather WHERE datetime=TO_DATE('{datetime}', 'YYYY-MM-DD') AND city_id={city_id}")
    rows = cursor.fetchall()

    if len(rows) == 0:
        weather_id = cursor.var(oracledb.NUMBER, outconverter=int)

        statement = ("INSERT INTO z_weather (city_id, datetime, tempmax, tempmin, temp, feelslikemax, feelslikemin, "
                     "feelslike, dew, humidity, precip, precipcover, preciptype, snow, snowdepth, "
                     "windgust, windspeed, winddir, sealevelpressure, cloudcover, visibility) "
                     "VALUES (:0, TO_DATE(:1, 'YYYY-MM-DD'), :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, "
                     ":15, :16, :17, :18, :19, :20) "
                     "RETURNING weather_id into :21")
        cursor.execute(statement, (city_id, datetime, tempmax, tempmin, temp, feelslikemax, feelslikemin,
                                   feelslike, dew, humidity, precip, precipcover, preciptype, snow,
                                   snowdepth, windgust, windspeed, winddir, sealevelpressure, cloudcover, visibility,
                                   weather_id))

        weather_id = weather_id.getvalue()[0]

        connection.commit()
        print(f"Weather on {datetime} in {city} not found in the database, "
              f"inserted it into z_weather table with weather_id: {weather_id}")

        # ASTROLOGY TABLE
        sunrise = astrology.iloc[index]['sunrise']
        sunset = astrology.iloc[index]['sunset']
        moonphase = float(astrology.iloc[index]['moonphase'])

        astrology_id = cursor.var(oracledb.NUMBER, outconverter=int)

        date_format = 'YYYY-MM-DD"T"HH24:MI:SS'

        statement = ('INSERT INTO z_astrology (weather_id, sunrise, sunset, moonphase) '
                     'VALUES (:0, TO_DATE(:1, :2), '
                     'TO_DATE(:2, :3), :4) '
                     'RETURNING astrology_id into :5')
        cursor.execute(statement, (weather_id, sunrise, date_format, sunset, date_format, moonphase, astrology_id))

        astrology_id = astrology_id.getvalue()[0]

        connection.commit()
        print(f"Inserted astrology data into z_astrology table with astrology_id: {astrology_id}")

        # DESC TABLE
        conditions = str(desc.iloc[index]['conditions'])
        description = str(desc.iloc[index]['description'])

        desc_id = cursor.var(oracledb.NUMBER, outconverter=int)

        statement = ('INSERT INTO z_desc (weather_id, conditions, description) '
                     'VALUES (:0, :1, :2) '
                     'RETURNING desc_id into :3')
        cursor.execute(statement, (weather_id, conditions, description, desc_id))

        desc_id = desc_id.getvalue()[0]

        connection.commit()
        print(f"Inserted desc data into z_desc table with desc_id: {desc_id}")


cursor.close()
