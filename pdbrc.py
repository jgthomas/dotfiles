
import pdb

class Config(pdb.DefaultConfig):

    def __init__(self, sticky_by_default=True):
        self.sticky_by_default = sticky_by_default
