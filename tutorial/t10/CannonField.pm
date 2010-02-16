package CannonField;

use strict;
use warnings;
use blib;

use Qt;
use Qt::isa qw(Qt::QWidget);
use Qt::slots setAngle => ['int'],
              setForce => ['int'];
use Qt::signals angleChanged => ['int'],
                forceChanged => ['int'];

sub NEW {
    shift->SUPER::NEW(@_);

    this->{currentAngle} = 45;
    this->{currentForce} = 0;
    this->setPalette(Qt::QPalette(Qt::QColor(250,250,200)));
    this->setAutoFillBackground(1);
}

sub setAngle {
    my ( $angle ) = @_;
    if ($angle < 5) {
        $angle = 5;
    }
    if ($angle > 70) {
        $angle = 70;
    }
    if (this->{currentAngle} == $angle) {
        return;
    }
    this->{currentAngle} = $angle;
    this->update(this->cannonRect());
    this->update();
    this->emit( 'angleChanged', this->{currentAngle} );
}

sub setForce {
    my ( $force ) = @_;
    if ($force < 0) {
        $force = 0;
    }
    if (this->{currentForce} == $force) {
        return;
    }
    this->{currentForce} = $force;
    this->emit( 'forceChanged', this->{currentForce} );
}

sub paintEvent {
    my $painter = Qt::_internal::gimmePainter(this);

    $painter->setPen(Qt::Qt::NoPen());
    $painter->setBrush(Qt::QBrush(Qt::Qt::blue()));

    $painter->translate(0, this->rect()->height());
    $painter->drawPie(Qt::QRect(-35, -35, 70, 70), 0, 90 * 16);
    $painter->rotate(-(this->{currentAngle}));
    $painter->drawRect(Qt::QRect(30, -5, 20, 10));
    $painter->end();
}

sub cannonRect {
    my $result = Qt::QRect(0, 0, 50, 50);
    $result->moveBottomLeft(this->rect()->bottomLeft());
    return $result;
}

1;
