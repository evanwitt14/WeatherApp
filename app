import json
import requests
import tkinter as tk
from tkinter import Label, Entry, Button, StringVar, messagebox
from config import api_key

def api_call(city):
    base_url = 'https://api.weatherbit.io/v2.0/current'

    params = {
        'key': api_key,
        'lang': 'en',
        'units': 'I',
        'city': city
    }
    response = requests.get(base_url, params=params)

    if response.status_code == 200:
        # parse the JSON content of the response
        data = response.json()

        # extract  information
        weather_description = data['data'][0]['weather']['description']
        city_name = data['data'][0]['city_name']
        country_name = data['data'][0]['country_code']
        aqi = data['data'][0]['aqi']
        datetime = data['data'][0]['datetime']
        app_temp = data['data'][0]['app_temp']

        return weather_description, city_name, aqi, datetime, app_temp, country_name
    else:
        return None

def uiprint(stats):
    if stats is not None:
        weather_description, city_name, aqi, datetime, app_temp, country_name = stats
        result_text.set(
            f"City Name: {city_name}, {country_name}\n"
            f"Date: {datetime}\n"
            f"Temperature: {app_temp} F\n"
            f"Weather Description: {weather_description}\n"
            f"Air Quality Index: {aqi}"
        )
    else:
        result_text.set("Error fetching data. Please check the city name.")

def on_submit():
    city = city_entry.get()
    stats = api_call(city)
    uiprint(stats)

# tkinter window
app = tk.Tk()
app.title("World Weather App")

#widgets
Label(app, text="Enter a City:").pack(pady=10)
city_entry = Entry(app, width=30)
city_entry.pack(pady=10)
Button(app, text="Get Weather", command=on_submit).pack(pady=10)

result_text = StringVar()
Label(app, textvariable=result_text).pack(pady=10)

app.mainloop()
