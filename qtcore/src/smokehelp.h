#ifndef SMOKEHELP_H
#define SMOKEHELP_H

/*
This file contains utility classes that make interacting with smoke types and
smoke classes easier
*/

#include "QtCore/QByteArray" // for qstrcmp

#include "smoke.h"

class SmokeType {
    // derived from _smoke and _id, but cached.  Index into types[] in smokedata.cpp

    Smoke::Type *_t;
    Smoke *_smoke;
    Smoke::Index _id;
public:
    SmokeType() : _t(0), _smoke(0), _id(0) {}
    SmokeType(Smoke *s, Smoke::Index i) : _smoke(s), _id(i) {
        if(_id < 0 || _id > _smoke->numTypes) _id = 0;
        _t = _smoke->types + _id;
    }
    // default copy constructors are fine, this is a constant structure

    // mutators
    void set(Smoke *s, Smoke::Index i) {
        _smoke = s;
        _id = i;
        _t = _smoke->types + _id;
    }
  
    // accessors
    Smoke *smoke() const { return _smoke; }
    Smoke::Index typeId() const { return _id; }
    const Smoke::Type &type() const { return *_t; }
    unsigned short flags() const { return _t->flags; }
    unsigned short elem() const { return _t->flags & Smoke::tf_elem; }
    const char *name() const { return _t->name; }
    Smoke::Index classId() const { return _t->classId; }

    // tests
    bool isStack() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_stack); }
    bool isPtr() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_ptr); }
    bool isRef() const { return ((flags() & Smoke::tf_ref) == Smoke::tf_ref); }
    bool isConst() const { return (flags() & Smoke::tf_const); }
    bool isClass() const {
        if(elem() == Smoke::t_class)
            return classId() ? true : false;
        return false;
    }

    bool operator ==(const SmokeType &b) const {
        const SmokeType &a = *this;
        if(a.name() == b.name()) return true;
        if(a.name() && b.name() && !strcmp(a.name(), b.name()))
            return true;
        return false;
    }
    bool operator !=(const SmokeType &b) const {
        const SmokeType &a = *this;
        return !(a == b);
    }
};

class SmokeClass {
    Smoke::Class *_c;
    Smoke *_smoke;
    Smoke::Index _id;
public:
    SmokeClass(const SmokeType &t) {
	_smoke = t.smoke();
	_id = t.classId();
	_c = _smoke->classes + _id;
    }
    SmokeClass(Smoke *smoke, Smoke::Index id) : _smoke(smoke), _id(id) {
	_c = _smoke->classes + _id;
    }

    Smoke *smoke() const { return _smoke; }
    const Smoke::Class &c() const { return *_c; }
    Smoke::Index classId() const { return _id; }
    const char *className() const { return _c->className; }
    Smoke::ClassFn classFn() const { return _c->classFn; }
    Smoke::EnumFn enumFn() const { return _c->enumFn; }
    bool operator ==(const SmokeClass &b) const {
	const SmokeClass &a = *this;
	if(a.className() == b.className()) return true;
	if(a.className() && b.className() && qstrcmp(a.className(), b.className()) == 0)
	    return true;
	return false;
    }
    bool operator !=(const SmokeClass &b) const {
	const SmokeClass &a = *this;
	return !(a == b);
    }
    bool isa(const SmokeClass &sc) const {
	// This is a sick function, if I do say so myself
	if(*this == sc) return true;
	Smoke::Index *parents = _smoke->inheritanceList + _c->parents;
	for(int i = 0; parents[i]; i++) {
	    if(SmokeClass(_smoke, parents[i]).isa(sc)) return true;
	}
	return false;
    }

    unsigned short flags() const { return _c->flags; }
    bool hasConstructor() const { return flags() & Smoke::cf_constructor; }
    bool hasCopy() const { return flags() & Smoke::cf_deepcopy; }
    bool hasVirtual() const { return flags() & Smoke::cf_virtual; }
    bool hasFire() const { return !(flags() & Smoke::cf_undefined); }
};

#endif //SMOKEHELP_H
