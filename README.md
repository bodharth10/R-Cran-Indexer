## Technologies:

* Ruby 2.6.3
* Ruby 6.1.7


### Setup

Navigate to directory where the code script is located

```sh
$ cd ~/cran_indexer
```
Install the dependencies and devDependencies.

```sh
$ rvm use 2.6.3
````
```
$ bundle install
```

```
$ rails db:setup
```


### Steps to run Application

```sh
$ foreman start
```


Run the all test files as follows:
```sh
$ bundle rspec
```

To write crontab file for fetching and updating the packages, execute this command:

```sh
$ whenever --update-crontab
```

<!-- 
### Code:


### Scope for improvements: -->
