package Connection;

use strict;
use warnings;
use QtCore4;
use QtGui4;
use QtSql4;

=begin

    This file defines a helper function to open a connection to an
    in-memory SQLITE database and to create a test table.

    If you want to use another database, simply modify the code
    below. All the examples in this directory use this function to
    connect to a database.

=cut

# [0]
sub createConnection
{
    my $db = Qt::SqlDatabase::addDatabase('QSQLITE');
    $db->setDatabaseName(':memory:');
    if (!$db->open()) {
        Qt::MessageBox::critical(0, qApp->tr('Cannot open database'),
            qApp->tr("Unable to establish a database connection.\n" .
                     'This example needs SQLite support. Please read ' .
                     'the Qt SQL driver documentation for information how ' .
                     "to build it.\n\n" .
                     'Click Cancel to exit.'), Qt::MessageBox::Cancel());
        return 0;
    }

    my $query = Qt::SqlQuery();
    $query->exec("create table person (id int primary key, " .
               "firstname varchar(20), lastname varchar(20))");
    $query->exec("insert into person values(101, 'Danny', 'Young')");
    $query->exec("insert into person values(102, 'Christine', 'Holand')");
    $query->exec("insert into person values(103, 'Lars', 'Gordon')");
    $query->exec("insert into person values(104, 'Roberto', 'Robitaille')");
    $query->exec("insert into person values(105, 'Maria', 'Papadopoulos')");

    $query->exec("create table offices (id int primary key," .
                                             "imagefile int," .
                                             "location varchar(20)," .
                                             "country varchar(20)," .
                                             "description varchar(100))");
    $query->exec("insert into offices " .
               "values(0, 0, 'Oslo', 'Norway'," .
               "'Oslo is home to more than 500 000 citizens and has a " .
               "lot to offer.It has been called \"The city with the big " .
               "heart\" and this is a nickname we are happy to live up to.')");
    $query->exec("insert into offices " .
               "values(1, 1, 'Brisbane', 'Australia'," .
               "'Brisbane is the capital of Queensland, the Sunshine State, " .
               "where it is beautiful one day, perfect the next.  " .
               "Brisbane is Australia''s 3rd largest city, being home " .
               "to almost 2 million people.')");
    $query->exec("insert into offices " .
               "values(2, 2, 'Redwood City', 'US'," .
               "'You find Redwood City in the heart of the Bay Area " .
               "just north of Silicon Valley. The largest nearby city is " .
               "San Jose which is the third largest city in California " .
               "and the 10th largest in the US.')");
    $query->exec("insert into offices " .
               "values(3, 3, 'Berlin', 'Germany'," .
               "'Berlin, the capital of Germany is dynamic, cosmopolitan " .
               "and creative, allowing for every kind of lifestyle. " .
               "East meets West in the metropolis at the heart of a " .
               "changing Europe.')");
    $query->exec("insert into offices " .
               "values(4, 4, 'Munich', 'Germany'," .
               "'Several technology companies are represented in Munich, " .
               "and the city is often called the \"Bavarian Silicon Valley\". " .
               "The exciting city is also filled with culture, " .
               "art and music. ')");
    $query->exec("insert into offices " .
               "values(5, 5, 'Beijing', 'China'," .
               "'Beijing as a capital city has more than 3000 years of " .
               "history. Today the city counts 12 million citizens, and " .
               "is the political, economic and cultural centre of China.')");

    $query->exec("create table images (locationid int, file varchar(20))");
    $query->exec("insert into images values(0, 'images/oslo.png')");
    $query->exec("insert into images values(1, 'images/brisbane.png')");
    $query->exec("insert into images values(2, 'images/redwood.png')");
    $query->exec("insert into images values(3, 'images/berlin.png')");
    $query->exec("insert into images values(4, 'images/munich.png')");
    $query->exec("insert into images values(5, 'images/beijing.png')");

    return 1;
}
# [0]

1;
