/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the tools applications of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial Usage
** Licensees holding valid Qt Commercial licenses may use this file in
** accordance with the Qt Commercial License Agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Nokia.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Nokia gives you certain additional
** rights.  These rights are described in the Nokia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef PLWRITEINCLUDES_H
#define PLWRITEINCLUDES_H

#include "treewalker.h"

#include <QtCore/QHash>
#include <QtCore/QMap>
#include <QtCore/QSet>
#include <QtCore/QString>

QT_BEGIN_NAMESPACE

class QTextStream;
class Driver;
class Uic;

namespace Perl {

struct WriteIncludes : public TreeWalker
{
    WriteIncludes(Uic *uic);

    void acceptUI(DomUI *node);
    void acceptWidget(DomWidget *node);
    void acceptLayout(DomLayout *node);
    void acceptSpacer(DomSpacer *node);
    void acceptProperty(DomProperty *node);
    void acceptWidgetScripts(const DomScripts &, DomWidget *, const DomWidgets &);

//
// custom widgets
//
    void acceptCustomWidgets(DomCustomWidgets *node);
    void acceptCustomWidget(DomCustomWidget *node);

//
// include hints
//
    void acceptIncludes(DomIncludes *node);
    void acceptInclude(DomInclude *node);

    bool scriptsActivated() const { return m_scriptsActivated; }

private:
    void add(const QString &className, bool determineHeader = true, const QString &header = QString(), bool global = false);

private:
    typedef QMap<QString, bool> OrderedSet;
    void insertIncludeForClass(const QString &className, QString header = QString(), bool global = false);
    void insertInclude(const QString &header, bool global);
    void writeHeaders(const OrderedSet &headers, bool global);
    QString headerForClassName(const QString &className) const;
    void activateScripts();

    const Uic *m_uic;
    QTextStream &m_output;

    OrderedSet m_localIncludes;
    OrderedSet m_globalIncludes;
    QSet<QString> m_includeBaseNames;

    QSet<QString> m_knownClasses;

    typedef QMap<QString, QString> StringMap;
    StringMap m_classToHeader;
    StringMap m_oldHeaderToNewHeader;

    bool m_scriptsActivated;
};

} // namespace CPP

QT_END_NAMESPACE

#endif // PLWRITEINCLUDES_H
