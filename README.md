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


* To populate packages in database:
```
Package.import_from_cran(30)
```


```
And now you can visit the site with the URL http://localhost:3000
```

* To update packages (There is cron job that does that every day at 4 am):
```
bundle exec rake import_packages:run
```

* To write crontab file for running rake tasks, execute this command:

```sh
$ whenever --update-crontab
```

### Code:

The code is developed by following basic Ruby OOP and SOLID priciples explained below : 

Single Responsibility Principle (SRP):
Each class has a single responsibility, making it easy to maintain and test.

PackageDownloader class is responsible for downloading the package information from CRAN.
PackageParser class is responsible for parsing the package information in a format that can be indexed.
PackageExtractor class is responsible for extracting package information from the package tarball.
PackageIndexer class is responsible for indexing package information in a structured format.

Open/Closed Principle (OCP):
The code is open to extension but closed to modification. It means the code can be easily extended by adding new functionality without modifying the existing code.
The CranPackageIndexer class can be extended to support new sources of package information or new ways of indexing the package information.

Liskov Substitution Principle (LSP):
The code follows LSP because the PackageExtractor class can be substituted with another class that has the same interface to extract package information.

Interface Segregation Principle (ISP):
The code follows ISP because each class has a well-defined interface with methods that are specific to its functionality.

Dependency Inversion Principle (DIP):
The code follows DIP because the CranPackageIndexer class depends on abstractions (PackageDownloader, PackageParser, and PackageIndexer) rather than concrete implementations. It means that the implementation of these classes can be changed without affecting the CranPackageIndexer class.

All the code is implemented by following the Test Driven Development approach(TDD) using RSpec.


### Scope for improvements: --

As far is backend is concerned if something that can be improved is performance . And due to lack of time I have not integrated Vue and Tailwind on frontend, using simple html show packages and done pagination using kaminari gem . So Frontend can be improved by integrating Vue.js and infinited loading and for search debounce can be implemented . 
