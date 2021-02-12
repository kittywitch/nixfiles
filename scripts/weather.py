import requests
import json
import sys

city = sys.argv[1]
api_key = sys.argv[2]

url = f"https://api.openweathermap.org/data/2.5/weather?q={city}&appid={api_key}&units=metric"

weather_icons = {
    "Thunderstorm": "摒",
    "Clouds": "摒",
    "Drizzle": "",
    "Rain": "",
    "Snow": "流",
    "Clear": "滛",
    "Mist": "",
    "Smoke": "",
    "Haze": "",
    "Dust": "",
    "Fog": "",
    "Sand": "",
    "Ash": "",
    "Squall": "",
    "Tornado": ""
}

def degrees_to_cardinal(d):
    dirs = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
            "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW"]
    ix = int((d + 11.25)/22.5)
    return dirs[ix % 16]

response = requests.get(url)
data = json.loads(response.text)
#print(data)

condition = data["weather"][0]["main"]
weather_icon = weather_icons[condition]
temperature = f"{data['main']['temp']}°C"
feels_like_temperature = f"{data['main']['feels_like']}°C"
humidity = f"{data['main']['humidity']}%"
wind = f"{data['wind']['speed']}m/s {degrees_to_cardinal(data['wind']['deg'])}"

end_string = f"{weather_icon}  {temperature} {feels_like_temperature} {humidity} {wind}"
print(end_string)
