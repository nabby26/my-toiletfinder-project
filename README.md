# Toilet Finder Project
This repository is a source code for our Cloud Computing Assignment 2.

Made by Nabila Herzegovina and Nancy Do.

## About the app
Help people find public toilet nearby through our app. 

## Run the app locally
On repository directory, enter this command on terminal 

```
Rails Server
```

Then open the web app on this address :

[localhost:3000](http://localhost:3000)

## Deploy to Google Cloud
Please set up the Google Cloud for this project on your local machine first.

```
gcloud init
```

### Before Deploy
Make sure you precompile the assets first

```
RAILS_ENV=test bundle exec rails assets:precompile
```

### Deploy command
```
gcloud app deploy
```

### Authenticate your Google Cloud account
```
gcloud auth application-default login
```

### Do not forget to Migrate the database for Dev and Prod
For Production (Google Cloud)
```
RAILS_ENV=production rake db:migrate
```

For Local Machine

```
rails db:migrate
```



