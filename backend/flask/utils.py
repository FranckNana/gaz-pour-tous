
from json import JSONEncoder
def getParam(key, *args):
    for arg in args:
        v = arg.get(key)
        if v is not None:
            return v
    return None


def ignore_exception(IgnoreException=Exception,DefaultVal=None):
    """ Decorator for ignoring exception from a function
    e.g.   @ignore_exception(DivideByZero)
    e.g.2. ignore_exception(DivideByZero)(Divide)(2/0)
    """
    def dec(function):
        def _dec(*args, **kwargs):
            try:
                return function(*args, **kwargs)
            except IgnoreException:
                return DefaultVal
        return _dec
    return dec

sint = ignore_exception(ValueError)(int)

class MyEncoder(JSONEncoder):
    def default(self, o):
        return o.__dict__    

