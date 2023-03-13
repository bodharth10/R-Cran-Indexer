## Technologies:

* Ruby 2.6.3
* Ruby 6.1.7
* Postgresql

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

* To fetch and update packages (There's a cron job that does that every day at 4 am):
```
bundle exec rake import_packages:run
```

To write crontab file for running rake tasks, execute this command:

```sh
$ whenever --update-crontab
```

### Code:

The code is developed by following basic ruby OOP and SOLID priciples explained below : 

Single Responsibility Principle (SRP): Each class has a single responsibility. For example, the PackageIndexer class is responsible for indexing packages, the PackageFetcher class is responsible for fetching packages, the PackageParser class is responsible for parsing packages, and so on.

Open/Closed Principle (OCP): The code is open for extension but closed for modification. For example, the PackageIndexer class can be extended to support indexing packages from other package managers, without modifying its existing code.

Dependency Inversion Principle (DIP): The code uses dependency injection to invert dependencies. For example, the PackageIndexer class takes instances of PackageFetcher, PackageParser, and PackageDownloader classes as constructor arguments. This allows for flexibility and testability, as different implementations of these classes can be injected into the PackageIndexer class, without modifying its existing code.


### Scope for improvements: --

As far is backend is concerned if something that can be improved is performance . And due to lack of time I have not integrated Vue and Tailwind on frontend and using basic erb. So Frontend can be improved by using Vue and infinited loading or pagination can be implemented .  
