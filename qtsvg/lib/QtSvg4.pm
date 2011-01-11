#***************************************************************************
#                          QtSvg4.pm  -  QtSvg perl client lib
#                             -------------------
#    begin                : 06-19-2010
#    copyright            : (C) 2009 by Chris Burel
#    email                : chrisburel@gmail.com
# ***************************************************************************

#***************************************************************************
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU General Public License as published by  *
# *   the Free Software Foundation; either version 2 of the License, or     *
# *   (at your option) any later version.                                   *
# *                                                                         *
# ***************************************************************************

package QtSvg4::_internal;

use strict;
use warnings;
use QtCore4;
use base qw(Qt::_internal);

sub init {
    foreach my $c ( @{getClassList()} ) {
        QtSvg4::_internal->init_class($c);
    }
}

sub normalize_classname {
    my ( $self, $cxxClassName ) = @_;
    $cxxClassName = $self->SUPER::normalize_classname( $cxxClassName );
    return $cxxClassName;
}

package QtSvg4;

use strict;
use warnings;
use QtCore4;

require XSLoader;

our $VERSION = '0.01';

XSLoader::load('QtSvg4', $VERSION);

QtSvg4::_internal::init();

1;

