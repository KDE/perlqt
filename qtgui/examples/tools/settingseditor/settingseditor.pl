#!/usr/bin/perl

use strict;
use warnings;

use strict;
use warnings;
use QtCore4;
use QtGui4;
use MainWindow;

sub main
{
    my $app = Qt::Application(\@ARGV);
    my $mainWin = MainWindow();
    $mainWin->show();
    return $app->exec();
}

exit main();
