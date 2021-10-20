from . import module_var 


def hello_world(name, where=module_var):
    return f"Hello {name}, welcome to {where}"
