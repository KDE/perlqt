package MainWindow;

use strict;
use warnings;
use QtCore4;
use QtGui4;

use XbelTree;

use QtCore4::isa qw( Qt::MainWindow );
use QtCore4::slots
    open => [],
    saveAs => [],
    about => [];

sub xbelTree() {
    return this->{xbelTree};
}

sub fileMenu() {
    return this->{fileMenu};
}

sub helpMenu() {
    return this->{helpMenu};
}

sub openAct() {
    return this->{openAct};
}

sub saveAsAct() {
    return this->{saveAsAct};
}

sub exitAct() {
    return this->{exitAct};
}

sub aboutAct() {
    return this->{aboutAct};
}

sub aboutQtAct() {
    return this->{aboutQtAct};
}

sub NEW
{
    my ( $class ) = @_;
    $class->SUPER::NEW();

    this->{xbelTree} = XbelTree();
    setCentralWidget(xbelTree);

    createActions();
    createMenus();

    statusBar()->showMessage(this->tr('Ready'));

    setWindowTitle(this->tr('DOM Bookmarks'));
    resize(480, 320);
}

sub open
{
    my $fileName =
            Qt::FileDialog::getOpenFileName(this, this->tr('Open Bookmark File'),
                                         Qt::Dir::currentPath(),
                                         this->tr('XBEL Files (*.xbel *.xml)'));
    if (!$fileName) {
        return;
    }

    my $file = Qt::File($fileName);
    if (!$file->open(Qt::File::ReadOnly() | Qt::File::Text())) {
        Qt::MessageBox::warning(this, this->tr('SAX Bookmarks'),
                             sprintf this->tr("Cannot read file %s:\n%s."),
                             $fileName,
                             $file->errorString());
        return;
    }

    if (xbelTree->read($file)) {
        statusBar()->showMessage(this->tr('File loaded'), 2000);
    }
}

sub saveAs
{
    my $fileName =
            Qt::FileDialog::getSaveFileName(this, this->tr('Save Bookmark File'),
                                         Qt::Dir::currentPath(),
                                         this->tr('XBEL Files (*.xbel *.xml)'));
    if (!$fileName) {
        return;
    }

    my $file = Qt::File($fileName);
    if (!$file->open(Qt::File::WriteOnly() | Qt::File::Text())) {
        Qt::MessageBox::warning(this, this->tr('SAX Bookmarks'),
                             sprintf this->tr("Cannot write file %s:\n%s."),
                             $fileName,
                             $file->errorString());
        return;
    }

    if (xbelTree->write($file)) {
        statusBar()->showMessage(this->tr('File saved'), 2000);
    }
    $file->close();
}

sub about
{
   Qt::MessageBox::about(this, this->tr('About DOM Bookmarks'),
                      this->tr('The <b>DOM Bookmarks</b> example demonstrates how to ' .
                         'use Qt\'s DOM classes to read and write XML ' .
                         'documents.'));
}

sub createActions
{
    this->{openAct} = Qt::Action(this->tr('&Open...'), this);
    openAct->setShortcuts(Qt::KeySequence::Open());
    this->connect(openAct, SIGNAL 'triggered()', this, SLOT 'open()');

    this->{saveAsAct} = Qt::Action(this->tr('&Save As...'), this);
    saveAsAct->setShortcuts(Qt::KeySequence::SaveAs());
    this->connect(saveAsAct, SIGNAL 'triggered()', this, SLOT 'saveAs()');

    this->{exitAct} = Qt::Action(this->tr('E&xit'), this);
    exitAct->setShortcuts(Qt::KeySequence::Quit());
    this->connect(exitAct, SIGNAL 'triggered()', this, SLOT 'close()');

    this->{aboutAct} = Qt::Action(this->tr('&About'), this);
    this->connect(aboutAct, SIGNAL 'triggered()', this, SLOT 'about()');

    this->{aboutQtAct} = Qt::Action(this->tr('About &Qt'), this);
    this->connect(aboutQtAct, SIGNAL 'triggered()', qApp, SLOT 'aboutQt()');
}

sub createMenus
{
    this->{fileMenu} = menuBar()->addMenu(this->tr('&File'));
    fileMenu->addAction(openAct);
    fileMenu->addAction(saveAsAct);
    fileMenu->addAction(exitAct);

    this->menuBar()->addSeparator();

    this->{helpMenu} = menuBar()->addMenu(this->tr('&Help'));
    helpMenu->addAction(aboutAct);
    helpMenu->addAction(aboutQtAct);
}

1;
