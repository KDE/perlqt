#!/usr/local/bin/perl -w

use strict;
use warnings;
use blib;

use Qt;

sub main {
    my $app = Qt::Application(\@ARGV);
    my $quit = Qt::PushButton("Quit");
    $quit->resize(150, 30);
    my $font = Qt::Font("Times", 18, 75);
    $quit->setFont( $font );

    Qt::Object::connect( $quit, SIGNAL "clicked()",
                         $app,  SLOT "quit()" );

    $quit->show();

    return $app->exec();
}

main();
