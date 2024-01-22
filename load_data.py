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

city = 'Plock'

# key = '2LUQHNEL4NZN8LLPCZQRNVZ8D'
# key = '4GKB6Z753DTNTWBFMERDJHFJV'
# key = 'QNPT9BGVYW4RS583JSTVH6T5M'
# key = 'J4QCJEMKLAZW8E55GR9KHUL2P'
# key = 'YTRJPA8UXQDTLQHT96TRUYDZ2'
# key = 'EAEQ84B8E7Z9579384LQU6XLJ'
# key = 'PT3MQBRJCD2AJF5FG4XJ5PNDG'
# key = 'JZPHDBTLY9W4MS89HSUB6PYJK'
# key = '9UYDETDNKGBXT98FRYVD4WPWA'
key = 'H7ZF95JYAGEGMZWF4R7ENYAAG'

try:
    ResultBytes = urllib.request.urlopen(
        # f"https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/{city}/2023-01-01/2024-01-21"
        f"https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/{city}/last30days"
        "?unitGroup=metric&elements=datetime%2Cname%2Ctempmax%2Ctempmin%2Ctemp%2Cfeelslikemax%2Cfeelslikemin"
        "%2Cfeelslike%2Cdew%2Chumidity%2Cprecip%2Cprecipcover%2Cpreciptype%2Csnow%2Csnowdepth%2Cwindgust%2Cwindspeed"
        "%2Cwinddir%2Cpressure%2Ccloudcover%2Cvisibility%2Csunrise%2Csunset%2Cmoonphase%2Cconditions%2Cdescription"
        f"&include=days&key={key}&contentType=csv")

    CSVText = csv.reader(codecs.iterdecode(ResultBytes, 'utf-8'))

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
country_exists = cursor.callfunc("z_country_exists", oracledb.BOOLEAN, [country])

if not country_exists:
    country_id = cursor.var(oracledb.NUMBER, outconverter=int)

    cursor.callproc("z_add_country", (country, country_id))
    country_id = country_id.getvalue()

    connection.commit()
    print(f"'{country}' not found in the database, inserted it into z_country table with country_id: {country_id}")

else:
    country_id = int(cursor.callfunc("z_get_country_id", oracledb.NUMBER, [country]))
    print(f"'{country}' found in the database with country_id: {country_id}")

print('--------------------------------------------------------------------')


# REGION TABLE
region_exists = cursor.callfunc("z_region_exists", oracledb.BOOLEAN, [region])

if not region_exists:
    region_id = cursor.var(oracledb.NUMBER, outconverter=int)

    cursor.callproc("z_add_region", (region, country_id, region_id))
    region_id = region_id.getvalue()

    connection.commit()
    print(f"'{region}' not found in the database, inserted it into z_region table with region_id: {region_id}")

else:
    region_id = int(cursor.callfunc("z_get_region_id", oracledb.NUMBER, [region]))
    print(f"'{region}' found in the database with region_id: {region_id}")

print('--------------------------------------------------------------------')


# CITY TABLE
city_exists = cursor.callfunc("z_city_exists", oracledb.BOOLEAN, [city])

if not city_exists:
    city_id = cursor.var(oracledb.NUMBER, outconverter=int)

    cursor.callproc("z_add_city", (city, region_id, city_id))
    city_id = city_id.getvalue()

    connection.commit()
    print(f"'{city}' not found in the database, inserted it into z_city table with city_id: {city_id}")

else:
    city_id = int(cursor.callfunc("z_get_city_id", oracledb.NUMBER, [city]))
    print(f"'{city}' found in the database with city_id: {city_id}")

print('--------------------------------------------------------------------')


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

    weather_exists = cursor.callfunc("z_weather_exists", oracledb.BOOLEAN, [datetime, city_id])

    if not weather_exists:
        weather_id = cursor.var(oracledb.NUMBER, outconverter=int)

        cursor.callproc("z_add_weather", (city_id, datetime, tempmax, tempmin, temp, feelslikemax,
                                          feelslikemin, feelslike, dew, humidity, precip, precipcover, preciptype, snow,
                                          snowdepth, windgust, windspeed, winddir, sealevelpressure, cloudcover,
                                          visibility, weather_id))

        weather_id = weather_id.getvalue()

        connection.commit()
        print(f"Weather on '{datetime}' in '{city}' not found in the database, "
              f"inserted it into z_weather table with weather_id: {weather_id}")

    else:
        weather_id = int(cursor.callfunc("z_get_weather_id", oracledb.NUMBER, [datetime, city_id]))
        print(f"Weather on '{datetime}' in '{city}' found in the database with weather_id: {weather_id}")

    # ASTROLOGY TABLE
    astrology_exists = cursor.callfunc("z_astrology_exists", oracledb.BOOLEAN, [weather_id])

    if not astrology_exists:
        sunrise = astrology.iloc[index]['sunrise']
        sunset = astrology.iloc[index]['sunset']
        moonphase = float(astrology.iloc[index]['moonphase'])

        astrology_id = cursor.var(oracledb.NUMBER, outconverter=int)

        cursor.callproc("z_add_astrology", (weather_id, sunrise, sunset, moonphase, astrology_id))
        astrology_id = astrology_id.getvalue()

        connection.commit()
        print(f"Astrology data on '{datetime}' in '{city}' not found in the database, "
              f"inserted it into z_astrology table with astrology_id: {astrology_id}")
    else:
        astrology_id = int(cursor.callfunc("z_get_astrology_id", oracledb.NUMBER, [weather_id]))
        print(f"Astrology data on '{datetime}' in '{city}' found in the database with astrology_id: {astrology_id}")

    # DESC TABLE
    desc_exists = cursor.callfunc("z_desc_exists", oracledb.BOOLEAN, [weather_id])

    if not desc_exists:
        conditions = str(desc.iloc[index]['conditions'])
        description = str(desc.iloc[index]['description'])

        desc_id = cursor.var(oracledb.NUMBER, outconverter=int)

        cursor.callproc("z_add_desc", (weather_id, conditions, description, desc_id))
        desc_id = desc_id.getvalue()

        connection.commit()
        print(f"Desc data on '{datetime}' in '{city}' not found in the database, "
              f"inserted it into z_desc table with desc_id: {desc_id}")

    else:
        desc_id = int(cursor.callfunc("z_get_desc_id", oracledb.NUMBER, [weather_id]))
        print(f"Desc data on '{datetime}' in '{city}' found in the database with desc_id: {desc_id}")

    print('--------------------------------------------------------------------')

cursor.close()
