import pandas as pd
import oracledb

connection = oracledb.connect(
    user='lipinskik',
    password='kamilhaslo123',
    dsn='213.184.8.44:1521/orcl')


def full_weather(daty=False, start_date='10.01.2024', end_date='14.01.2024'):
    cursor = connection.cursor()
    if daty:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_all", oracledb.CURSOR, [start_date, end_date])
    else:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_all", oracledb.CURSOR)

    weather_info = weather_info_cursor.fetchall()
    cursor.close()

    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)

    return df


def country_weather(country, daty=False, start_date='10.01.2024', end_date='14.01.2024'):
    cursor = connection.cursor()
    if daty:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_country", oracledb.CURSOR,
                                              [country, start_date, end_date])
    else:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_country", oracledb.CURSOR, [country])

    weather_info = weather_info_cursor.fetchall()
    cursor.close()

    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)

    return df


def region_weather(region='Woj. Pomorskie', daty=False, start_date='10.01.2024', end_date='14.01.2024'):
    cursor = connection.cursor()
    if daty:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_region", oracledb.CURSOR,
                                              [region, start_date, end_date])
    else:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_region", oracledb.CURSOR, [region])

    weather_info = weather_info_cursor.fetchall()
    cursor.close()

    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)

    return df


def city_weather(city, daty=False, start_date='10.01.2024', end_date='14.01.2024'):
    cursor = connection.cursor()
    if daty:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_city", oracledb.CURSOR,
                                              [city, start_date, end_date])
    else:
        weather_info_cursor = cursor.callfunc("z_get_weather_info_city", oracledb.CURSOR, [city])

    weather_info = weather_info_cursor.fetchall()
    cursor.close()

    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)

    return df


def country_weather_monthly_avg(kraj='Polska', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_monthly_info_country", oracledb.CURSOR, [kraj, rok])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df


def region_weather_monthly_avg(woj='Pomorskie', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_monthly_info_region", oracledb.CURSOR,
                                          [f'Woj. {woj}', rok])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df

def city_weather_monthly_avg(city='Olsztyn', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_monthly_info_city", oracledb.CURSOR, [city, rok])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df


def country_weather_quarterly_avg(kraj='Polska', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_quarterly_info_country", oracledb.CURSOR,
                                          [kraj, rok])

    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df


def region_weather_quarterly_avg(woj='Pomorskie', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_quarterly_info_region", oracledb.CURSOR,
                                          [f'Woj. {woj}', rok])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df

def city_weather_quarterly_avg(city='Olsztyn', rok='2023'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_quarterly_info_city", oracledb.CURSOR, [city, rok])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df


def country_weather_yearly_avg(kraj='Polska'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_yearly_info_country", oracledb.CURSOR,
                                          [kraj])

    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df


def region_weather_yearly_avg(woj='Pomorskie'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_yearly_info_region", oracledb.CURSOR,
                                          [f'Woj. {woj}'])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df

def city_weather_yearly_avg(city='Olsztyn'):
    cursor = connection.cursor()
    weather_info_cursor = cursor.callfunc("z_get_weather_avg_yearly_info_city", oracledb.CURSOR, [city])
    weather_info = weather_info_cursor.fetchall()
    cursor.close()
    columns = [desc[0] for desc in weather_info_cursor.description]
    df = pd.DataFrame(weather_info, columns=columns)
    return df

