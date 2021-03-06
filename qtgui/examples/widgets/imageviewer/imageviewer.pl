#!/usr/bin/perl

use strict;
use warnings;

use QtCore4;
use QtGui4;
use ImageViewer;

sub main {
    my $app = Qt::Application( \@ARGV );
    my $imageViewer = ImageViewer();
    $imageViewer->show();
    return $app->exec();
}

exit main();
