const express = require('express')
var cors = require('cors');
const app = express()
const port = 8080

const http = require('https');
const { response } = require('express');
var ip_adress = '0.0.0.0';

/// Function to get subreddit description
async function make_reddit_request(subreddit) {
  console.log("Subreddit wanted: " + subreddit);
  return new Promise((resolve, reject) => {
    http.get('https://www.reddit.com/r/' + subreddit + '/about.json', (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });

      resp.on('end', () => {
        var newdata = ""
        if (data.includes("data")) {
          newdata = JSON.parse(data).data.public_description
        }
        else {
          newdata = "This subreddit doesn't exist: " + subreddit;
        }
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to get weather temperature in city
async function make_weathertemp_request(city) {
  console.log("City wanted: " + city);
  return new Promise((resolve, reject) => {
    http.get('https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=7b112609e77ce182b8db18e2a5b7fa39', (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });

      resp.on('end', () => {
        var newdata = ""
        if (data.includes("main")) {
          newdata = JSON.parse(data).main.temp
          let degrees_celcius = parseInt(newdata) - 273;
          newdata = degrees_celcius.toString();
        }
        else {
          newdata = "This city doesn't exist";
        }
          //console.log("newdata: " + newdata);
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to get weather humidity in city
async function make_weatherhum_request(city) {
  console.log("City wanted: " + city);
  return new Promise((resolve, reject) => {
    http.get('https://api.openweathermap.org/data/2.5/weather?q=' + city + '&appid=7b112609e77ce182b8db18e2a5b7fa39', (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });

      resp.on('end', () => {
        var newdata = ""
        if (data.includes("main")) {
          newdata = JSON.parse(data).main.humidity
        }
        else {
          newdata = "This city doesn't exist";
        }
          //console.log("newdata: " + newdata);
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to get reddit user profile picture
async function make_reddit_userrequest(reddituser) {
  console.log("Subreddit wanted: " + reddituser);
  return new Promise((resolve, reject) => {
    http.get('https://www.reddit.com/user/' + reddituser + '/about.json', (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });

      resp.on('end', () => {
        var newdata = ""
        if (data.includes("data")) {
          newdata = JSON.parse(data).data.subreddit.icon_img;
          newdata = newdata.split('?')[0]
        }
        else {
          newdata = "https://jessicariches.files.wordpress.com/2012/09/img_39081.jpg";
        }
          //console.log("newdata: " + newdata);
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to get the movie description
async function make_movie_request(movie) {
  console.log("Movie wanted: " + movie);
  return new Promise((resolve, reject) => {
    http.get('https://api.themoviedb.org/3/search/movie?api_key=2988eb19ab4a8d1f06e2ead6088863e5&query=' + movie, (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });
      resp.on('end', () => {
        var newdata = ""
        if (JSON.parse(data).hasOwnProperty('page')) {
          if (parseInt(JSON.parse(data).total_results) > 0) {
            newdata = JSON.parse(data).results[0].overview;
          }
        }
        else {
          newdata = "This movie doesn't exist";
        }
          //console.log("newdata: " + newdata);
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to get the movie release date
async function make_movie_date_request(movie) {
  console.log("Movie wanted: " + movie);
  return new Promise((resolve, reject) => {
    http.get('https://api.themoviedb.org/3/search/movie?api_key=2988eb19ab4a8d1f06e2ead6088863e5&query=' + movie, (resp) => {
      let data = '';
      resp.on('data', (chunk) => {
        data += chunk;
      });
      resp.on('end', () => {
        var newdata = ""
        if (JSON.parse(data).hasOwnProperty('page')) {
          if (parseInt(JSON.parse(data).total_results) > 0) {
            newdata = JSON.parse(data).results[0].release_date;
          }
        }
        else {
          newdata = "This movie doesn't exist";
        }
          //console.log("newdata: " + newdata);
        resolve(newdata);
      });

    }).on("error", (err) => {
      console.log("Error: " + err.message);
      reject(err);
    });
  });
}

/// Function to send back the about.json
function createJson() {
  var dashson = {
    "client": {
      "host": ip_adress
    },
    "server": {
      "current_time": Date.now().toString(),
      "services": [
        {
          "name": "weather",
          "widgets": [
            {
              "name": "city_temperature",
              "description ": "Display temperature for a city",
              "params": [
                {
                  "name": "city",
                  "type": "string"
                }
              ]
            },
            {
              "name": "city_humidity",
              "description ": "Display the humidity of a city",
              "params": [
                {
                  "name": "city",
                  "type": "string"
                }
              ]
            },
          ]
        }, 
        {
          "name": "reddit",
          "widgets": [
            {
              "name": "Get Subreddit Description",
              "description": "Displaying the description of a subreddit",
              "params": [
                {
                  "name": "subreddit",
                  "type": "string"
                }
              ]
            },
            {
              "name": "Get User Profile picture",
              "description": "Displaying the profile picture of a reddit user",
              "params": [
                {
                  "name": "username",
                  "type": "string"
                }
              ],
            }
          ],
        },
        {
          "name": "MovieDB",
          "widgets": [
            {
              "name": "Get Movie Description",
              "description": "Displaying the description of a Movie",
              "params": [
                {
                  "name": "movie",
                  "type": "string"
                }
              ]
            },
            {
              "name": "Get Movie Release Date",
              "description": "Displaying the release date of a Movie",
              "params": [
                {
                  "name": "movie",
                  "type": "string"
                }
              ]
            }
          ]
        }
      ]
    }
  }
  return (dashson);
}

app.get('/about.json', (req, res) => {
  ip_adress = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  res.json(createJson());
})

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

var number_called_date = 0;
var number_called_descred = 0;
var number_called_descmov = 0;
var number_called_temp = 0;
var number_called_hum = 0;
var number_called_profilered = 0;

app.use(cors())

/// This function will handle all the requests from the dashboard
app.use((req,res,next)=>{
  if (req.method == 'POST') {
    /// The body of the request
    var body = '';

    req.on('data', function (data) {
        body += data;
    });

    req.on('end', function () {
      console.log("body: " + body);
      var widget_name = body.split(" ");
      if (widget_name[0] == "Reddit_desc") {
          number_called_descred += 1;
          make_reddit_request(widget_name[1]).then((response) => {
          console.log("Description: " + response);
          res.send(response + " (" + number_called_descred.toString() + ")");
        });
      }
      if (widget_name[0] == "Weather_temp") {
        number_called_temp += 1;
        let full_movie_name = ""
        for (let i = 1; i < widget_name.length; i++) {
          full_movie_name += " " + widget_name[i];
        }
        make_weathertemp_request(full_movie_name).then((response) => {
          if (response == "This city doesn't exist") {
            res.send(full_movie_name + " doesn't exist");
          }
          else {
            console.log("Il fait " + response + " degrès Celcius");
            res.send("The temperature in " + full_movie_name + " is " + response + " degrees Celcius" + " (" + number_called_temp.toString() + ")");
          }
        });
      }
      if (widget_name[0] == "Weather_hum") {
        number_called_hum += 1
        let full_movie_name = ""
        for (let i = 1; i < widget_name.length; i++) {
          full_movie_name += " " + widget_name[i];
        }
        make_weatherhum_request(full_movie_name).then((response) => {
          if (response == "This city doesn't exist") {
            res.send(full_movie_name + " doesn't exist");
          }
          else {
            console.log("Il fait " + response + "% d'humidité");
            res.send("The humidity in " + full_movie_name + " is " + response + "%" + " (" + number_called_hum.toString() + ")");
          }
        });
      }
      if (widget_name[0] == "Reddit_user") {
          number_called_profilered += 1;
          make_reddit_userrequest(widget_name[1]).then((response) => {
          console.log("Image url: " + response + " (" + number_called_profilered.toString() + ")");
          res.send(response + " (" + number_called_profilered.toString() + ")");
        });
      }
      if (widget_name[0] == "Movie") {
        number_called_descmov += 1;
        let full_movie_name = ""
        for (let i = 1; i < widget_name.length; i++) {
          full_movie_name += " " + widget_name[i];
        }
        make_movie_request(full_movie_name).then((response) => {
          if (response == "This movie doesn't exist") {
            res.send(full_movie_name + " doesn't exist");
          }
          else {
            console.log("Description: " + response  + " (" + number_called_descmov.toString() + ")");
            res.send(response);
          }
        });
      }
      if (widget_name[0] == "Movie_date") {
        number_called_date += 1;
        let full_movie_name = ""
        for (let i = 1; i < widget_name.length; i++) {
          full_movie_name += " " + widget_name[i];
        }
        make_movie_date_request(full_movie_name).then((response) => {
          if (response == "This movie doesn't exist") {
            res.send(full_movie_name + " doesn't exist");
          }
          else {
            console.log("Date: " + response);
            res.send("This movie was released on " + response + " (" + number_called_date.toString() + ")");
          }
        });
      }
    });
  }
  //next();//this will invoke next middleware function
})

app.listen(port, '0.0.0.0', () => {
  console.log(`Dashboard listening at http://localhost:${port}`);
})
