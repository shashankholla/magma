from .compatibility import IntegerTypes


__all__ = ['AnonRef', 'InstRef', 'DefnRef', 'ArrayRef', 'TupleRef']


class Ref:
    def __str__(self):
        return str(self.name)

    def __repr__(self):
        return self.qualifiedname()


class AnonRef(Ref):
    def __init__(self):
        self.name = None

    def __str__(self):
        return f"AnonymousValue_{id(self)}"

    def qualifiedname(self, sep='.'):
        return f"AnonymousValue_{id(self)}"

    def anon(self):
        return True


class NamedRef(Ref):
    def __init__(self, name):
        self.name = name

    def __str__(self):
        return self.name

    def __repr__(self):
        return self.name

    def qualifiedname(self, sep="."):
        return self.name

    def anon(self):
        return False


class InstRef(Ref):
    def __init__(self, inst, name):
        if not inst:
            raise ValueError(f"Bad inst: {inst}")
        self.inst = inst
        self.name = name

    def qualifiedname(self, sep="."):
        name = self.name
        if isinstance(self.name, IntegerTypes):
            # Hack, Hack, Hack!
            if sep == ".":
                return f"{self.inst.name}[{self.name}]"
        return self.inst.name + sep + str(name)

    def anon(self):
        return False


class DefnRef(Ref):
    def __init__(self, defn, name):
        if not defn:
            raise ValueError(f"Bad defn: {defn}")
        self.defn = defn
        self.name = name

    def qualifiedname(self, sep="."):
        if sep == ".":
            return self.defn.__name__ + sep + self.name
        return self.name

    def anon(self):
        return False


class ArrayRef(Ref):
   def __init__(self, array, index):
       self.array = array
       self.index = index

   def __str__(self):
       return self.qualifiedname()

   def qualifiedname(self, sep="."):
       return f"{self.array.name.qualifiedname(sep=sep)}[{self.index}]"

   def anon(self):
       return self.array.name.anon()


class TupleRef(Ref):
   def __init__(self, tuple, index):
       self.tuple = tuple
       self.index = index

   def __str__(self):
       return self.qualifiedname()

   def qualifiedname(self, sep="."):
       return self.tuple.name.qualifiedname(sep=sep) + sep + str(self.index)

   def anon(self):
       return self.tuple.name.anon()
