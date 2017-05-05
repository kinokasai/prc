from panflute import *
import sys

def underline(elt, doc):
  pass
  # if type(elt) == Header and elt.level == 3:
  #   contents = [Strong(c) for c in elt.content]
  #   sys.stderr.write(str(contents))
  #   return Header(*contents, level=3)

def main(doc=None):
  return run_filter(underline, doc=doc)

if __name__ == "__main__":
  main()