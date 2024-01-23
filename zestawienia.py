import table_from_database as tbl
import pandas as pd
import oracledb
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt

connection = oracledb.connect(
    user='lipinskik',
    password='kamilhaslo123',
    dsn='213.184.8.44:1521/orcl')

def miesieczne_kraj(kraj='Polska', rok='2023'):
    weather_info = tbl.country_weather_monthly_avg(kraj, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_miesieczny_{kraj}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['MONTH'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura miesięczna w {kraj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna miesięczna w {kraj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['MONTH'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['MONTH'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['MONTH'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie miesięczne opady w {kraj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

def miesieczne_region(woj='Pomorskie', rok='2023'):
    weather_info = tbl.region_weather_monthly_avg(woj, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_miesieczny_{woj}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['MONTH'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura miesięczna w Woj. {woj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna miesięczna w Woj. {woj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['MONTH'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['MONTH'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['MONTH'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie miesięczne opady w Woj. {woj} w {rok}')
        plt.xlabel('Miesiąc')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()


def miesieczne_city(city='Olsztyn', rok='2023'):
    weather_info = tbl.city_weather_monthly_avg(city, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_miesieczny_{city}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['MONTH'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura miesięczna w {city} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['MONTH'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna miesięczna w {city} w {rok}')
        plt.xlabel('Miesiąc')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['MONTH'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['MONTH'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['MONTH'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['MONTH'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie miesięczne opady w {city} w {rok}')
        plt.xlabel('Miesiąc')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

def kwartalne_kraj(kraj='Polska', rok='2023'):
    weather_info = tbl.country_weather_quarterly_avg(kraj, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_kwartalny_{kraj}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['QUARTER'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura kwartalna w {kraj} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna kwartalna w {kraj} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['QUARTER'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['QUARTER'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['QUARTER'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie kwartalne opady w {kraj} w {rok}')
        plt.xlabel('Kwartał')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

def kwartalne_region(woj='Pomorskie', rok='2023'):
    weather_info = tbl.region_weather_quarterly_avg(woj, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_kwartalny_{woj}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['QUARTER'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura kwartalna w Woj. {woj} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna kwartalna w Woj. {woj} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['QUARTER'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['QUARTER'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['QUARTER'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie kwartalne opady w Woj. {woj} w {rok}')
        plt.xlabel('Kwartał')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()


def kwartalne_city(city='Olsztyn', rok='2023'):
    weather_info = tbl.city_weather_quarterly_avg(city, rok)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_kwartalny_{city}_{rok}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['QUARTER'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura kwartalna w {city} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['QUARTER'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna kwartalna w {city} w {rok}')
        plt.xlabel('Kwartał')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['QUARTER'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['QUARTER'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['QUARTER'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['QUARTER'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie kwartalne opady w {city} w {rok}')
        plt.xlabel('Kwartał')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

def roczne_kraj(kraj='Polska'):
    weather_info = tbl.country_weather_yearly_avg(kraj)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_roczny_{kraj}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['YEAR'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura roczna w {kraj}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna roczna w {kraj}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['YEAR'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['YEAR'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['YEAR'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie roczne opady w {kraj}')
        plt.xlabel('Rok')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

def roczne_region(woj='Pomorskie'):
    weather_info = tbl.region_weather_yearly_avg(woj)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_roczny_{woj}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['YEAR'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura roczna w Woj. {woj}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna roczna w Woj. {woj}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['YEAR'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['YEAR'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['YEAR'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie roczne opady w Woj. {woj}')
        plt.xlabel('Rok')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()


def roczne_city(city='Olsztyn'):
    weather_info = tbl.city_weather_yearly_avg(city)
    df = pd.DataFrame(weather_info)

    with PdfPages(f'Raport_roczny_{city}.pdf') as pdf:
        fig, ax = plt.subplots(figsize=(20, 4))
        ax.axis('off')
        table = ax.table(cellText=df.values,
                  colLabels=df.columns,
                  cellLoc='center',
                  loc='center')
        table.auto_set_font_size(False)
        table.set_fontsize(7)
        table.auto_set_column_width([i for i in range(len(df.columns))])
        table.auto_set_column_width([i for i in range(len(df.columns))])
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_TEMP'], marker='o', color='black', label='Temperatura')
        plt.plot(df['YEAR'], df['AVG_TEMPMIN'], marker='o', color='blue', label='Temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_TEMPMAX'], marker='o', color='red', label='Temperatura maksymalna')
        plt.title(f'Średnia temperatura roczna w {city}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_FEELSLIKE'], marker='o', color='black', label='Odczuwalna temperatura')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMIN'], marker='o', color='blue', label='Odczuwalna temperatura minimalna')
        plt.plot(df['YEAR'], df['AVG_FEELSLIKEMAX'], marker='o', color='red', label='Odczuwalna temperatura maksymalna')
        plt.title(f'Średnia temperatura odczuwalna roczna w {city}')
        plt.xlabel('Rok')
        plt.ylabel('Temperatura (°C)')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()

        plt.figure(figsize=(20, 16))
        plt.plot(df['YEAR'], df['AVG_PRECIP'], marker='o', color='blue', label='Opady deszczu')
        plt.plot(df['YEAR'], df['AVG_PRECIPCOVER'], marker='o', color='black', label='Obszar opadów')
        plt.plot(df['YEAR'], df['AVG_SNOW'], marker='o', color='lightblue', label='Opady śniegu')
        plt.plot(df['YEAR'], df['AVG_SNOWDEPTH'], marker='o', color='grey', label='Głębokość warstwy śniegu')
        plt.title(f'Średnie roczne opady w {city}')
        plt.xlabel('Rok')
        plt.legend()
        plt.grid(True)
        pdf.savefig()
        plt.close()
