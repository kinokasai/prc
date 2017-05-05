from panflute import *
import sys

def fragilise(elt, doc):
    if type(elt) == Header and elt.level == 2:
      elt.classes.append('fragile')

def main(doc=None):
    return run_filter(fragilise, doc=doc)

if __name__ == "__main__":
    main()