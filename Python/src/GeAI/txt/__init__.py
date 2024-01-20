from .explain_code import explain_code
from .fix_grammar import fix_grammar
from .image import image
from .optimize_code import optimize_code
from .txt_default import txt_default

txt = txt_default
txt.explain_code = explain_code
txt.fix_grammar = fix_grammar
txt.image = image
txt.optimize_code = optimize_code