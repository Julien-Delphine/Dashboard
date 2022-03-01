# Documentation of the project Dashboard
## Sign in / Sign up page
To start the project, please run the following command:
`docker-compose build && docker-compose up`
Then head onto http://localhost:3000/
You can create an account with OAuth by pressing the `signup` button or sign in using your google account by pressing the `sign in with google` button
If you already have an account with normal OAuth you can just fill in your email and password and press the `login` button
---
## Services page
You can subscribe to a service by pressing the `subscribe` button under the service of your choice
Once that is done you can go to your home page by pressing the `Go to genepiboard` button
You can logout at anytime by pressing the `logout` button on the top right corner of your screen
---
## Home page (Dashboard)
On your homepage you can see buttons to add widgets corresponding to the services you subscribed to.
Click on one of them to add a widget. You can then chose its refresh rate by filling the alert dialog with a number (for seconds). Then enter the parameter of your choice and you will get the information you need.
You can logout at anytime by pressing the `logout` button on the top right corner of your screen


# Services and widgets
#### Reddit service: _This service will allow you to get a subreddit's description or a reddit user profile picture_
- ##### Reddit Description widget: _This widget will give you the description of a given subreddit_
- ##### Reddit User widget: _This widget will give you the profile picture of a given user_
---
#### Weather service: _This service will give you information about the weather in a certain city such as temperature and humidity_
- ##### Weather Temperature widget: _This widget will give you the temperature in a given city_
- ##### Weather Humidity widget: _This widget will give you the humidity percentage in a given city_
---
#### Movie service: _This service will tell you the description of a movie of your choice and its release date_
- ##### Movie Description widget: _This widget will give you the description of a given movie_
- ##### Movie Release date widget: _This widget will give you the release date of a given movie_

---

## To get a more technical documentation, open the following file in your favorite browser (while being in the root of the project):
`./dashboard/doc/api/index.html`

## You can get a json of the application by doing the request `http://localhost:8080/about.json`