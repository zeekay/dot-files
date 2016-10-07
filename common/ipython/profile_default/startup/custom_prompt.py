from IPython.terminal.prompts import Prompts, Token
import os

class MyPrompt(Prompts):
     # def in_prompt_tokens(self, cli=None):
     #     return [(Token, os.getcwd()),
     #             (Token.Prompt, ' >>>')]

    def in_prompt_tokens(self, cli=None):   # custom
        path = os.path.basename(os.getcwd())
        return [
            (Token.Prompt, '>>> '),
        ]

ip = get_ipython()
ip.prompts = MyPrompt(ip)
